local wezterm = require("wezterm")

local config = wezterm.config_builder()

local keybindings = require("keybindings")
local workspace = require("workspace")

keybindings.apply_to_config(config)
workspace.apply_to_config(config)

wezterm.on("update-right-status", function(window, pane)
	local leader = ""
	if window:leader_is_active() then
		leader = "LEADER"
	end
	window:set_right_status(leader)
end)

config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = true
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
-- For example, changing the color scheme:
config.color_scheme = "nord"
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
-- wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
-- config.native_macos_fllscreen_mode = true
-- and finally, return the configuration to wezterm
return config
-- The line beneath this is called `modeline`. See `:help modeline`
