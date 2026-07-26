-- Time-of-day light/dark switching.
--
-- WezTerm does not poll the clock on its own, so an `update-right-status`
-- handler re-checks the hour on every status-bar refresh and nudges the user
-- to reload when the theme should flip (config reload actually swaps it).

local wezterm = require("wezterm")

local M = {}

local LIGHT_START_HOUR = 7
local LIGHT_END_HOUR = 18

function M.current_period()
	local hour = os.date("*t").hour
	if hour >= LIGHT_START_HOUR and hour < LIGHT_END_HOUR then
		return "light"
	end
	return "dark"
end

-- Applies the given family's light/dark scheme (from colors.families) to
-- `config` based on the current time, and wires up the reload reminder.
function M.apply(config, family)
	config.color_scheme = M.current_period() == "light" and family.light or family.dark

	wezterm.on("update-right-status", function(window, _pane)
		local effective_scheme = window:effective_config().color_scheme
		local expected_scheme = M.current_period() == "light" and family.light or family.dark

		if effective_scheme ~= expected_scheme then
			window:set_right_status("Theme change needed - please reload configuration")
		else
			window:set_right_status("")
		end
	end)
end

return M
