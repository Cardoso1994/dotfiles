local wezterm = require("wezterm")

-- Make `require("config.xxx")` resolve regardless of whether WezTerm loaded
-- this file via the ~/.config/wezterm symlink or the real dotfiles path.
package.path = wezterm.home_dir .. "/dotfiles/wezterm/?.lua;" .. package.path

local colors = require("config.colors")
local theme = require("config.theme")
local fonts = require("config.fonts")
local keys = require("config.keys")

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Reload whenever the real dotfiles source changes (watching the symlink
-- itself is not reliable across editors/tools).
wezterm.add_to_config_reload_watch_list(wezterm.home_dir .. "/dotfiles/wezterm/wezterm.lua")

-- ============================================================
-- Theme family: "default" | "gruvboxMaterial" | "kanagawa" | "solawarm" | "solarized"
-- ============================================================
local theme_family_name = "gruvboxMaterial"

config.color_schemes = colors.schemes
theme.apply(config, colors.families[theme_family_name])

fonts.apply(config)
keys.apply(config)

return config
