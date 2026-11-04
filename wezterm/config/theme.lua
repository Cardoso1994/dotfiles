-- Appearance-based light/dark switching.
--
-- The light or dark half of the chosen family follows the OS appearance.
-- WezTerm detects appearance changes and reloads the configuration itself
-- (https://wezterm.org/config/lua/wezterm.gui/get_appearance.html), so no
-- manual reload is needed.

local wezterm = require("wezterm")

local M = {}

-- `wezterm.gui` is not available to the mux server, so fall back to "Dark"
-- when this config is evaluated there.
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

-- "light" or "dark". Matches "Dark" and "DarkHighContrast" alike.
function M.current_period()
	if get_appearance():find("Dark") then
		return "dark"
	end
	return "light"
end

-- Applies the given family's light/dark scheme (from colors.families) to
-- `config` based on the OS appearance.
function M.apply(config, family)
	config.color_scheme = M.current_period() == "light" and family.light or family.dark
end

return M
