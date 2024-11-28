-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
-- For example, changing the color scheme:
config.color_scheme = "nord"
config.enable_tab_bar = false
config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}
config.font_size = 14
local mux = wezterm.mux

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

-- config.native_macos_fullscreen_mode = true
-- and finally, return the configuration to wezterm
return config
