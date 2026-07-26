-- Color scheme definitions and theme-family registry.
--
-- Each scheme below is a plain WezTerm color_scheme table. `families` groups
-- a light/dark pair under a short name so `wezterm.lua` can switch the whole
-- terminal's palette by flipping one string (see `theme_family`).

local M = {}

-- Gruvbox default light/dark (hand-picked, not derived from a specific plugin)
local default_light = {
	background = "#fbf1c7",
	foreground = "#3c3836",
	cursor_bg = "#af3a03",
	cursor_fg = "#fbf1c7",
	selection_bg = "#d5c4a1",
	selection_fg = "#3c3836",
	ansi = {
		"#fbf1c7", -- black (light background)
		"#cc241d", -- red
		"#98971a", -- green
		"#d79921", -- yellow
		"#458588", -- blue
		"#b16286", -- magenta
		"#689d6a", -- cyan
		"#7c6f64", -- white (light gray)
	},
	brights = {
		"#928374", -- bright black (gray)
		"#9d0006", -- bright red
		"#79740e", -- bright green
		"#b57614", -- bright yellow
		"#076678", -- bright blue
		"#8f3f71", -- bright magenta
		"#427b58", -- bright cyan
		"#3c3836", -- bright white (foreground)
	},
}

local default_dark = {
	background = "#282828",
	foreground = "#ebdbb2",
	cursor_bg = "#fe8019",
	cursor_fg = "#282828",
	selection_bg = "#504945",
	selection_fg = "#ebdbb2",
	ansi = {
		"#282828", -- black (dark background)
		"#cc241d", -- red
		"#98971a", -- green
		"#d79921", -- yellow
		"#458588", -- blue
		"#b16286", -- magenta
		"#689d6a", -- cyan
		"#a89984", -- white (light gray)
	},
	brights = {
		"#928374", -- bright black (gray)
		"#fb4934", -- bright red
		"#b8bb26", -- bright green
		"#fabd2f", -- bright yellow
		"#83a598", -- bright blue
		"#d3869b", -- bright magenta
		"#8ec07c", -- bright cyan
		"#ebdbb2", -- bright white (foreground)
	},
}

-- Gruvbox Material, matching lua/custom/plugins/gruvbox-material.lua in the
-- nvim config: background = "medium", foreground palette = "material"
-- (sainnhe/gruvbox-material defaults). Values pulled directly from the
-- plugin's get_palette() so both editors render identically. The plugin
-- reuses the same 8 hues for normal and bright slots, so brights mirror ansi
-- here on purpose.
local gruvbox_material_dark = {
	background = "#282828", -- bg0 (medium, dark)
	foreground = "#d4be98", -- fg0 (material, dark)
	cursor_bg = "#e78a4e", -- orange (material, dark)
	cursor_fg = "#282828",
	selection_bg = "#45403d", -- bg3 (medium, dark)
	selection_fg = "#d4be98",
	ansi = {
		"#5a524c", -- black   -> bg5
		"#ea6962", -- red
		"#a9b665", -- green
		"#d8a657", -- yellow
		"#7daea3", -- blue
		"#d3869b", -- purple/magenta
		"#89b482", -- aqua/cyan
		"#d4be98", -- white   -> fg0
	},
	brights = {
		"#5a524c",
		"#ea6962",
		"#a9b665",
		"#d8a657",
		"#7daea3",
		"#d3869b",
		"#89b482",
		"#d4be98",
	},
}

local gruvbox_material_light = {
	background = "#fbf1c7", -- bg0 (medium, light)
	foreground = "#654735", -- fg0 (material, light)
	cursor_bg = "#c35e0a", -- orange (material, light)
	cursor_fg = "#fbf1c7",
	selection_bg = "#eee0b7", -- bg3 (medium, light)
	selection_fg = "#654735",
	ansi = {
		"#654735", -- black   -> fg0
		"#c14a4a", -- red
		"#6c782e", -- green
		"#b47109", -- yellow
		"#45707a", -- blue
		"#945e80", -- purple/magenta
		"#4c7a5d", -- aqua/cyan
		"#ddccab", -- white   -> bg5
	},
	brights = {
		"#654735",
		"#c14a4a",
		"#6c782e",
		"#b47109",
		"#45707a",
		"#945e80",
		"#4c7a5d",
		"#ddccab",
	},
}

