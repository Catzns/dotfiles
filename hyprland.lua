-- Refer to the wiki for more information.
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
---@param top string
---@param bottom string
---@return { colors: string[], angle: integer }
local function border(top, bottom)
  return {
    colors = { top .. alphas.high, bottom .. alphas.high },
    angle = 80,
  }
end

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
hl.curve('wi', { type = 'spring', mass = 1, stiffness = 66, dampening = 14.33 })
hl.curve('wo', { type = 'spring', mass = 1, stiffness = 66, dampening = 14.66 })

hl.animation { leaf = 'global', enabled = false }
hl.animation { leaf = 'windows', enabled = true, speed = 1, spring = 'wi', style = 'gnomed' }
hl.animation { leaf = 'fade', enabled = true, speed = 1, bezier = 'b' }
hl.animation { leaf = 'fadeSwitch', enabled = true, speed = 5, bezier = 'b' }
hl.animation { leaf = 'fadeLayers', enabled = true, speed = 1.5, bezier = 'b' }
hl.animation { leaf = 'fadeDpms', enabled = false }
hl.animation { leaf = 'border', enabled = true, speed = 0.66, bezier = 'b' }
hl.animation { leaf = 'layers', enabled = true, speed = 1, bezier = 'f', style = 'fade' }
hl.animation { leaf = 'workspaces', enabled = true, speed = 1, spring = 'wo', style = 'slide' }
hl.animation { leaf = 'specialWorkspace', enabled = true, speed = 1.5, bezier = 'b', style = 'fade' }

hl.gesture {
  fingers = 3,
  direction = 'horizontal',
  action = 'workspace',
}

-- [[ KEYBINDS ]]
---@param mod string
---@param ... string
---@return string
local function k(mod, ...)
  local keys = { ... }
  local combo = mod
  for _, key in ipairs(keys) do
    combo = combo .. ' + ' .. key
  end
  return combo
end

---@alias gate boolean[]
---@return gate
local function gate()
  return { true }
end

---@param callback function
---@param gated gate
---@param timeout integer
local function doubletap(callback, gated, timeout)
  if gated[1] then
    gated[1] = false
    hl.timer(function()
      gated[1] = true
    end, { timeout = timeout, type = 'oneshot' })
  else
    callback()
  end
end

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

local function translate(i)
  local dist = hl.get_active_monitor().width / 20
  local axes = {
    { dist, 0 },
    { -dist, 0 },
    { 0, dist },
    { 0, -dist },
  }
  hl.dispatch(hl.dsp.window.resize { x = axes[i][1], y = axes[i][2], relative = true })
end

