pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

ShellRoot {
    id: root

    readonly property color cFgLabel: "#c0caf5"
    readonly property color cFgText: "#a9b1d6"
    readonly property color cFgComment: "#565f89"
    readonly property color cTan: "#cfc9c2"
    readonly property color cBlue: "#7aa2f7"
    readonly property color cCyan: "#7dcfff"
    readonly property color cBgLight: "#1f2231"
    readonly property color cBgDark: "#1a1b26"
    readonly property color cBorder: "#3b4261"
    readonly property color cBorderHover: "#545c7e"
    readonly property color cBorderActive: "#737aa2"
    readonly property color cShadow: "#0c0e14"
    readonly property int radius: 4
    readonly property int sWidth: 2
    readonly property int offset: sWidth / 2
    readonly property font font: ({
            family: "JetBrainsMono NFP",
            pointSize: 13,
            bold: true
        })

    ScriptModel {
        id: wspsModel
        property bool ready: false
        property int focused: 0
        property int previous: 0
        values: [...Hyprland.workspaces.values].filter(entry => !isNaN(entry.name)).sort((a, b) => Math.abs(a.id) < Math.abs(b.id) ? -1 : 1)

        function inbounds(i) {
            return i > 0 && i < values.length - 1;
        }
    }

    Connections {
        target: Hyprland
        // Hack fuck workaround to get focused workspace detection to work at launch
        function onRawEvent(event) {
            if (event.name === "openlayer" && event.data === "quickshell") {
                wspsModel.ready = true;
                wspsModel.focused = Hyprland.focusedWorkspace.id;
            }
        }

        function onFocusedWorkspaceChanged() {
            if (!wspsModel.ready)
                return;
            wspsModel.previous = wspsModel.focused;
            wspsModel.focused = Hyprland.focusedWorkspace.id;
        }
    }

    Connections {
        target: Quickshell
        function onReloadCompleted() {
            console.log("SWAG!");
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            // qmllint disable uncreatable-type
            PanelWindow {
                // qmllint enable uncreatable-type
                id: bar

                required property var modelData
                screen: modelData
                visible: Hyprland?.monitorFor(modelData)?.focused ?? false

                color: "transparent"
                implicitHeight: 26
                aboveWindows: false

                anchors {
                    left: true
                    top: true
                    right: true
                }

                Quad {
                    id: barVis
                    readonly property real spacing: 6

                    radius: 4
                    radiusBl: 6
                    radiusBr: 6
                    borderColor: root.cBorder
                    borderWidth: 2

                    anchors {
                        fill: parent
                    }

                    gradient: LinearGradient {
                        y2: barVis.height
                        GradientStop {
                            position: 0
                            color: root.cBgDark
                        }

                        GradientStop {
                            position: 1
                            color: root.cBgLight
                        }
                    }

                    transform: Translate {
                        y: -2
                    }

                    Row {
                        id: wsps

                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                            top: parent.top
                            topMargin: 2
                        }

                        Repeater {
                            id: wspsRepeat
                            model: wspsModel

                            MouseArea {
                                id: wspBtn
                                required property int index
                                required property var modelData
                                implicitWidth: index > 0 && index < wspsRepeat.count - 1 ? wspVisLo.width + barVis.spacing : wspVisLo.width + barVis.spacing / 2
                                implicitHeight: parent.height

                                hoverEnabled: true
                                cursorShape: modelData.focused ? Qt.ArrowCursor : Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus { workspace = 'name:${modelData.name}', on_current_monitor = true }` : `workspace name:${modelData.name}`)

                                ScriptModel {
                                    id: wspIcons
                                    values: wspBtn.modelData.toplevels.values.map(toplevel => Quickshell.iconPath(DesktopEntries.heuristicLookup(toplevel.wayland?.appId ?? "")?.icon)).filter(x => x)
                                }

                                WspButton {
                                    id: wspVisLo
                                    index: wspBtn.index
                                    spacing: barVis.spacing
                                    icons: wspIcons

                                    color: wspBtn.findColor()
                                    text: wspBtn.modelData.name
                                    textColor: root.cTan
                                    style: Text.Raised
                                    font: root.font
                                }

                                WspButton {
                                    id: wspVisHi
                                    index: wspBtn.index
                                    spacing: barVis.spacing
                                    icons: wspIcons

                                    visible: wspBtn.modelData.id === wspsModel.focused || wspBtn.modelData.id === wspsModel.previous
                                    text: wspBtn.modelData.name
                                    textColor: root.cBgDark
                                    font: root.font
                                    gradient: LinearGradient {
                                        x2: wspBtn.height / 4.5
                                        y2: wspBtn.height
                                        GradientStop {
                                            position: 0
                                            color: root.cBlue
                                        }
                                        GradientStop {
                                            position: 1
                                            color: root.cCyan
                                        }
                                    }

                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        maskEnabled: true
                                        maskSource: wspMask
                                    }
                                }

                                Item {
                                    id: wspMask
                                    anchors.fill: parent
                                    layer.enabled: true
                                    visible: false
                                    Rectangle {
                                        anchors {
                                            top: parent.top
                                            bottom: parent.bottom
                                        }
                                        radius: 4.5
                                        width: parent.width
                                        x: wspMask.findPos()

                                        Behavior on x {
                                            SpringAnimation {
                                                easing.type: Easing.Linear
                                                spring: 5
                                                damping: 0.4
                                                mass: 0.8
                                                epsilon: 0.25
                                            }
                                        }
                                    }
                                    function findPos() {
                                        if (wspBtn.modelData.focused)
                                            return 0;
                                        if (Math.abs(wspBtn.modelData.id) < Math.abs(wspsModel.focused))
                                            return width + 1;
                                        else
                                            return -width - 1;
                                    }

                                    function bothWspsAreActive() {
                                        let previous = false;
                                        let focused = false;
                                        for (const [i, wsp] of wspsModel.values.entries()) {
                                            if (wsp.id === wspsModel.previous && wsp.active)
                                                previous = true;
                                            if (wsp.id === wspsModel.focused && wsp.active)
                                                focused = true;
                                        }
                                        return focused && previous;
                                    }
                                }

                                function findColor() {
                                    if (containsPress)
                                        return root.cBorderActive;
                                    if (containsMouse)
                                        return root.cBorderHover;
                                    return root.cBorder;
                                }
                            }
                        }
                    }

                    Item {
                        id: timedate

                        anchors {
                            bottom: parent.bottom
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 2
                        }

                        Quad {
                            id: exeButton
                            anchors {
                                bottom: parent.bottom
                                top: parent.top
                                horizontalCenter: parent.horizontalCenter
                            }
                            width: 26
                            radius: 6
                            radiusBl: 3
                            radiusBr: 3
                            borderWidth: 0
                            color: root.cBorder

                            Text {
                                anchors {
                                    centerIn: parent
                                    horizontalCenterOffset: 1
                                }
                                text: "󰀻"
                                color: root.cTan
                            }
                        }

                        Text {
                            id: date
                            anchors {
                                top: parent.top
                                right: exeButton.left
                                rightMargin: 22
                            }
                            text: Qt.formatDate(clock.date, "ddd, MMM dd")
                            font: root.font
                            color: root.cFgLabel

                            FlashAnimation {
                                id: dateFlash
                                target: date
                            }

                            onTextChanged: {
                                dateFlash.start();
                            }
                        }

                        Item {
                            id: time
                            property string text: Qt.formatTime(clock.date, "hh:mm AP")
                            anchors {
                                left: exeButton.right
                                leftMargin: 22
                                bottom: parent.bottom
                                top: parent.top
                            }

                            Text {
                                id: timeHM
                                anchors {
                                    left: parent.left
                                    verticalCenter: parent.verticalCenter
                                }
                                text: time.text.substring(0, 5)
                                font: root.font
                                color: root.cFgLabel

                                FlashAnimation {
                                    id: timeHMAnim
                                    target: timeHM
                                }

                                onTextChanged: {
                                    Qt.callLater(() => timeHMAnim.start());
                                }
                            }

                            Text {
                                id: timeAP
                                anchors {
                                    left: timeHM.right
                                    verticalCenter: parent.verticalCenter
                                }
                                text: time.text.substring(5)
                                font: root.font
                                color: root.cFgLabel

                                FlashAnimation {
                                    id: timeAPAnim
                                    target: timeAP
                                }

                                onTextChanged: {
                                    Qt.callLater(() => timeAPAnim.start());
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    component Quad: Shape {
        id: quad

        property alias color: path.fillColor
        property alias borderColor: path.strokeColor
        property alias gradient: path.fillGradient
        property real radius: 0
        property alias borderWidth: path.strokeWidth
        readonly property real _borderWidth: borderWidth !== 0 ? borderWidth / 2 : 0
        readonly property real _radiusOffset: borderWidth !== 0 ? borderWidth / 4 : 0
        property real radiusTl: radius
        property real radiusTr: radius
        property real radiusBl: radius
        property real radiusBr: radius

        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            id: path

            startX: quad.radiusTl + quad._borderWidth
            startY: quad._borderWidth

            PathLine {
                x: quad.width - quad.radiusTr - quad._borderWidth
                relativeY: 0
            }

            PathArc {
                x: quad.width - quad._borderWidth
                y: quad.radiusTr + quad._borderWidth
                radiusX: quad.radiusTr - quad._radiusOffset
                radiusY: quad.radiusTr - quad._radiusOffset
            }

            PathLine {
                relativeX: 0
                y: quad.height - quad.radiusBr - quad._borderWidth
            }

            PathArc {
                x: quad.width - quad.radiusBr - quad._borderWidth
                y: quad.height - quad._borderWidth
                radiusX: quad.radiusBr - quad._radiusOffset
                radiusY: quad.radiusBr - quad._radiusOffset
            }

            PathLine {
                x: quad.radiusBl + quad._borderWidth
                relativeY: 0
            }

            PathArc {
                x: quad._borderWidth
                y: quad.height - quad.radiusBl - quad._borderWidth
                radiusX: quad.radiusBl - quad._radiusOffset
                radiusY: quad.radiusBl - quad._radiusOffset
            }

            PathLine {
                relativeX: 0
                y: quad.radiusTl + quad._borderWidth
            }

            PathArc {
                x: quad.radiusTl + quad._borderWidth
                y: quad._borderWidth
                radiusX: quad.radiusTl - quad._radiusOffset
                radiusY: quad.radiusTl - quad._radiusOffset
            }
        }
    }
    component WspButton: Quad {
        id: quad
        required property int index
        required property real spacing
        required property ScriptModel icons
        property string text: ""
        property color textColor: "white"
        property font font: root.font
        property var style: Text.Normal
        property color styleColor: Text.Normal

        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: findSpacing()
        }
        width: contents.width
        borderWidth: 0
        radius: 6
        radiusBl: 3
        radiusBr: 3

        Row {
            id: contents
            anchors {
                left: parent.left
                bottom: parent.bottom
                top: parent.top
            }

            Item {
                id: text
                anchors {
                    bottom: parent.bottom
                    top: parent.top
                }
                width: 16
                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }
                    text: quad.text
                    font: quad.font
                    color: quad.textColor
                    style: quad.style
                    styleColor: quad.styleColor
                    topPadding: 2
                }
            }

            Row {
                id: icons
                spacing: 6
                leftPadding: 6
                rightPadding: iconsRepeat.count > 0 ? 6 : 1.125
                anchors {
                    bottom: parent.bottom
                    top: parent.top
                }
                Repeater {
                    id: iconsRepeat
                    model: quad.icons

                    IconImage {
                        required property string modelData

                        anchors {
                            bottom: parent.bottom
                            top: parent.top
                        }
                        source: modelData
                        implicitSize: parent.height * 2 / 3
                        mipmap: true
                    }
                }
            }
        }

        function findSpacing() {
            if (quad.index === 0)
                return -quad.spacing / 4;
            if (quad.index === wspsModel.values.length)
                return quad.spacing / 4;
            return 0;
        }
    }

    component FlashAnimation: SequentialAnimation {
        id: flash
        required property var target
        PropertyAction {
            target: flash.target
            property: "color"
            value: root.cFgText
        }
        PauseAnimation {
            duration: 333
        }
        PropertyAction {
            target: flash.target
            property: "color"
            value: root.cFgLabel
        }
    }
}
