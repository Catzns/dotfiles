local u = require 'hyprland-utils'
table.extend = u.extend

-- Refer to the wiki for details.
-- https://wiki.hypr.land/Configuring/

-- [[ VARIABLES ]]
local apps = {
  power = 'rofi -show power -theme power -mode power',
  terminal = 'footclient',
  menu = 'rofi -show drun -theme desktop',
  emoji = 'rofimoji --selector-args "-theme emoji"',
  files = 'thunar',
  notes = 'obsidian',
  password = 'keepassxc',
}

local startup = {
  gui = 'waybar',
  terminal = 'foot -s',
  background = 'awww-daemon -f abgr',
  idle = 'hypridle',
  notifs = 'swaync',
  files = 'thunar --daemon',
  sync = 'syncthing',
  lockscreen = 'hyprlock --no-fade-in --grace 0',
  filter = 'wlsunset -T 5800 -t 3400 -S 7:00 -s 18:00 -d 3600',
  polkit = '/usr/lib/hyprpolkitagent',
}

local _background = string.match(startup.background, '[^ ]+')
local cmds = {
  refresh = string.format('pkill -SIGUSR2 %s; pkill %s; %s; pkill %s; %s', startup.gui, startup.idle, startup.idle, _background, _background),
  logout = 'loginctl terminate-user ""',
}

---@type selections
local floats = {
  -- c: Class names, t: Title names
  { c = 'xdg-desktop-portal-gtk' },
  { c = 'org.pulseaudio.pavucontrol' },
  { c = 'org.gnome.FileRoller' },
  { c = 'file-png' },
  { c = 'org.keepassxc.KeePassXC' },

  { c = 'firefox', t = 'Library' },
  { c = 'thunar', t = u.rc { 'Rename.*', 'File Operation Progress.*' } },

  { c = 'gimp', t = u.rn(u.rc { '.*- GIMP', 'GNU Image Manipulation Program' }) },
  { c = 'org.inkscape.Inkscape', t = u.rn '.*Inkscape$' },
  { c = u.rc { 'obs', 'com.obsproject.Studio' }, t = u.rn 'OBS .*' },
  { c = 'org.kde.krita', t = u.rn 'Krita' },
}

---@type selections
local fullscreens = {
  -- c: Class names, t: Title names
  { c = 'hl2_linux,' },
  { c = 'cs2' },
  { c = 'tf_linux64' },
  { t = 'Marble Blast Ultra!.*' },
  { t = 'UltraRebirth.*' },
  { c = 'steam_app_\\d+', t = '.+' },
}

---@type resizes
local resizes = {
  -- c: Class names, t: Title names
  -- x & y: Steps left / right ranging -10..10
  { c = 'steam', t = 'Friends List', x = -5 },
}

---@type selections
local privates = {
  -- c: Class names, t: Title names
  { c = 'org.keepassxc.KeePassXC' },
}

