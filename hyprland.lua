local utils = require 'hyprland-utils'
local k, n, rc, border, buildresizes, buildrules, doubletap, gate, move_groupaware, screenshot, translate =
  utils.k,
  utils.n,
  utils.rc,
  utils.border,
  utils.buildresizes,
  utils.buildrules,
  utils.doubletap,
  utils.gate,
  utils.move_groupaware,
  utils.screenshot,
  utils.translate
table.extend = utils.extend

-- Refer to the wiki for details.
-- https://wiki.hypr.land/Configuring/

-- [[ VARIABLES ]]
local monitors = {
  desk_primary = 'desc: BNQ BenQ EX2510 L4M01372019',
  desk_secondary = 'desc: BNQ BenQ GW2470 J6G06725SL0',
}

local cmds = {
  init = 'systemctl --user start ',
  opener = 'uwsm-app -- ',
  refresh = 'pkill -SIGUSR2 waybar',
  logout = 'loginctl terminate-user ""',
}

local apps = {
  power = 'rofi -show power -theme power -mode power',
  terminal = 'footclient.desktop',
  menu = 'rofi -show drun -theme desktop -run-command "uwsm-app -- {cmd}"',
  emoji = 'rofimoji --selector-args "-theme emoji"',
  files = 'thunar.desktop',
  notes = 'obsidian.desktop',
}

local startup = {
  'wlsunset -T 5800 -t 3400 -S 7:00 -s 18:00 -d 3600',
  'hyprlock' .. '; ' .. cmds.refresh,
}

local services = {
  'wayland-wm-app-daemon',
  'hyprpolkitagent',
  'hyprpaper',
  'hypridle',
  'swaync',
  'thunar',
  'syncthing',
  'waybar',
}

