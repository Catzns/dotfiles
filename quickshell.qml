pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets

ShellRoot {
    id: root

    // qmlformat off
    readonly property var iconRules: [
        { c: new RegExp(`
            ^$|
            hyprland-share-picker|
            soffice
        `), i: "" },

        { c: /footclient|^foot$/, t: [
            { t: /nvim .*|vim .*|vi .*/, i: "" },
            { t: /Yazi:.*/, i: "󰇥" },
            { t: /emacs .*|emacsclient .*/, i: "" }
        ], i: "󰆍" },

        { c: /firefox/, t: [
            { t: /Mozilla Firefox Private Browsing/, i: "󰗹" },
            { t: /YouTube — Mozilla Firefox/, i: "" }
        ], i: "󰈹" },

        { c: /virt-manager/, t: [
            { t: /on /, i: "" },
        ], i: "" },

        { c: /steam_app_\d/, t: [
            { t: /OmegaStrikers/, i: "󰏉" }
        ], i: "󰊴" },

        { c: /hl2_linux/, t: [
            { t: /Left 4 Dead 2/, i: "󰩒" },
        ], i: "󰘧" },

        { c: /hyprpolkitagent/, i: "󰟵" },
        { c: /hyprland-donate-screen/, i: "" },
        { c: /thunar|xdg-desktop-portal-gtk|xarchiver/, i: "" },
        { c: /ristretto/, i: "" },
        { c: /pavucontrol/, i: "" },
        { c: /nwg-look/, i: "" },
        { c: /swappy/, i: "󰹑" },

        { c: /steam/, i: "" },
        { c: /tf_linux64/, i: "" },
        { c: /cs2/, i: "" },
        { c: /marbleblast|MarbleItUp/, i: ""},
        { c: /Minecraft|prismlauncher/, i: "󰍳" },
        { c: /Apprun|Slippi Launcher/, i: "" },
        { c: /r2modman/, i: "" },

        { c: /discord|vesktop/, i: "" },
        { c: /obsidian|joplin/, i: "󰠮"},
        { c: /Celluloid|^mpv$/, i: "" },
        { c: /qBittorrent/, i: "" },
        { c: /keepassxc/, i: "" },
        { c: /baobab/, i: "" },
        { c: /nordvpn-gui/, i: "󰖂" },
        { c: /kdenlive/, i: "" },
        { c: /krita/, i: "" },
        { c: /^obs$|obsproject/, i: "󰄄" },
        { c: /inkscape/, i: "" },
        { c: /gimp/, i: "" },
        { c: /blender/, i: "" },
        { c: /Audacity/, i: "󰋋" },
        { c: /vpkedit/, i: "󰘧" },

        { c: /libreoffice-startcenter/, i: "" },
        { c: /libreoffice-writer/, i: "" },
        { c: /libreoffice-calc/, i: "" },
        { c: /libreoffice-impress/, i: "" },
        { c: /libreoffice-draw/, i: "" },
        { c: /libreoffice-math/, i: "" },
        { c: /libreoffice-base/, i: "" },

        { c: /.*/, t: [
            { t: /Va-11 Hall-A: Cyberpunk Bartender Action/, i: "" },
        ], i: "󰖯" }
    ]
    // qmlformat on
    readonly property color cFgLabel: "#c0caf5"
    readonly property color cFgText: "#a9b1d6"
    readonly property color cFgComment: "#565f89"
    readonly property color cTan: "#cfc9c2"
    readonly property color cBlue: "#7aa2f7"
    readonly property color cCyan: "#7dcfff"
    readonly property color cGreen: "#9ece6a"
    readonly property color cMagenta: "#bb9af7"
    readonly property color cOrange: "#ff9e64"
    readonly property color cRed: "#f7768e"
    readonly property color cBgLight: "#1f2231"
    readonly property color cBgDark: "#1a1b26"
    readonly property color cBorder: "#3b4261"
    readonly property color cBorderHover: "#545c7e"
    readonly property color cBorderActive: "#737aa2"
    readonly property color cShadow: "#0c0e14"

    readonly property real spacing: 6
    readonly property real btnWidth: 26
    readonly property real borderSml: 3
    readonly property real borderBig: 6
    readonly property real borderSize: 2

    readonly property font fontText: ({
            family: "JetBrainsMono NFP",
            pointSize: 13,
            bold: true
        })
    readonly property font fontLabel: ({
            family: "JetBrainsMono NFP",
            pointSize: 13
        })

    // QtObject {
    //     id: hyprlandModel
    //     property var workspaces: []
    //     property var workspacesMap: ({})
    //     property var workspaceActive: ({})
    //     property var workspacePrevious: ({})
    //
    //     property Process getWorkspaces: Process {
    //         command: ["hyprctl", "workspaces", "-j"]
    //         stdout: StdioCollector {
    //             id: workspacesCollect
    //             onStreamFinished: {
    //                 hyprlandModel.workspaces = JSON.parse(workspacesCollect.text).filter(entry => !isNaN(entry.name)).sort((a, b) => Math.abs(a.id) - Math.abs(b.id));
    //                 for (let i = 0; i < hyprlandModel.workspaces.length; i++) {
    //                     let ws = hyprlandModel.workspaces[i];
    //                     ws.windows = [];
    //                     hyprlandModel.workspacesMap[Math.abs(ws.id)] = ws;
    //                 }
    //             }
    //         }
    //     }
    //     property Process getWindows: Process {
    //         command: ["hyprctl", "clients", "-j"]
    //         stdout: StdioCollector {
    //             id: windowsCollect
    //             onStreamFinished: {
    //                 let windows = JSON.parse(windowsCollect.text);
    //                 for (let i = 0; i < windows.length; i++) {
    //                     let wsp = windows[i].workspace;
    //                     hyprlandModel.workspacesMap[wsp.id].windows[i] = windows[i];
    //                 }
    //             }
    //         }
    //     }
    //     property Process getActiveWorkspace: Process {
    //         command: ["hyprctl", "activeworkspace", "-j"]
    //         stdout: StdioCollector {
    //             id: activeCollect
    //             onStreamFinished: {
    //                 let wsp = JSON.parse(activeCollect);
    //                 hyprlandModel.workspaceActive = hyprlandModel.workspacesMap[Math.abs(wsp.id)];
    //             }
    //         }
    //     }
    //
    //     function updateWorkspaces() {
    //         getWorkspaces.running = true;
    //     }
    //
    //     function updateActiveWorkspace() {
    //         getActiveWorkspace.running = true;
    //     }
    //
    //     function updateWindows() {
    //         getWindows.running = true;
    //     }
    //
    //     function updateAll() {
    //         updateWorkspaces();
    //         updateActiveWorkspace();
    //         updateWindows();
    //     }
    // }

    ScriptModel {
        id: wspsModel
        property int focused: 0
        property int previous: 0
        values: [...Hyprland.workspaces.values].filter(entry => !isNaN(entry.name)).sort((a, b) => Math.abs(a.id) - Math.abs(b.id))

        function inbounds(i) {
            return i > 0 && i < values.length - 1;
        }

        Component.onCompleted: {
            // Hack fuck reload to get appIds to register on startup
            Hyprland.refreshToplevels();
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            // Hack fuck IPC read to get active workspace to register on startup
            if (event.name === "openlayer" && event.data === "quickshell") {
                wspsModel.focused = Hyprland.focusedWorkspace.id;
            }
        }

        function onFocusedWorkspaceChanged() {
            wspsModel.previous = wspsModel.focused;
            wspsModel.focused = Hyprland.focusedWorkspace.id;
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            LazyLoader {
                id: barLoad
                required property var modelData
                active: Hyprland.monitorFor(modelData)?.focused ?? false

                // qmllint disable uncreatable-type
                PanelWindow {
                    id: bar
                    property bool animated: false
                    property bool powerMenuVisible: false

                    screen: barLoad.modelData
                    exclusionMode: ExclusionMode.Ignore
                    color: "transparent"
                    aboveWindows: powerMenuVisible

                    anchors {
                        left: true
                        bottom: true
                        top: true
                        right: true
                    }

                    mask: Region {
                        Region {
                            item: barContainer
                        }
                        Region {
                            item: bar.powerMenuVisible ? powerMenuLoad : null
                        }
                        Region {
                            item: appLauncherLoad
                        }
                    }

                    PanelWindow {
                        // qmllint enable uncreatable-type
                        anchors {
                            left: true
                            top: true
                            right: true
                        }
                        screen: barLoad.modelData
                        implicitHeight: 26
                        color: "transparent"
                        aboveWindows: false
                    }

                    Rectangle {
                        id: barBorder
                        z: -1
                        anchors {
                            fill: barContainer
                            leftMargin: root.btnWidth / 2
                            rightMargin: root.btnWidth / 2
                        }
                        color: root.cBorder
                    }

                    Rectangle {
                        id: barFill
                        z: 1
                        anchors {
                            fill: barContainer
                            leftMargin: root.btnWidth / 2
                            bottomMargin: root.borderSize
                            rightMargin: root.btnWidth / 2
                        }
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: root.cBgDark
                            }
                            GradientStop {
                                position: 1
                                color: root.cBgLight
                            }
                        }
                    }

                    Item {
                        id: barContainer
                        anchors {
                            left: parent.left
                            top: parent.top
                            right: parent.right
                        }
                        implicitHeight: 24
                        z: 1

                        Quad {
                            id: wspsMenuBtnVis
                            anchors {
                                left: parent.left
                                bottom: parent.bottom
                                top: parent.top
                            }
                            width: root.btnWidth
                            color: root.btnFindColor(wspMenuBtn.containsPress, wspMenuBtn.containsMouse)
                            borderWidth: 0

                            radiusTl: 0
                            radiusTr: root.borderBig
                            radiusBl: root.borderBig
                            radiusBr: root.borderSml

                            Text {
                                anchors {
                                    centerIn: parent
                                    horizontalCenterOffset: -1
                                }
                                topPadding: 1
                                font: root.fontText
                                text: ""
                                color: root.cCyan
                                style: Text.Raised
                            }

                            MouseArea {
                                id: wspMenuBtn
                                anchors.fill: parent
                                hoverEnabled: true
                            }
                        }

                        Row {
                            id: wsps

                            anchors {
                                left: wspsMenuBtnVis.right
                                leftMargin: root.spacing * 2
                                bottom: parent.bottom
                                top: parent.top
                            }

                            Repeater {
                                id: wspsRepeat
                                model: wspsModel

                                anchors.fill: parent

                                MouseArea {
                                    id: wspBtn
                                    required property int index
                                    required property var modelData
                                    readonly property int anchorSide: findSide()

                                    implicitWidth: anchorSide === 0 ? wspVisHi.width + root.spacing : wspVisHi.width + (root.spacing / 2)
                                    implicitHeight: parent.height

                                    hoverEnabled: true
                                    cursorShape: modelData.focused ? Qt.ArrowCursor : Qt.PointingHandCursor
                                    onClicked: Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus { workspace = 'name:${modelData.name}', on_current_monitor = true }` : `workspace name:${modelData.name}`)

                                    ScriptModel {
                                        id: wspIcons
                                        values: getIcons()

                                        function getIcons() {
                                            const dupes = new Set();
                                            return wspBtn.modelData.toplevels.values.map(top => {
                                                return {
                                                    icon: root.getWindowIcon(top.wayland.appId, top.wayland.title ?? null),
                                                    urgent: top.urgent
                                                };
                                            }).filter(top => {
                                                const duped = dupes.has(top.icon);
                                                dupes.add(top.icon);
                                                return !duped && /\S/.test(top.icon);
                                            });
                                        }
                                    }

                                    WspButton {
                                        id: wspVisLo
                                        anchorSide: wspBtn.anchorSide
                                        spacing: root.spacing
                                        toplevels: wspIcons

                                        color: root.btnFindColor(wspBtn.containsPress, wspBtn.containsMouse)
                                        text: wspBtn.modelData.name
                                        textColor: wspBtn.findTextColor()
                                        style: Text.Raised
                                        animated: bar.animated
                                    }

                                    WspButton {
                                        id: wspVisHi
                                        anchorSide: wspBtn.anchorSide
                                        spacing: root.spacing
                                        toplevels: wspIcons

                                        visible: wspBtn.modelData.id === wspsModel.focused || wspBtn.modelData.id === wspsModel.previous
                                        text: ""
                                        textColor: root.cBorder
                                        animated: bar.animated

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
                                        property bool animated: false

                                        Rectangle {
                                            anchors {
                                                top: parent.top
                                                bottom: parent.bottom
                                            }
                                            radius: 4.5
                                            width: parent.width
                                            x: wspMask.findPos()

                                            Behavior on x {
                                                enabled: bar.animated
                                                SequentialAnimation {
                                                    SwitchAnimation {}
                                                    PauseAnimation {
                                                        duration: 1
                                                    }
                                                    ScriptAction {
                                                        script: {
                                                            wspsModel.previous = wspsModel.focused;
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        function findPos() {
                                            if (wspBtn.modelData.focused) {
                                                return 0;
                                            }
                                            if (Math.abs(wspBtn.modelData.id) < Math.abs(wspsModel.focused))
                                                return width + 1;
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

                                    function findTextColor() {
                                        if (modelData.active)
                                            return root.cBlue;
                                        return root.cTan;
                                    }

                                    function findSide() {
                                        if (index === 0)
                                            return -1;
                                        if (index === wspsRepeat.count - 1)
                                            return 1;
                                        return 0;
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
                            }

                            Quad {
                                id: exeButton
                                anchors {
                                    bottom: parent.bottom
                                    top: parent.top
                                    horizontalCenter: parent.horizontalCenter
                                }
                                width: root.btnWidth
                                radius: root.borderBig
                                radiusBl: root.borderSml
                                radiusBr: root.borderSml
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
                                    rightMargin: root.spacing * 4
                                }
                                text: Qt.formatDate(clock.date, "ddd, MMM dd")
                                font: root.fontText
                                color: root.cFgLabel

                                FlashAnimation {
                                    id: dateFlash
                                    target: date
                                }

                                onTextChanged: {
                                    Qt.callLater(() => bar.animated ? dateFlash.start() : void 0);
                                }
                            }

                            Item {
                                id: time
                                property string text: Qt.formatTime(clock.date, "hh:mm AP")
                                anchors {
                                    left: exeButton.right
                                    leftMargin: root.spacing * 4
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
                                    font: root.fontText
                                    color: root.cFgLabel

                                    FlashAnimation {
                                        id: timeHMAnim
                                        target: timeHM
                                    }

                                    onTextChanged: {
                                        Qt.callLater(() => bar.animated ? timeHMAnim.start() : void 0);
                                    }
                                }

                                Text {
                                    id: timeAP
                                    anchors {
                                        left: timeHM.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    text: time.text.substring(5)
                                    font: root.fontText
                                    color: root.cFgLabel

                                    FlashAnimation {
                                        id: timeAPAnim
                                        target: timeAP
                                    }

                                    onTextChanged: {
                                        Qt.callLater(() => bar.animated ? timeAPAnim.start() : void 0);
                                    }
                                }
                            }
                        }

                        Quad {
                            id: powerBtnVis
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                                right: parent.right
                            }
                            width: root.btnWidth
                            borderWidth: 0
                            color: root.btnFindColor(powerBtn.containsPress, powerBtn.containsMouse)

                            radiusTl: root.borderBig
                            radiusTr: 0
                            radiusBl: root.borderSml
                            radiusBr: root.borderBig

                            Text {
                                anchors {
                                    centerIn: parent
                                    horizontalCenterOffset: -0.5
                                }
                                topPadding: 1
                                text: ""
                                font: root.fontText
                                color: root.cRed
                                style: Text.Raised
                            }

                            MouseArea {
                                id: powerBtn
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    bar.powerMenuVisible ? powerMenuLoad.item.close(bar.animated) : bar.powerMenuVisible = true;
                                }
                            }
                        }

                        Timer {
                            running: true
                            interval: 25
                            onTriggered: {
                                bar.animated = true;
                            }
                        }
                    }

                    Loader {
                        id: appLauncherLoad
                        active: true
                        anchors {
                            horizontalCenter: barContainer.horizontalCenter
                            top: barContainer.top
                        }
                        sourceComponent: Component {
                            Rectangle {
                                id: appLauncher
                                readonly property point pos: appLauncher.mapFromItem(barFill, x, barFill.height)
                                width: 384
                                height: barLoad.modelData.height * (2 / 3)
                                color: root.cBgLight

                                radius: root.borderBig
                                border.width: root.borderSize
                                border.color: root.cBorder

                                ScrollView {
                                    anchors {
                                        fill: parent
                                        margins: root.borderSize
                                        bottomMargin: root.borderBig
                                        topMargin: barContainer.height + root.borderBig
                                    }

                                    ScrollBar.vertical.contentItem: Rectangle {
                                        id: scrollBar
                                        implicitWidth: 6
                                        radius: 3
                                        color: root.cBorder
                                    }

                                    ListView {
                                        id: appList
                                        anchors.fill: parent
                                        spacing: root.spacing
                                        clip: true
                                        model: ScriptModel {
                                            values: [...DesktopEntries.applications.values].sort((a, b) => a.name.localeCompare(b.name))
                                        }
                                        delegate: MouseArea {
                                            id: appEntry
                                            required property var modelData
                                            anchors {
                                                left: parent.left
                                                right: parent.right
                                            }
                                            height: 32
                                            Rectangle {
                                                anchors.fill: parent
                                                color: "grey"
                                            }
                                            // Row {
                                            //     IconImage {
                                            //         implicitSize: 32
                                            //         source: Quickshell.iconPath(modelData.icon)
                                            //     }
                                            //     Text {
                                            //         anchors.verticalCenter: parent.verticalCenter
                                            //         font: root.fontText
                                            //         text: appEntry.modelData.name
                                            //         color: root.cFgLabel
                                            //         leftPadding: root.spacing * 2
                                            //     }
                                            // }
                                        }
                                    }
                                }

                                RadiusConcave {
                                    anchors {
                                        right: appLauncher.left
                                        rightMargin: -root.borderSize
                                    }
                                    size: root.borderBig
                                    borderWidth: root.borderSize
                                    fillColor: root.cBgLight
                                    strokeColor: root.cBorder

                                    state: "tr"
                                    y: Math.min(appLauncher.pos.y, appLauncher.height - appLauncher.radius - height)
                                }

                                RadiusConcave {
                                    anchors {
                                        left: appLauncher.right
                                        leftMargin: -root.borderSize
                                    }
                                    size: root.borderBig
                                    borderWidth: root.borderSize
                                    fillColor: root.cBgLight
                                    strokeColor: root.cBorder

                                    state: "tl"
                                    y: Math.min(appLauncher.pos.y, appLauncher.height - appLauncher.radius - height)
                                }
                            }
                        }
                    }

                    Loader {
                        id: powerMenuLoad
                        anchors {
                            top: barContainer.top
                            right: barContainer.right
                            rightMargin: root.borderBig * 2
                        }
                        active: bar.powerMenuVisible
                        // active: true
                        sourceComponent: Component {
                            Rectangle {
                                id: powerMenu
                                readonly property point pos: powerMenu.mapFromItem(barFill, x, barFill.height)
                                implicitWidth: items.width
                                color: root.cBgLight
                                border.color: root.cBorder
                                border.width: root.borderSize
                                radius: root.borderBig

                                Column {
                                    id: items
                                    anchors.bottom: powerMenu.bottom
                                    padding: root.spacing + powerMenu.border.width / 2
                                    topPadding: root.spacing
                                    // spacing: root.spacing
                                    Repeater {
                                        id: itemsRepeat
                                        model: [
                                            {
                                                icon: "󰌾",
                                                color: root.cMagenta,
                                                process: procLock
                                            },
                                            {
                                                icon: "󰗽",
                                                color: root.cCyan,
                                                process: procLogout
                                            },
                                            {
                                                icon: "",
                                                color: root.cGreen,
                                                process: procRestart
                                            },
                                            {
                                                icon: "",
                                                color: root.cRed,
                                                process: procShutdown
                                            },
                                        ]
                                        MouseArea {
                                            id: optionBtn
                                            required property var modelData
                                            required property int index
                                            readonly property bool first: index === 0
                                            readonly property bool last: index === itemsRepeat.count - 1
                                            readonly property real space: 6
                                            width: 64
                                            height: first || last ? width + space / 2 : width + space
                                            hoverEnabled: true
                                            onClicked: {
                                                modelData.process.running = true;
                                                powerMenu.close(false);
                                            }
                                            Rectangle {
                                                id: optionBtnVis
                                                anchors {
                                                    left: parent.left
                                                    right: parent.right
                                                    bottom: optionBtn.last ? parent.bottom : undefined
                                                    top: optionBtn.first ? parent.top : undefined
                                                    verticalCenter: !optionBtn.first && !optionBtn.last ? parent.verticalCenter : undefined
                                                }
                                                height: 64
                                                radius: root.borderSml
                                                color: root.btnFindColor(optionBtn.containsPress, optionBtn.containsMouse)

                                                Text {
                                                    anchors.centerIn: parent
                                                    font {
                                                        family: root.fontLabel.family
                                                        pixelSize: 48
                                                    }
                                                    text: optionBtn.modelData.icon
                                                    style: Text.Raised
                                                    color: optionBtn.modelData.color
                                                }
                                            }
                                        }
                                    }
                                }

                                HoverHandler {
                                    onHoveredChanged: {
                                        if (!hovered) {
                                            powerMenu.close(bar.animated);
                                        }
                                    }
                                }

                                RadiusConcave {
                                    anchors {
                                        right: powerMenu.left
                                        rightMargin: -root.borderSize
                                    }
                                    size: root.borderBig
                                    borderWidth: root.borderSize
                                    fillColor: root.cBgLight
                                    strokeColor: root.cBorder

                                    state: "tr"
                                    y: Math.min(powerMenu.pos.y, powerMenu.height - powerMenu.radius - height)
                                }

                                RadiusConcave {
                                    anchors {
                                        left: powerMenu.right
                                        leftMargin: -root.borderSize
                                    }
                                    size: root.borderBig
                                    borderWidth: root.borderSize
                                    fillColor: root.cBgLight
                                    strokeColor: root.cBorder

                                    state: "tl"
                                    y: Math.min(powerMenu.pos.y, powerMenu.height - powerMenu.radius - height)
                                }

                                SwitchAnimation {
                                    id: powerMenuOpen
                                    target: powerMenu
                                    property: "implicitHeight"
                                    from: barContainer.height
                                    to: barContainer.height + items.height
                                }

                                SwitchAnimation {
                                    id: powerMenuClose
                                    target: powerMenu
                                    property: "implicitHeight"
                                    from: barContainer.height + items.height
                                    to: barContainer.height

                                    onFinished: bar.powerMenuVisible = false
                                }

                                function open(animated) {
                                    if (animated)
                                        powerMenuOpen.start();
                                    else
                                        implicitHeight = barContainer.height + items.height;
                                }

                                function close(animated) {
                                    if (animated)
                                        powerMenuClose.start();
                                    else {
                                        implicitHeight = barContainer.height;
                                        bar.powerMenuVisible = false;
                                    }
                                }
                            }
                        }
                        onLoaded: item.open(bar.animated)
                    }
                }
            }
        }
    }

    Process {
        id: procLock
        command: ["loginctl", "lock-session"]
    }

    Process {
        id: procLogout
        command: ["loginctl", "terminateuser", '""']
    }

    Process {
        id: procRestart
        command: ["systemctl", "reboot"]
    }

    Process {
        id: procShutdown
        command: ["systemctl", "poweroff"]
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
        readonly property real _borderWidth: borderWidth > 0 ? borderWidth / 2 : 0
        readonly property real _radiusOffset: borderWidth > 0 ? borderWidth / 4 : 0
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

    component RadiusConcave: Shape {
        id: shape
        property real size
        property real borderWidth: 1
        readonly property real _borderWidth: borderWidth / 2
        property alias fillColor: fill.fillColor
        property alias strokeColor: stroke.strokeColor
        property point _beg
        property point _begOffset
        property point _mid
        property point _end
        property point _endOffset
        width: size + borderWidth
        height: size + borderWidth
        preferredRendererType: Shape.CurveRenderer
        state: "tl"
        states: [
            State {
                name: "tl"
                PropertyChanges {
                    target: shape
                    _beg: ({
                            x: shape.width,
                            y: 0
                        })
                    _begOffset: ({
                            x: -shape._borderWidth,
                            y: shape._borderWidth
                        })
                    _mid: ({
                            x: 0,
                            y: 0
                        })
                    _end: ({
                            x: 0,
                            y: shape.height
                        })
                    _endOffset: ({
                            x: shape._borderWidth,
                            y: -shape._borderWidth
                        })
                }
            },
            State {
                name: "tr"
                PropertyChanges {
                    target: shape
                    _beg: ({
                            x: shape.width,
                            y: shape.height
                        })
                    _begOffset: ({
                            x: -shape._borderWidth,
                            y: -shape._borderWidth
                        })
                    _mid: ({
                            x: shape.width,
                            y: 0
                        })
                    _end: ({
                            x: 0,
                            y: 0
                        })
                    _endOffset: ({
                            x: shape._borderWidth,
                            y: shape._borderWidth
                        })
                }
            },
            State {
                name: "bl"
                PropertyChanges {
                    target: shape
                    _beg: ({
                            x: 0,
                            y: 0
                        })
                    _begOffset: ({
                            x: shape._borderWidth,
                            y: shape._borderWidth
                        })
                    _mid: ({
                            x: 0,
                            y: shape.height
                        })
                    _end: ({
                            x: shape.width,
                            y: shape.height
                        })
                    _endOffset: ({
                            x: -shape._borderWidth,
                            y: -shape._borderWidth
                        })
                }
            },
            State {
                name: "br"
                PropertyChanges {
                    target: shape
                    _beg: ({
                            x: 0,
                            y: shape.height
                        })
                    _begOffset: ({
                            x: shape._borderWidth,
                            y: -shape._borderWidth
                        })
                    _mid: ({
                            x: shape.width,
                            y: shape.height
                        })
                    _end: ({
                            x: shape.width,
                            y: 0
                        })
                    _endOffset: ({
                            x: -shape._borderWidth,
                            y: shape._borderWidth
                        })
                }
            }
        ]
        ShapePath {
            id: fill
            strokeWidth: 0
            startX: shape._beg.x
            startY: shape._beg.y
            PathLine {
                x: shape._mid.x
                y: shape._mid.y
            }
            PathLine {
                x: shape._end.x
                y: shape._end.y
            }
            PathArc {
                x: shape._beg.x
                y: shape._beg.y
                radiusX: shape.width
                radiusY: shape.height
            }
        }
        ShapePath {
            id: stroke
            strokeColor: "black"
            fillColor: "transparent"
            strokeWidth: shape.borderWidth
            startX: shape._end.x + shape._endOffset.x
            startY: shape._end.y + shape._endOffset.y
            PathArc {
                x: shape._beg.x + shape._begOffset.x
                y: shape._beg.y + shape._begOffset.y
                radiusX: shape.width - shape.borderWidth
                radiusY: shape.height - shape.borderWidth
            }
        }
    }

    component WspButton: Quad {
        id: quad
        required property ScriptModel toplevels
        property int anchorSide: 0
        property real spacing: 0
        property bool offset: false
        property string text: ""
        property color textColor: "white"
        property var style: Text.Normal
        property color styleColor: Text.Normal
        property bool animated: false

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: anchorSide < 0 ? parent.left : undefined
            right: anchorSide > 0 ? parent.right : undefined
            horizontalCenter: anchorSide === 0 ? parent.horizontalCenter : undefined
        }

        width: contents.width
        borderWidth: 0
        radius: root.borderBig
        radiusBl: root.borderSml
        radiusBr: root.borderSml
        clip: true

        Behavior on width {
            enabled: quad.animated
            SwitchAnimation {}
        }

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
                width: root.btnWidth
                Text {
                    anchors {
                        centerIn: parent
                        horizontalCenterOffset: -0.25
                    }
                    text: quad.text
                    font: root.fontText
                    color: quad.textColor
                    style: quad.style
                    styleColor: quad.styleColor
                    topPadding: 2
                }
            }

            Row {
                id: toplevels
                spacing: root.spacing
                rightPadding: iconsRepeat.count > 0 ? root.spacing + 1 : 0
                anchors {
                    bottom: parent.bottom
                    top: parent.top
                }
                Repeater {
                    id: iconsRepeat
                    model: quad.toplevels

                    Text {
                        required property var modelData
                        anchors.verticalCenter: toplevels.verticalCenter
                        text: modelData.icon
                        font: root.fontLabel
                        color: modelData.urgent ? root.cOrange : quad.textColor
                        style: quad.style
                        styleColor: quad.styleColor
                        topPadding: 1
                    }
                }
            }
        }

        function isOnLeft() {
            if (quad.index === 0)
                return true;
            return false;
        }

        function isOnRight() {
            if (quad.index === quad.count - 1)
                return true;
            return false;
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

    component SwitchAnimation: SpringAnimation {
        spring: 5
        damping: 0.4
        mass: 0.8
        epsilon: 0.25
    }

    function getWindowIcon(c, t = null) {
        for (const exe of root.iconRules) {
            if (exe.c.test(c)) {
                if (!exe.t || !t)
                    return exe.i;
                for (const title of exe.t) {
                    if (title.t.test(t)) {
                        return title.i;
                    }
                }
                return exe.i;
            }
        }
        return "";
    }

    function btnFindColor(press, hover) {
        if (press)
            return root.cBorderActive;
        if (hover)
            return root.cBorderHover;
        return root.cBorder;
    }
}
