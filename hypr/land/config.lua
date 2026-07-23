local v = require 'land.vars'
local gradient = require('land.utils.aesthetics').gradient

-- [[ AESTHETICS ]]
hl.config {
  group = {
    col = {
      border_active = gradient(v.colors.yellow, v.colors.orange),
      border_inactive = v.colors.yellow_bg .. v.alphas.mid,
      border_locked_active = gradient(v.colors.orange, v.colors.red),
      border_locked_inactive = v.colors.orange_bg .. v.alphas.mid,
    },

    groupbar = {
      text_color = v.colors.fg,
      text_color_inactive = v.colors.comment,
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
        active = v.colors.bg,
        inactive = v.colors.bg .. v.alphas.low,
        locked_active = v.colors.bg,
        locked_inactive = v.colors.bg .. v.alphas.low,
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
      color = v.colors.shadow .. v.alphas.low,
      color_inactive = v.colors.shadow .. v.alphas.high,
    },

    glow = {
      range = 2,
      render_power = 1,
      color = v.colors.blue,
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
      active_border = gradient(v.colors.blue, v.colors.cyan),
      inactive_border = v.colors.border .. v.alphas.mid,
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

hl.gesture {
  fingers = 3,
  direction = 'horizontal',
  action = 'workspace',
}
