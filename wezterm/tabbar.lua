local wezterm = require("wezterm")
local act = wezterm.action
local M = {}
wezterm.on("update-right-status", function(window, pane)
	local leader_text = ""
	if window:leader_is_active() then
		leader_text = "  L "
	end

	local elements = {}
	local workspace_name = window:active_workspace() or "default"
	table.insert(elements, { Background = { Color = "#3B4252" } }) -- Nord1 背景
	table.insert(elements, { Foreground = { Color = "#88C0D0" } }) -- Nord8 高亮
	table.insert(elements, { Text = "   " .. workspace_name .. " " })
	if leader_text ~= "" then
		-- 左侧分隔符，用于产生一个弧形效果
		table.insert(elements, { Background = { Color = "#BF616A" } }) -- Nord11
		table.insert(elements, { Foreground = { Color = "#ECEFF4" } }) -- Nord6
		-- leader 提示文本
		table.insert(elements, { Text = leader_text })
		-- 右侧分隔符
		table.insert(elements, { Foreground = { Color = "#3B4252" } })
		-- 恢复背景色
		table.insert(elements, { Background = { Color = "#2E3440" } }) -- Nord0
	end

	window:set_right_status(wezterm.format(elements))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#2E3440" -- Nord0，分隔符颜色
	local background, foreground

	if tab.is_active then
		background = "#81A1C1" -- Nord9，活跃标签背景
		foreground = "#2E3440" -- Nord0，活跃标签文字
	else
		background = "#3B4252" -- Nord1，非活跃标签背景
		foreground = "#D8DEE9" -- Nord4，非活跃标签文字
	end

	-- 获取当前标签的标题，并限制长度
	local title = " " .. tab.active_pane.title .. " "
	if #title > max_width then
		title = title:sub(1, max_width - 1) .. "…"
	end

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = edge_background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = background } },
		{ Foreground = { Color = edge_background } },
	}
end)

function M.apply_to_config(config)
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = false
	config.show_new_tab_button_in_tab_bar = true
	config.tab_bar_at_bottom = true
end
return M
