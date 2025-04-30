-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

config.color_scheme = 'tokyonight'
config.font_size = 13.0

config.window_frame = {
	font_size = 13.0,
	active_titlebar_bg = '#24283b',
	inactive_titlebar_bg = '#24283b',
}

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = '#1a1b26',
			fg_color = '#c0caf5',
		},
		inactive_tab = {
			bg_color = '#24283b',
			fg_color = '#a9b1d6',
		},
		inactive_tab_hover = {
			bg_color = '#414868',
			fg_color = '#c0caf5',
		},
		new_tab = {
			bg_color = '#24283b',
			fg_color = '#c0caf5',
		},
		new_tab_hover = {
			bg_color = '#414868',
			fg_color = '#c0caf5',
		},
	},
}

config.initial_rows = 32
config.initial_cols = 104

config.default_prog = { '/usr/bin/fish', '-i' }

-- and finally, return the configuration to wezterm
return config