local colors = {
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

local alphas = {
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
local transstep = 0.0625

-- Fixes
hl.env('GTK_BACKEND', 'wayland,x11,*')
hl.env('QT_QPA_PLATFORM', 'wayland')
hl.env('QT_QPA_PLATFORMTHEME', 'qt6ct')
hl.env('SDL_VIDEODRIVER', 'wayland')
hl.env('CLUTTER_BACKEND', 'wayland')
hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')

-- [[ MONITORS ]]
local monitors = u.buildmonitors()
if monitors then
  for _, monitor in ipairs(monitors) do
    hl.monitor {
      output = monitor.name,
      mode = 'highres',
      position = monitor.pos,
      scale = monitor.scale,
    }
  end
end

hl.monitor {
  output = '',
  mode = 'highres',
  position = 'auto',
  scale = 'auto',
}

-- [[ INITIALIZATION ]]
local function init()
  local wsp = hl.get_active_workspace()
  u.wstrack(wsp)
  u.montrack(wsp)
  u.buildbackgrounds()
end
init()

hl.on('hyprland.start', function()
  local tracking = hl.get_config 'misc.initial_workspace_tracking'
  hl.config { misc = { initial_workspace_tracking = 0 } }
  for _, program in pairs(startup) do
    hl.exec_cmd(program)
  end
  -- Temporary fix because screensharing shit the bed
  hl.exec_cmd 'systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland'
  hl.config { misc = { initial_workspace_tracking = tracking } }
end)

-- [[ AESTHETICS ]]
hl.config {
  group = {
    col = {
      border_active = u.border(colors.yellow, colors.orange),
      border_inactive = colors.yellow_bg .. alphas.mid,
      border_locked_active = u.border(colors.orange, colors.red),
      border_locked_inactive = colors.orange_bg .. alphas.mid,
    },

    groupbar = {
      text_color = colors.fg,
      text_color_inactive = colors.comment,
      text_padding = 2,
      font_family = 'JetBrainsMono NF ExtraBold, Sans',
      font_size = 15,

      height = 18,
      indicator_height = 0,
      gradients = true,
      gradient_rounding = 4,
      gradient_round_only_edges = false,
      gaps_in = 1,
      gaps_out = 2,
      keep_upper_gap = false,

      col = {
        active = colors.bg,
        inactive = colors.bg .. alphas.low,
        locked_active = colors.bg,
        locked_inactive = colors.bg .. alphas.low,
      },
    },
  },

  decoration = {
    rounding = 3,
    rounding_power = 3,

    active_opacity = 1.0,
    inactive_opacity = 0.98,
    dim_inactive = true,
    dim_strength = 0.0625,
    dim_special = 0.4,

    blur = {
      size = 4,
      passes = 1,
      noise = 0,
      contrast = 1,
      vibrancy = 0,
      vibrancy_darkness = 0,
      ignore_opacity = false,
    },

    shadow = {
      color = colors.shadow .. alphas.low,
      color_inactive = colors.shadow .. alphas.high,
    },

    glow = {
      range = 2,
      render_power = 1,
      color = colors.blue,
    },
  },

  animations = {
    enabled = true,
  },

  -- [[ CONFIGURATION ]]
  general = {
    layout = 'dwindle',

    gaps_in = 1,
    gaps_out = 0,
    border_size = 2,

    col = {
      active_border = u.border(colors.blue, colors.cyan),
      inactive_border = colors.border .. alphas.mid,
    },
  },

  dwindle = {
    preserve_split = true,
    split_bias = 1,
  },

  input = {
    repeat_delay = 300,
    accel_profile = 'flat',

    touchpad = {
      natural_scroll = true,
    },
  },

  cursor = {
    no_break_fs_vrr = true,
    default_monitor = 'DP-2',
    zoom_detached_camera = false,
  },

  binds = {
    workspace_center_on = 1,
    workspace_back_and_forth = true,
    hide_special_on_workspace_change = true,
  },

  render = {
    direct_scanout = 1,
  },

  misc = {
    -- vrr = 2,

    font_family = 'Inter, Sans',

    force_default_wallpaper = 2,
    disable_hyprland_logo = true,
    disable_splash_rendering = false,

    allow_session_lock_restore = true,

    anr_missed_pings = 15,
  },
}

-- [[ ANIMATIONS ]]
hl.curve('b', { type = 'bezier', points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve('f', { type = 'bezier', points = { { 0, 0 }, { 1, 1 } } })
hl.curve('s', { type = 'spring', mass = 1, stiffness = 66, dampening = 14.33 })

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

hl.gesture {
  fingers = 3,
  direction = 'horizontal',
  action = 'workspace',
}

-- [[ KEYBINDS ]]
-- Applications & Functions
hl.bind(u.k 'Escape', hl.dsp.exec_cmd(cmds.logout))
hl.bind(u.k 'Q', hl.dsp.exec_cmd(apps.power), { desc = '[Q]uit' })
hl.bind(u.k 'W', hl.dsp.exec_cmd(apps.notes), { desc = '[W]rite' })
hl.bind(u.k 'E', hl.dsp.exec_cmd(apps.emoji), { desc = '[E]moji' })
hl.bind(u.k 'R', hl.dsp.exec_cmd(cmds.refresh), { desc = '[R]efresh' })
hl.bind(u.k 'P', hl.dsp.exec_cmd(apps.password), { desc = '[P]asswords' })
hl.bind(u.k 'A', hl.dsp.exec_cmd(apps.menu), { desc = '[A]pplication' })
hl.bind(u.k 'S', function()
  local special = hl.get_active_special_workspace()
  if special and special.tiled_layout == 'scrolling' then
    hl.dispatch(hl.dsp.layout 'fit all')
  else
    hl.dispatch(hl.dsp.layout 'togglesplit')
  end
end, { desc = 'Swap / Shrink' })
hl.bind(u.k 'D', hl.dsp.exec_cmd(apps.files), { desc = '[D]irectory' })
hl.bind(u.k 'F', hl.dsp.window.float(), { desc = '[F]loat' })
hl.bind(u.k('ALT', 'F'), hl.dsp.window.fullscreen { mode = 'fullscreen', action = 'toggle' })
hl.bind(u.k 'Z', hl.dsp.group.toggle(), { desc = '[Z]ip' })
hl.bind(u.k 'X', hl.dsp.window.close(), { desc = 'e[X]it' })
hl.bind(u.k 'C', function()
  local terms = { 'foot', 'footclient' }
  local win = hl.get_active_window()
  for _, term in ipairs(terms) do
    if win and win.class == term then
      hl.dispatch(hl.dsp.send_shortcut {
        mods = 'CTRL, SHIFT',
        key = 'n',
        window = win,
      })
      return
    end
  end
  hl.exec_cmd(apps.terminal)
end, { desc = '[C]onsole' })
hl.bind(u.k 'V', function()
  if hl.get_config 'cursor.zoom_factor' == 1 then
    hl.config { cursor = { zoom_factor = 2 } }
  else
    hl.config { cursor = { zoom_factor = 1 } }
  end
end, { desc = '[V]iew' })
-- local super = u.gate()
-- hl.bind(u.k('SUPER', 'SUPER_L'), function()
--   u.doubletap(function()
--     hl.dispatch(hl.dsp.group.toggle())
--   end, super, 250)
-- end, { ignore_mods = true, desc = 'Window in Window' })

-- Movement & Resizing
local move = {
  dir = { 'r', 'l', 'd', 'u' },
  vim = { 'l', 'h', 'j', 'k' },
  arr = { 'right', 'left', 'down', 'up' },
}

for i = 1, 4 do
  hl.bind(u.k(move.vim[i]), function()
    u.focus_groupaware(move.dir[i])
  end, { repeating = true })
  hl.bind(u.k(move.arr[i]), function()
    u.focus_groupaware(move.dir[i])
  end, { repeating = true })
  hl.bind(u.k('CTRL', move.vim[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(u.k('CTRL', move.arr[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(u.k('ALT', move.vim[i]), function()
    u.move_groupaware(move.dir[i])
  end)
  hl.bind(u.k('ALT', move.arr[i]), function()
    u.move_groupaware(move.dir[i])
  end)
  hl.bind(u.k('CTRL', 'ALT', move.vim[i]), hl.dsp.window.move { direction = move.dir[i] })
  hl.bind(u.k('CTRL', 'ALT', move.arr[i]), hl.dsp.window.move { direction = move.dir[i] })
  hl.bind(u.k('SHIFT', move.vim[i]), function()
    u.translate(i)
  end, { repeating = true })
  hl.bind(u.k('SHIFT', move.arr[i]), function()
    u.translate(i)
  end, { repeating = true })
end

for i = 0, 9 do
  local ws = tostring(i)
  local name = ws
  if i < 1 then
    name = 'name:' .. name
  end
  hl.bind(u.k(ws), hl.dsp.focus { workspace = name, on_current_monitor = true })
  hl.bind(u.k('ALT', ws), hl.dsp.window.move { workspace = name, follow = false })
end
hl.bind(u.k 'Space', hl.dsp.workspace.toggle_special 's')
hl.bind(u.k('ALT', 'Space'), hl.dsp.window.move { workspace = 'special:s' })

-- Mouse Controls
hl.bind(u.k 'mouse_down', hl.dsp.focus { workspace = 'e+1' })
hl.bind(u.k 'mouse_up', hl.dsp.focus { workspace = 'e-1' })
hl.bind(u.k 'mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(u.k 'mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Multimedia & Brightness Keys
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+', { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', { locked = true, repeating = true })
hl.bind('XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { locked = true, repeating = true })
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd 'brightnessctl -e4 -n2 set 5%+', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd 'brightnessctl -e4 -n2 set 5%-', { locked = true, repeating = true })

hl.bind('XF86AudioNext', hl.dsp.exec_cmd 'playerctl next', { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd 'playerctl play-pause', { locked = true })
hl.bind('XF86AudioPlay', hl.dsp.exec_cmd 'playerctl play-pause', { locked = true })
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd 'playerctl previous', { locked = true })

-- Screenshot & Colorpicking
hl.bind('Print', hl.dsp.exec_cmd(u.screenshot 'snippet'))
hl.bind(u.k 'Print', hl.dsp.exec_cmd(u.screenshot 'select'))
hl.bind('ALT + Print', hl.dsp.exec_cmd 'hyprpicker -rau 64 -s 4')

-- [[ WINDOWS ]]
hl.window_rule {
  name = 'no-maximize',
  suppress_event = 'maximize',
  match = { class = '.*' },
}
hl.window_rule {
  name = 'persistent-size',
  persistent_size = true,
  match = { class = '.*' },
}
hl.window_rule {
  name = 'fix-xwayland-drags',
  no_focus = true,
  match = {
    class = '^$',
    title = '^$',
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
}
hl.window_rule {
  name = 'dim-solo-borders',
  border_color = colors.border .. alphas.mid,
  match = { workspace = 'w[t1]w[f0]', group = false },
}
hl.window_rule {
  name = 'inhibit-idle',
  idle_inhibit = 'fullscreen',
  match = { focus = true },
}

-- Floating Windows
u.buildrules('float', floats)
hl.window_rule {
  name = 'tag-floats',
  match = { float = true, fullscreen = false },
  tag = '+float',
}
hl.window_rule {
  name = 'float-tagged',
  float = true,
  match = { tag = 'float' },
}

-- Fullscreen Windows
u.buildrules('fullscreen', fullscreens)
hl.window_rule {
  name = 'tag-fullscreens',
  match = { fullscreen = true },
  tag = '+fullscreen',
}
hl.window_rule {
  name = 'fullscreen-tagged',
  fullscreen_state = '2 2',
  match = { tag = 'fullscreen' },
}

-- Block private windows from screen recorders
u.buildrules('private', privates)
hl.window_rule {
  name = 'block-tagged',
  no_screen_share = true,
  match = { tag = 'private' },
}

-- [[ WORKSPACES ]]
for i = 0, 9 do
  hl.workspace_rule {
    workspace = tostring(i > 1 and i or 'name:0'),
    persistent = true,
  }
end
if monitors then
  hl.workspace_rule {
    workspace = 'name:0',
    monitor = monitors[2].name,
    default = true,
    persistent = true,
  }
  hl.workspace_rule {
    workspace = '1',
    monitor = monitors[1].name,
    default = true,
    persistent = true,
  }
end

hl.workspace_rule {
  workspace = 'special:s',
  layout = 'scrolling',
}
hl.workspace_rule {
  workspace = 'f[0]f[1]f[2]',
  decorate = false,
}

-- [[ LAYERS ]]
hl.layer_rule {
  name = 'blur-backgrounds',
  blur = true,
  ignore_alpha = 0,
  match = {
    namespace = u.rc {
      'rofi',
      'waybar',
      'swaync-control-center',
      'swaync-notification-window',
    },
  },
}
hl.layer_rule {
  name = 'overlay-no-anim',
  no_anim = true,
  match = { namespace = u.rc { 'hyprpicker', 'selection', string.match(startup.background, '[^ ]+') } },
}
-- hl.layer_rule {
--   dim_around = false,
--   match = { namespace = 'waybar' },
-- }

-- [[ EVENTS ]]
-- Resizing
u.buildresizes(resizes)

hl.on('window.close', function(win)
  if win.group and win.group.size <= 2 then
    hl.dispatch(hl.dsp.group.toggle(win))
  end
end)

-- Track most recent workspace
hl.on('monitor.focused', function(mon)
  u.wstrack(mon.active_workspace)
end)
-- Track most recent window
hl.on('window.active', function(win, code)
  if not win.floating and not win.fullscreen and code ~= 16 then
    u.wintrack(win)
  end
end)
-- Switch wallpapers on workspace switch
hl.on('workspace.active', function(ws)
  local old = u.wstrack(ws)
  if old then
    for _, win in ipairs(ws.get_windows(old)) do
      if not win.floating then
        u.runawwwstatic(ws)
        return
      end
    end
  end
  local step = u.secs2step(transstep, ws.monitor.refresh_rate)
  local angle = old and math.abs(old.id) > math.abs(ws.id) and 175 or 5
  u.runawwwanim(ws, step, angle)
end)
hl.on('workspace.move_to_monitor', function(ws, mon)
  local old = u.montrack(ws)
  if old then
    for _, win in ipairs(ws.get_windows(old.active_workspace)) do
      if not win.floating then
        u.runawwwstatic(ws)
        return
      end
    end
  end
  local step = u.secs2step(transstep, mon.refresh_rate)
  local angle = old and old.position.x > mon.position.x and 175 or 5
  u.runawwwanim(ws, step, angle)
end)