-- Kanagawa Lotus (Light)
local kanagawa_light = {
	background = "#e7dba0", -- lotusWhite4
	foreground = "#545464", -- lotusInk1
	cursor_bg = "#cc6d00", -- lotusOrange
	cursor_fg = "#e7dba0", -- lotusWhite4
	selection_bg = "#c9cbd1", -- lotusViolet3
	selection_fg = "#545464", -- lotusInk1
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
		"#c84053", -- lotusRed (red)
		"#6e915f", -- lotusGreen2 (bright green)
		"#de9800", -- lotusYellow3 (bright yellow)
		"#4d699b", -- lotusBlue4 (blue)
		"#766b90", -- lotusViolet2 (bright magenta)
		"#5e857a", -- lotusAqua2 (bright cyan)
		"#43436c", -- lotusInk2 (bright white)
	},
}

-- Kanagawa Dragon (Dark)
local kanagawa_dark = {
	background = "#181616", -- dragonBlack3
	foreground = "#c5c9c5", -- dragonWhite
	cursor_bg = "#b6927b", -- dragonOrange
	cursor_fg = "#181616", -- dragonBlack3
	selection_bg = "#393836", -- dragonBlack5
	selection_fg = "#c5c9c5", -- dragonWhite
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

-- Solawarm Dark: Kanagawa Dragon bg + Solarized CIELAB structure + Dragon-inspired accents
local solawarm_dark = {
	background = "#181616", -- base03 (Dragon bg)
	foreground = "#808580", -- base0  (body text)
	cursor_bg = "#8c6f5d", -- orange
	cursor_fg = "#181616",
	selection_bg = "#26231f", -- base02
	selection_fg = "#968d81", -- base1  (emphasized)
	-- Solarized canonical 16-color mapping (same slot convention as NeoSolarized)
	ansi = {
		"#26231f", -- 0  black   base02  (selection bg)
		"#a7625d", -- 1  red
		"#859577", -- 2  green
		"#9d8e6e", -- 3  yellow
		"#698a99", -- 4  blue
		"#7f7280", -- 5  magenta
		"#819593", -- 6  cyan
		"#eae3c2", -- 7  white   base2   (light bg_hl — Solarized convention)
	},
	brights = {
		"#181616", -- 8  brblack base03  (darkest bg)
		"#8c6f5d", -- 9  brred   orange
		"#5c5f5c", -- 10 brgreen base01  (comments/deemph)
		"#726a62", -- 11 bryellow base00 (secondary fg)
		"#808580", -- 12 brblue  base0   (primary fg)
		"#71798a", -- 13 brmag   violet
		"#968d81", -- 14 brcyan  base1   (emphasized)
		"#f9f1d0", -- 15 brwhite base3   (light bg)
	},
}

-- Solawarm Light: Solarized/Lotus midpoint bg + same Dragon hues, CIELAB-inverted for cream
local solawarm_light = {
	background = "#f9f1d0", -- base3  (warm cream bg)
	foreground = "#717571", -- base00 (body text)
	cursor_bg = "#9e6d4d", -- orange (visible on light bg)
	cursor_fg = "#f9f1d0",
	selection_bg = "#eae3c2", -- base2  (bg_hl)
	selection_fg = "#716556", -- base01 (emphasized)
	ansi = {
		"#eae3c2", -- 0  black   base2   (bg_hl — Solarized light convention)
		"#a96661", -- 1  red     C*=30
		"#4c6738", -- 2  green   C*=30
		"#6f5d2d", -- 3  yellow  C*=30
		"#0c728f", -- 4  blue    C*=28 (gamut cap)
		"#916996", -- 5  magenta C*=30
		"#026a65", -- 6  cyan    C*=27 (gamut cap)
		"#717571", -- 7  white   base00  (body text)
	},
	brights = {
		"#f9f1d0", -- 8  brblack base3   (bg itself)
		"#9e6d4d", -- 9  brred   orange  C*=30
		"#979b97", -- 10 brgreen base1   (comments/deemph)
		"#716556", -- 11 bryellow base01 (emphasized)
		"#717571", -- 12 brblue  base00  (primary fg)
		"#5575a7", -- 13 brmag   violet  C*=30
		"#a59888", -- 14 brcyan  base1   (emphasized)
		"#181616", -- 15 brwhite base03  (Dragon dark bg — darkest anchor)
	},
}

-- NeoSolarized Dark
local neosolarized_dark = {
	background = "#002b36",
	foreground = "#839496",
	cursor_bg = "#cb4b16",
	cursor_fg = "#002b36",
	selection_bg = "#073642",
	selection_fg = "#93a1a1",
	ansi = {
		"#073642", -- black   (bg1)
		"#dc322f", -- red
		"#859900", -- green
		"#b58900", -- yellow
		"#268bd2", -- blue
		"#d33682", -- magenta (purple)
		"#2aa198", -- cyan    (aqua)
		"#657b83", -- white   (fg1)
	},
	brights = {
		"#586e75", -- bright black  (fg2)
		"#dc322f", -- bright red
		"#859900", -- bright green
		"#b58900", -- bright yellow
		"#268bd2", -- bright blue
		"#6c71c4", -- bright magenta (violet)
		"#2aa198", -- bright cyan
		"#839496", -- bright white   (fg0)
	},
}

-- NeoSolarized Light
local neosolarized_light = {
	background = "#fdf6e3",
	foreground = "#002b36",
	cursor_bg = "#cb4b16",
	cursor_fg = "#fdf6e3",
	selection_bg = "#eee8d5",
	selection_fg = "#002b36",
	ansi = {
		"#eee8d5", -- black   (bg1)
		"#dc322f", -- red
		"#859900", -- green
		"#b58900", -- yellow
		"#268bd2", -- blue
		"#d33682", -- magenta (purple)
		"#2aa198", -- cyan    (aqua)
		"#839496", -- white   (fg0)
	},
	brights = {
		"#93a1a1", -- bright black  (base1)
		"#dc322f", -- bright red
		"#859900", -- bright green
		"#b58900", -- bright yellow
		"#268bd2", -- bright blue
		"#6c71c4", -- bright magenta (violet)
		"#2aa198", -- bright cyan
		"#657b83", -- bright white   (fg1)
	},
}

-- All named schemes, registered on `config.color_schemes`.
M.schemes = {
	["defaultLight"] = default_light,
	["defaultDark"] = default_dark,
	["GruvboxMaterialLight"] = gruvbox_material_light,
	["GruvboxMaterialDark"] = gruvbox_material_dark,
	["KanagawaLight"] = kanagawa_light,
	["KanagawaDark"] = kanagawa_dark,
	["SolawarmLight"] = solawarm_light,
	["SolawarmDark"] = solawarm_dark,
	["SolarizedLight"] = neosolarized_light,
	["SolarizedDark"] = neosolarized_dark,
}

-- Light/dark scheme name pairs, keyed by the `theme_family` setting in
-- wezterm.lua. Add a new family here after adding its schemes above.
M.families = {
	default = { light = "defaultLight", dark = "defaultDark" },
	gruvboxMaterial = { light = "GruvboxMaterialLight", dark = "GruvboxMaterialDark" },
	kanagawa = { light = "KanagawaLight", dark = "KanagawaDark" },
	solawarm = { light = "SolawarmLight", dark = "SolawarmDark" },
	solarized = { light = "SolarizedLight", dark = "SolarizedDark" },
}

return M
