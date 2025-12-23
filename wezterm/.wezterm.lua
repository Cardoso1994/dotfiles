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

-- Kanagawa Lotus (Light) color scheme
local lotus_scheme = {
	-- Base colors
	background = "#e7dba0", -- lotusWhite4
	foreground = "#545464", -- lotusInk1
	cursor_bg = "#cc6d00", -- lotusOrange
	cursor_fg = "#e7dba0", -- lotusWhite4
	selection_bg = "#c9cbd1", -- lotusViolet3
	selection_fg = "#545464", -- lotusInk1

	-- ANSI colors (0-15)
	ansi = {
		"#f2ecbc", -- lotusWhite3 (black)
		"#c84053", -- lotusRed (red)
		"#6f894e", -- lotusGreen (green)
		"#77713f", -- lotusYellow (yellow)
		"#4d699b", -- lotusBlue4 (blue)
		"#b35b79", -- lotusPink (magenta)
		"#597b75", -- lotusAqua (cyan)
		"#716e61", -- lotusGray2 (white)
	},
	brights = {
		"#8a8980", -- lotusGray3 (bright black)
		"#d7474b", -- lotusRed2 (bright red)
		"#6e915f", -- lotusGreen2 (bright green)
		"#de9800", -- lotusYellow3 (bright yellow)
		"#6693bf", -- lotusTeal2 (bright blue)
		"#766b90", -- lotusViolet2 (bright magenta)
		"#5e857a", -- lotusAqua2 (bright cyan)
		"#43436c", -- lotusInk2 (bright white)
	},
}

-- Kanagawa Dragon (Dark) color scheme
local dragon_scheme = {
	-- Base colors
	background = "#181616", -- dragonBlack3
	foreground = "#c5c9c5", -- dragonWhite
	cursor_bg = "#b6927b", -- dragonOrange
	cursor_fg = "#181616", -- dragonBlack3
	selection_bg = "#393836", -- dragonBlack5
	selection_fg = "#c5c9c5", -- dragonWhite

	-- ANSI colors (0-15)
	ansi = {
		"#0d0c0c", -- dragonBlack0 (black)
		"#c4746e", -- dragonRed (red)
		"#87a987", -- dragonGreen (green)
		"#c4b28a", -- dragonYellow (yellow)
		"#8ba4b0", -- dragonBlue2 (blue)
		"#a292a3", -- dragonPink (magenta)
		"#8ea4a2", -- dragonAqua (cyan)
		"#a6a69c", -- dragonGray (white)
	},
	brights = {
		"#625e5a", -- dragonBlack6 (bright black)
		"#c4746e", -- dragonRed (bright red)
		"#8a9a7b", -- dragonGreen2 (bright green)
		"#c4b28a", -- dragonYellow (bright yellow)
		"#949fb5", -- dragonTeal (bright blue)
		"#8992a7", -- dragonViolet (bright magenta)
		"#737c73", -- dragonAsh (bright cyan)
		"#c5c9c5", -- dragonWhite (bright white)
	},
}

-- Register the color schemes
wezterm.add_to_config_reload_watch_list(wezterm.home_dir .. "/.wezterm.lua")

-- Apply theme based on time
local theme_type = get_theme_based_on_time()

-- Enable Option key to work as Alt/Meta for composing accented characters
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Set up color scheme
config.color_schemes = {
	["MyLightTheme"] = lotus_scheme,
	["MyDarkTheme"] = dragon_scheme,
}

if theme_type == "Light" then
	config.color_scheme = "MyLightTheme"
else
	config.color_scheme = "MyDarkTheme"
end

-- Font settings
config.font_size = 13.8
config.warn_about_missing_glyphs = true
config.freetype_load_target = "HorizontalLcd"

config.font = wezterm.font({
	family = "Monaspace Neon NF",
	harfbuzz_features = {
		"calt",
		"liga",
		"dlig",
		"ss01",
		"ss02",
		"ss03",
		"ss04",
		"ss05",
		"ss06",
		"ss07",
		"ss08",
	},
})

config.font_rules = {
	{ -- Italic
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Radon NF",
			style = "Italic",
		}),
	},

	{ -- Bold
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			family = "Monaspace Krypton NF",
			weight = "Bold",
		}),
	},

	{ -- Bold Italic
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Radon NF",
			style = "Italic",
			weight = "Bold",
		}),
	},
}

-- Custom key bindings for finer font size control (both macOS and Linux)
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

-- Event handlers for fine font size control
wezterm.on("increase-font-size-fine", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current_size = overrides.font_size or 12 -- Default to 12 if not set
	overrides.font_size = current_size + 0.5 -- Increase by 0.5pt
	window:set_config_overrides(overrides)
end)

wezterm.on("decrease-font-size-fine", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current_size = overrides.font_size or 12 -- Default to 12 if not set
	if current_size > 1 then -- Prevent going too small
		overrides.font_size = current_size - 0.5 -- Decrease by 0.5pt
		window:set_config_overrides(overrides)
	end
end)
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
