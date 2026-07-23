local r = require 'land.utils.regex'
local HYPRLAND = {}

HYPRLAND.apps = {
  power = 'rofi -show power -theme power -mode power',
  terminal = 'kitty --single-instance',
  menu = 'rofi -show drun -theme desktop',
  emoji = 'rofimoji --selector-args "-theme emoji"',
  files = 'thunar',
  notes = 'obsidian',
  password = 'keepassxc',
}

HYPRLAND.startup = {
  gui = 'waybar',
  terminal = HYPRLAND.apps.terminal .. ' --start-as hidden',
  background = 'awww-daemon -f abgr',
  idle = 'hypridle',
  notifs = 'swaync',
  files = 'thunar --daemon',
  sync = 'syncthing',
  lockscreen = 'hyprlock --no-fade-in --grace 0',
  filter = 'wlsunset -T 5800 -t 3400 -S 7:00 -s 18:00 -d 3600',
  polkit = '/usr/lib/hyprpolkitagent',
}

local _background = string.match(HYPRLAND.startup.background, '[^ ]+')
HYPRLAND.cmds = {
  refresh = string.format(
    'pkill -SIGUSR2 %s; pkill %s; %s; pkill %s; %s',
    HYPRLAND.startup.gui,
    HYPRLAND.startup.idle,
    HYPRLAND.startup.idle,
    _background,
    _background
  ),
  logout = 'loginctl terminate-user ""',
}

---@type selections
HYPRLAND.floats = {
  -- c: Class names, t: Title names
  { c = 'xdg-desktop-portal-gtk' },
  { c = 'org.pulseaudio.pavucontrol' },
  { c = 'org.gnome.FileRoller' },
  { c = 'file-png' },
  { c = 'org.keepassxc.KeePassXC' },

  { c = 'firefox', t = 'Library' },
  { c = 'thunar', t = r.c { 'Rename.*', 'File Operation Progress.*' } },

  { c = 'gimp', t = r.n(r.c { '.*- GIMP', 'GNU Image Manipulation Program' }) },
  { c = 'org.inkscape.Inkscape', t = r.n '.*Inkscape$' },
  { c = r.c { 'obs', 'com.obsproject.Studio' }, t = r.n 'OBS .*' },
  { c = 'org.kde.krita', t = r.n 'Krita' },
}

---@type selections
HYPRLAND.fullscreens = {
  -- c: Class names, t: Title names
  { c = 'hl2_linux,' },
  { c = 'cs2' },
  { c = 'tf_linux64' },
  { t = 'Marble Blast Ultra!.*' },
  { t = 'UltraRebirth.*' },
  { c = 'steam_app_\\d+', t = '.+' },
}

---@type resizes
HYPRLAND.resizes = {
  -- c: Class names, t: Title names
  -- x & y: Steps left / right ranging -10..10
  { c = 'steam', t = 'Friends List', x = -5 },
}

---@type selections
HYPRLAND.privates = {
  -- c: Class names, t: Title names
  { c = 'org.keepassxc.KeePassXC' },
}

HYPRLAND.colors = {
  border = '#414868',
  bg = '#1f2231',
  shadow = '#16161e',
  fg = '#c0caf5',
  comment = '#565f89',
  blue = '#7aa2f7',
  cyan = '#7dcfff',
  yellow = '#e08f68',
  yellow_bg = '#695641',
  orange = '#ff9e64',
  orange_bg = '#59353c',
  red = '#f7768e',
}

HYPRLAND.alphas = {
  high = 'ee',
  mid = 'cc',
  low = 'aa',
}

-- [[ ENVIRONMENT ]]
hl.exec_cmd '. ~/.profile'

-- Theming
hl.env('HYPRCURSOR_THEME', 'Bibata-Modern-Classic')

-- Background Transitions
hl.env('AWWW_TRANSITION', 'wipe')
hl.env('AWWW_TRANSITION_FPS', '60')
hl.env('AWWW_TRANSITION_DURATION', '0.2')
hl.env('AWWW_TRANSITION_BEZIER', '0.15,0,0.1,1')
HYPRLAND.transstep = 0.0625

-- Fixes
hl.env('GTK_BACKEND', 'wayland,x11,*')
hl.env('QT_QPA_PLATFORM', 'wayland')
hl.env('QT_QPA_PLATFORMTHEME', 'qt6ct')
hl.env('SDL_VIDEODRIVER', 'wayland')
hl.env('CLUTTER_BACKEND', 'wayland')
hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')

hl.curve('b', { type = 'bezier', points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve('f', { type = 'bezier', points = { { 0, 0 }, { 1, 1 } } })
hl.curve('s', { type = 'spring', mass = 1, stiffness = 512, dampening = 40.5 })

hl.animation { leaf = 'global', enabled = false }
hl.animation { leaf = 'windows', enabled = true, speed = 1, spring = 's', style = 'gnomed' }
hl.animation { leaf = 'fade', enabled = true, speed = 1, bezier = 'b' }
hl.animation { leaf = 'fadeSwitch', enabled = false, speed = 5, bezier = 'b' }
hl.animation { leaf = 'fadeLayers', enabled = true, speed = 1.5, bezier = 'b' }
hl.animation { leaf = 'fadeDpms', enabled = false }
hl.animation { leaf = 'border', enabled = true, speed = 0.66, bezier = 'b' }
hl.animation { leaf = 'layers', enabled = true, speed = 1, bezier = 'f', style = 'fade' }
hl.animation { leaf = 'workspaces', enabled = true, speed = 1, spring = 's', style = 'slide' }
hl.animation { leaf = 'specialWorkspace', enabled = true, speed = 1.5, bezier = 'b', style = 'fade' }
hl.animation { leaf = 'zoomFactor', enabled = true, speed = 0.5, bezier = 'b' }

return HYPRLAND
