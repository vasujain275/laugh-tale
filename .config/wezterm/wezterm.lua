-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Rosé Pine (base16)"
-- config.color_scheme = 'Rosé Pine (Gogh)'
config.term = "xterm-256color"

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16

config.enable_tab_bar = false

-- config.window_decorations = "NONE"
-- config.window_background_opacity = 0.75
config.macos_window_background_blur = 8

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Always maximized (windowed fullscreen with titlebar)
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Background with wallpaper + black overlay
config.background = {
	-- Wallpaper layer
	{
		source = {
			File = "/home/vasu/Pictures/wallpapers/wall-51.jpg",
		},
		hsb = {
			brightness = 0.1,
			hue = 1.0,
			saturation = 1.0,
		},
	},
}

-- and finally, return the configuration to wezterm
return config