---@type selections
local floats = {
  -- c: Class names, t: Title names
  { c = 'xdg-desktop-portal-gtk' },
  { c = 'org.pulseaudio.pavucontrol' },
  { c = 'org.gnome.FileRoller' },
  { c = 'file-png' },

  { c = 'firefox', t = 'Library' },
  { c = 'Thunar', t = rc { 'Rename.*', 'File Operation Progress.*' } },

  { c = 'gimp', t = n(rc { '.*- GIMP', 'GNU Image Manipulation Program' }) },
  { c = 'org.inkscape.Inkscape', t = n '.*Inkscape$' },
  { c = rc { 'obs', 'com.obsproject.Studio' }, t = n 'OBS .*' },
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

local colors = {
  bg = '#414868',
  bg_dark = '#16161e',
  fg = '#c0caf5',
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

-- [[ MONITORS ]]
hl.monitor {
  output = monitors.desk_primary,
  mode = 'highres',
  position = '0x0',
  scale = '1',
}

hl.monitor {
  output = monitors.desk_secondary,
  mode = 'highres',
  position = 'auto-right',
  scale = '1',
}

hl.monitor {
  output = '',
  mode = 'highres',
  position = 'auto',
  scale = 'auto',
}

-- [[ INIT ]]
hl.on('hyprland.start', function()
  for _, service in ipairs(services) do
    hl.exec_cmd(cmds.init .. service)
  end
  for _, program in ipairs(startup) do
    hl.exec_cmd(cmds.opener .. program)
  end
end)

-- [[ AESTHETICS ]]
hl.config {
  general = {
    layout = 'dwindle',

    gaps_in = 1,
    gaps_out = 0,
    border_size = 2,

    col = {
      active_border = border(colors.blue, colors.cyan),
      inactive_border = colors.bg .. alphas.mid,
    },
  },

  group = {
    drag_into_group = 2,

    col = {
      border_active = border(colors.yellow, colors.orange),
      border_inactive = colors.yellow_bg .. alphas.mid,
      border_locked_active = border(colors.orange, colors.red),
      border_locked_inactive = colors.orange_bg .. alphas.mid,
    },

    groupbar = {
      text_color = colors.fg,
      font_family = 'JetBrainsMono NF ExtraBold, Sans',
      font_size = 15,

      round_only_edges = false,

      col = {
        active = colors.orange .. alphas.high,
        inactive = colors.yellow_bg .. alphas.mid,
        locked_active = colors.red .. alphas.high,
        locked_inactive = colors.orange_bg .. alphas.mid,
      },
    },
  },

  decoration = {
    rounding = 3,
    rounding_power = 3,

    active_opacity = 1.0,
    inactive_opacity = 0.98,

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
      color = colors.bg_dark .. alphas.low,
      color_inactive = colors.bg_dark .. alphas.high,
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
  dwindle = {
    preserve_split = true,
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
    default_monitor = monitors.desk_primary,
  },

  binds = {
    workspace_center_on = 1,
    workspace_back_and_forth = true,
    hide_special_on_workspace_change = true,
    movefocus_cycles_groupfirst = true,
  },

  render = {
    direct_scanout = 1,
  },

  misc = {
    vrr = 3,

    font_family = 'Inter, Sans',

    force_default_wallpaper = 3,
    disable_hyprland_logo = true,

    enable_swallow = true,
    swallow_regex = '^(footclient)|(Thunar)$',

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

hl.gesture {
  fingers = 3,
  direction = 'horizontal',
  action = 'workspace',
}

-- [[ KEYBINDS ]]
-- Applications & Functions
hl.bind(k('SUPER', 'Escape'), hl.dsp.exec_cmd(cmds.logout))
local super = gate()
hl.bind(k('SUPER', 'SUPER_L'), function()
  doubletap(function()
    hl.dispatch(hl.dsp.exec_cmd(apps.menu))
  end, super, 250)
end, { ignore_mods = true, desc = 'Launcher' })
hl.bind(k('SUPER', 'Q'), hl.dsp.exec_cmd(apps.power), { desc = 'Quit' })
hl.bind(k('SUPER', 'W'), hl.dsp.exec_cmd(cmds.opener .. apps.notes), { desc = 'Write' })
hl.bind(k('SUPER', 'E'), hl.dsp.exec_cmd(apps.emoji), { desc = 'Emoji' })
hl.bind(k('SUPER', 'R'), hl.dsp.exec_cmd(cmds.refresh), { desc = 'Refresh' })
-- hl.bind(k('SUPER', 'A'), hl.dsp.exec_cmd(apps.menu), { desc = 'Application' })
hl.bind(k('SUPER', 'S'), function()
  local special = hl.get_active_special_workspace()
  if special and special.tiled_layout == 'scrolling' then
    hl.dispatch(hl.dsp.layout 'fit all')
  else
    hl.dispatch(hl.dsp.layout 'togglesplit')
  end
end, { desc = 'Swap / Shrink' })
hl.bind(k('SUPER', 'D'), hl.dsp.exec_cmd(cmds.opener .. apps.files), { desc = 'Directory' })
hl.bind(k('SUPER', 'F'), hl.dsp.window.float(), { desc = 'Float' })
hl.bind(k('SUPER', 'Z'), hl.dsp.group.toggle(), { desc = 'Zip' })
hl.bind(k('SUPER', 'X'), hl.dsp.window.close(), { desc = 'eXit' })
hl.bind(k('SUPER', 'C'), function()
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
  hl.exec_cmd(cmds.opener .. apps.terminal)
end, { desc = 'Console' })
hl.bind(
  k('SUPER', 'V'),
  hl.dsp.workspace.swap_monitors {
    monitor1 = monitors.desk_primary,
    monitor2 = monitors.desk_secondary,
  },
  { desc = 'Swap Views' }
)

-- Movement & Resizing
local move = {
  dir = { 'r', 'l', 'd', 'u' },
  vim = { 'l', 'h', 'j', 'k' },
  arr = { 'right', 'left', 'down', 'up' },
}

for i = 1, 4 do
  hl.bind(k('SUPER', move.vim[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(k('SUPER', move.arr[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(k('SUPER', 'ALT', move.vim[i]), function()
    move_groupaware(move.dir[i])
  end)
  hl.bind(k('SUPER', 'ALT', move.arr[i]), function()
    move_groupaware(move.dir[i])
  end)
  hl.bind(k('SUPER', 'SHIFT', move.vim[i]), function()
    translate(i)
  end, { repeating = true })
  hl.bind(k('SUPER', 'SHIFT', move.arr[i]), function()
    translate(i)
  end, { repeating = true })
end

for i = 0, 9 do
  local ws = tostring(i)
  local name = ws
  if i < 1 then
    name = 'name:' .. name
  end
  hl.bind(k('SUPER', ws), hl.dsp.focus { workspace = name, on_current_monitor = true })
  hl.bind(k('SUPER', 'ALT', ws), hl.dsp.window.move { workspace = name, follow = false })
end
hl.bind(k('SUPER', 'Space'), hl.dsp.workspace.toggle_special 's')
hl.bind(k('SUPER', 'ALT', 'Space'), hl.dsp.window.move { workspace = 'special:s' })

-- Mouse Controls
hl.bind(k('SUPER', 'mouse_down'), hl.dsp.focus { workspace = 'e+1' })
hl.bind(k('SUPER', 'mouse_up'), hl.dsp.focus { workspace = 'e-1' })
hl.bind(k('SUPER', 'mouse:272'), hl.dsp.window.drag(), { mouse = true })
hl.bind(k('SUPER', 'mouse:273'), hl.dsp.window.resize(), { mouse = true })

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
hl.bind('Print', hl.dsp.exec_cmd(screenshot 'snippet'))
hl.bind(k('SHIFT', 'Print'), hl.dsp.exec_cmd(screenshot 'select'))
hl.bind(k('ALT', 'Print'), hl.dsp.exec_cmd 'hyprpicker -rau 64 -s 4')

-- [[ WINDOWS ]]
hl.window_rule {
  name = 'no-maximize',
  suppress_event = 'maximize',
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
  border_color = colors.bg .. alphas.mid,
  match = { workspace = 'w[t1]w[f0]' },
}
hl.window_rule {
  name = 'inhibit-idle',
  idle_inhibit = 'fullscreen',
  match = {
    focus = true,
  },
}
hl.window_rule {
  name = 'tag-floats',
  match = {
    float = true,
    fullscreen = false,
  },
  tag = '+float',
}
hl.window_rule {
  name = 'persistent-size',
  persistent_size = true,
  match = {
    tag = 'float',
  },
}

-- Floating & Fullscreen Windows
buildrules('float', floats, { float = true })
buildrules('fullscreen', fullscreens, { fullscreen_state = '2 2' })

-- [[ WORKSPACES ]]
hl.workspace_rule {
  workspace = 'name:0',
  monitor = monitors.desk_secondary,
  default = true,
}
hl.workspace_rule {
  workspace = '1',
  monitor = monitors.desk_primary,
  default = true,
}
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
    namespace = rc {
      'rofi',
      'waybar',
      'swaync-control-center',
      'swaync-notification-window',
    },
  },
}
hl.layer_rule {
  name = 'picker-no-anim',
  no_anim = true,
  match = { namespace = rc { 'hyprpicker', 'selection' } },
}

-- [[ EVENTS ]]
buildresizes(resizes)
