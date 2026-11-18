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

-- The sway theme script links this file to the active themes/*.conf. It is
-- more reliable than the portal signal, which a long-lived GUI process can
-- miss (it then keeps handing the stale scheme to new windows).
local state_link = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state"))
	.. "/sway/theme.conf"

-- Returns "light", "dark" or nil when the link is missing.
local function state_period()
	local p = io.popen("readlink " .. state_link .. " 2>/dev/null")
	if not p then
		return nil
	end
	local out = p:read("*a") or ""
	p:close()
	if out:find("dark") then
		return "dark"
	elseif out:find("light") then
		return "light"
	end
	return nil
end

-- "light" or "dark". Matches "Dark" and "DarkHighContrast" alike.
function M.current_period()
	local from_state = state_period()
	if from_state then
		return from_state
	end
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
