local wezterm = require("wezterm")
local config = {}

-- Check if we have the newer config builder API
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Function to determine theme based on time of day
local function get_theme_based_on_time()
	local now = os.date("*t")
	local hour = now.hour

	-- Light theme from 7am to 6pm (7-18), dark theme otherwise
	if hour >= 7 and hour < 18 then
		return "Light"
	else
		return "Dark"
	end
end

-- Define light and dark Gruvbox color schemes
local light_scheme = {
	-- Base colors
	background = "#fbf1c7", -- Gruvbox light background
	foreground = "#3c3836", -- Gruvbox light foreground
	cursor_bg = "#af3a03", -- Gruvbox light orange
	cursor_fg = "#fbf1c7", -- Same as background for contrast
	selection_bg = "#d5c4a1", -- Gruvbox light selection
	selection_fg = "#3c3836", -- Same as foreground for readability

	-- ANSI colors (0-15)
	ansi = {
		"#fbf1c7", -- black (technically it's the light background)
		"#cc241d", -- red
		"#98971a", -- green
		"#d79921", -- yellow
		"#458588", -- blue
		"#b16286", -- magenta
		"#689d6a", -- cyan
		"#7c6f64", -- white (technically it's light gray)
	},
	brights = {
		"#928374", -- bright black (gray)
		"#9d0006", -- bright red
		"#79740e", -- bright green
		"#b57614", -- bright yellow
		"#076678", -- bright blue
		"#8f3f71", -- bright magenta
		"#427b58", -- bright cyan
		"#3c3836", -- bright white (technically it's the foreground)
	},
}

local dark_scheme = {
	-- Base colors
	background = "#282828", -- Gruvbox dark background
	foreground = "#ebdbb2", -- Gruvbox dark foreground
	cursor_bg = "#fe8019", -- Gruvbox dark orange
	cursor_fg = "#282828", -- Same as background for contrast
	selection_bg = "#504945", -- Gruvbox dark selection
	selection_fg = "#ebdbb2", -- Same as foreground for readability

	-- ANSI colors (0-15)
	ansi = {
		"#282828", -- black (technically it's the dark background)
		"#cc241d", -- red
		"#98971a", -- green
		"#d79921", -- yellow
		"#458588", -- blue
		"#b16286", -- magenta
		"#689d6a", -- cyan
		"#a89984", -- white (technically it's light gray)
	},
	brights = {
		"#928374", -- bright black (gray)
		"#fb4934", -- bright red
		"#b8bb26", -- bright green
		"#fabd2f", -- bright yellow
		"#83a598", -- bright blue
		"#d3869b", -- bright magenta
		"#8ec07c", -- bright cyan
		"#ebdbb2", -- bright white (technically it's the foreground)
	},
}
-- Define light and dark color schemes
-- local light_scheme = {
-- 	background = "#f0f0f0",
-- 	foreground = "#2c2c2c",
-- 	cursor_bg = "#52ad70",
-- 	cursor_fg = "#f0f0f0",
-- 	selection_bg = "#d0d0d0",
-- 	selection_fg = "#2c2c2c",
-- }
--
-- local dark_scheme = {
-- 	background = "#1a1a1a",
-- 	foreground = "#f0f0f0",
-- 	cursor_bg = "#52ad70",
-- 	cursor_fg = "#1a1a1a",
-- 	selection_bg = "#505050",
-- 	selection_fg = "#f0f0f0",
-- }

-- Register the color schemes
wezterm.add_to_config_reload_watch_list(wezterm.home_dir .. "/.wezterm.lua")

-- Apply theme based on time
local theme_type = get_theme_based_on_time()

-- Enable Option key to work as Alt/Meta for composing accented characters
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Set up color scheme
config.color_schemes = {
	["MyLightTheme"] = light_scheme,
	["MyDarkTheme"] = dark_scheme,
}

if theme_type == "Light" then
	config.color_scheme = "MyLightTheme"
else
	config.color_scheme = "MyDarkTheme"
end

-- Setup status bar to notify when theme should change
wezterm.on("update-right-status", function(window, pane)
	local theme_type = get_theme_based_on_time()
	local current_theme = window:effective_config().color_scheme

	if
		(theme_type == "Light" and current_theme ~= "MyLightTheme")
		or (theme_type == "Dark" and current_theme ~= "MyDarkTheme")
	then
		window:set_right_status("Theme change needed - please reload configuration")
	else
		window:set_right_status("")
	end
end)

return config