for i = 1, 4 do
  hl.bind(k('SUPER', move.vim[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(k('SUPER', move.arr[i]), hl.dsp.focus { direction = move.dir[i] }, { repeating = true })
  hl.bind(k('SUPER', 'ALT', move.vim[i]), hl.dsp.window.move { direction = move.dir[i] })
  hl.bind(k('SUPER', 'ALT', move.arr[i]), hl.dsp.window.move { direction = move.dir[i] })
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
---@param func 'select' | 'snippet'
---@return string
local function screenshot(func)
  local script = [=[
func="%s"
cmd_screen="grim"
cmd_select="slurp"
cmd_freeze="hyprpicker -rz"
cmd_edit="swappy -f -"
cmd_copy="wl-copy"
cmd_end="pkill ${cmd_freeze/%% *}"

deps=("$cmd_screen" "$cmd_select")
optdeps=("$cmd_edit" "$cmd_copy")
if [[ "$func" == "snippet" ]]; then
  optdeps+=("$cmd_freeze")
fi

track=0
for dep in "${deps[@]}"; do
  dep="${dep/%% *}"
  if ! command -v "$dep"&>/dev/null; then 
    hyprctl notify 3 5000 0 "Utility '$dep' is not installed."
    track+=1
  fi
done
if [[ $track -ne 0 ]]; then
  exit 1
fi

for dep in "${optdeps[@]}"; do
  dep="${dep/%% *}"
  if ! command -v "$dep"&>/dev/null; then 
    hyprctl notify 0 5000 0 "Utility '$dep' is not installed."
  fi
done

if [[ "$func" == "snippet" ]]; then
  cmd_select="slurp -F 'JetBrains Mono' -b a9b1d633 -c c0caf5 -w 1 -d"
else
  cmd_select="slurp -F 'JetBrainsMono' -B a9b1d633 -c c0caf5 -w 9 -o -r"
fi
cmd_screen="grim -g \"\$($cmd_select)\" -"

cmd="$cmd_screen"
if command -v "${cmd_edit/%% *}"&>/dev/null; then
  cmd="$cmd | ($cmd_edit &)"
elif command -v "${cmd_copy/%% *}"&>/dev/null; then
  cmd="$cmd | $cmd_copy"
else
  cmd="$cmd&>/dev/null"
fi

if command -v "${cmd_freeze/%% *}"&>/dev/null; then
  cmd="$cmd_freeze & sleep 0.05; $cmd; $cmd_end"
fi

eval "$cmd"
]=]
  return string.format(script, func)
end

hl.bind('Print', hl.dsp.exec_cmd(screenshot 'snippet'))
hl.bind(k('SHIFT', 'Print'), hl.dsp.exec_cmd(screenshot 'select'))
hl.bind(k('CTRL', 'Print'), hl.dsp.exec_cmd 'hyprpicker -rau 64 -s 4')

-- [[ WINDOW RULES ]]
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

-- Floating Windows
---@alias selections { c: string?, t: string?}[]
---@param regexes string[]
---@return string
local function rc(regexes)
  if #regexes < 1 then
    return ''
  end
  local r = string.format('(%s)', regexes[1])
  for i = 2, #regexes do
    r = string.format('%s|(%s)', r, regexes[i])
  end
  return r
end

---@param s string
---@return string
local function n(s)
  return 'negative:' .. s
end

---@type selections
local floats = {
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

local floatclasses = {}
local floattitles = {}
for _, float in ipairs(floats) do
  if float.c and float.t then
    hl.window_rule {
      float = true,
      match = {
        class = float.c,
        title = float.t,
      },
      tag = '+float',
    }
  else
    if float.c then
      table.insert(floatclasses, float.c)
    end
    if float.t then
      table.insert(floattitles, float.t)
    end
  end
end

hl.window_rule {
  name = 'float-class',
  float = true,
  match = { class = rc(floatclasses) },
  tag = '+float',
}
hl.window_rule {
  name = 'float-title',
  float = true,
  match = { title = rc(floattitles) },
  tag = '+float',
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

-- Fullscreen Windows
---@type selections
local fullscreens = {
  { c = 'hl2_linux,' },
  { c = 'cs2' },
  { c = 'tf_linux64' },
  { t = 'Marble Blast Ultra!.*' },
  { t = 'UltraRebirth.*' },
  { c = 'steam_app_\\d+', t = '.+' },
}
local fullscreenclasses = {}
local fullscreentitles = {}
for _, selection in ipairs(fullscreens) do
  if selection.c and selection.t then
    hl.window_rule {
      fullscreen_state = '2 2',
      match = {
        class = selection.c,
        title = selection.t,
      },
    }
  else
    if selection.c then
      table.insert(fullscreenclasses, selection.c)
    end
    if selection.t then
      table.insert(fullscreentitles, selection.t)
    end
  end
end
hl.window_rule {
  name = 'fullscreen-class',
  fullscreen_state = '2 2',
  match = {
    title = rc(fullscreenclasses),
  },
}
hl.window_rule {
  name = 'fullscreen-title',
  fullscreen_state = '2 2',
  match = {
    title = rc(fullscreentitles),
  },
}

-- [[ WORKSPACE RULES ]]
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

-- [[ LAYER RULES ]]
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
