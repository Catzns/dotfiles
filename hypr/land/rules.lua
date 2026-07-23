local v = require 'land.vars'
local r = require 'land.utils.regex'
local R = require 'land.utils.rules'
local m = require 'land.monitors'

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
  border_color = v.colors.border .. v.alphas.mid,
  match = { workspace = 'w[t1]w[f0]', group = false },
}
hl.window_rule {
  name = 'inhibit-idle',
  idle_inhibit = 'fullscreen',
  match = { focus = true },
}

-- Floating Windows
R.buildrules('float', v.floats)
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
R.buildrules('fullscreen', v.fullscreens)
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
R.buildrules('private', v.privates)
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

-- Set first listed monitor to workspace 1, last listed monitor to workspace 0,
-- and assign all others from there in descending order
hl.workspace_rule {
  workspace = '1',
  monitor = m[1].output,
  default = true,
  persistent = true,
}
hl.workspace_rule {
  workspace = 'name:0',
  monitor = m[#m].output,
  default = true,
  persistent = true,
}
local j = 9
for i = #m - 1, 2, -1 do
  hl.workspace_rule {
    workspace = tostring(j),
    monitor = m[i].output,
    default = true,
    persistent = true,
  }
  j = j - 1
end

hl.workspace_rule {
  workspace = 'special:s',
  layout = 'scrolling',
}
-- Do not decorate fullscreened workspaces
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
    namespace = r.c {
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
  match = { namespace = r.c { 'hyprpicker', 'selection', string.match(v.startup.background, '[^ ]+') } },
}
