-- Key bindings and their associated event handlers.

local wezterm = require("wezterm")

local M = {}

local FONT_SIZE_STEP = 0.5
local MIN_FONT_SIZE = 1

wezterm.on("increase-font-size-fine", function(window, _pane)
	local overrides = window:get_config_overrides() or {}
	local current_size = overrides.font_size or window:effective_config().font_size
	overrides.font_size = current_size + FONT_SIZE_STEP
	window:set_config_overrides(overrides)
end)

wezterm.on("decrease-font-size-fine", function(window, _pane)
	local overrides = window:get_config_overrides() or {}
	local current_size = overrides.font_size or window:effective_config().font_size
	if current_size > MIN_FONT_SIZE then
		overrides.font_size = current_size - FONT_SIZE_STEP
		window:set_config_overrides(overrides)
	end
end)

function M.apply(config)
	config.send_composed_key_when_left_alt_is_pressed = true
	config.send_composed_key_when_right_alt_is_pressed = true

	config.keys = {
		-- Shift+Enter binding for Claude Code
		{
			key = "Enter",
			mods = "SHIFT",
			action = wezterm.action({ SendString = "\x1b\r" }),
		},
		-- macOS bindings (Cmd key) with finer increments
		{
			key = "=",
			mods = "CMD",
			action = wezterm.action.EmitEvent("increase-font-size-fine"),
		},
		{
			key = "-",
			mods = "CMD",
			action = wezterm.action.EmitEvent("decrease-font-size-fine"),
		},
		-- Linux bindings (Ctrl key) with finer increments
		{
			key = "=",
			mods = "CTRL",
			action = wezterm.action.EmitEvent("increase-font-size-fine"),
		},
		{
			key = "-",
			mods = "CTRL",
			action = wezterm.action.EmitEvent("decrease-font-size-fine"),
		},
		-- Reset font size to default
		{
			key = "0",
			mods = "CMD",
			action = wezterm.action.ResetFontSize,
		},
		{
			key = "0",
			mods = "CTRL",
			action = wezterm.action.ResetFontSize,
		},
	}
end

return M
