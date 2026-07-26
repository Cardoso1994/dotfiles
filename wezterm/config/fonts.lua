-- Font, glyph, and tab-bar appearance settings.

local wezterm = require("wezterm")

local M = {}

function M.apply(config)
	config.font_size = 13.8
	config.warn_about_missing_glyphs = true
	config.freetype_load_target = "HorizontalLcd"
	config.use_fancy_tab_bar = true

	config.font = wezterm.font({
		family = "Monaspace Krypton NF",
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

	config.window_frame = {
		font = wezterm.font({
			family = "Monaspace Krypton NF",
			weight = 700,
		}),
		font_size = 14,
	}

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
				weight = 700,
			}),
		},
		{ -- Bold Italic (Krypton for docstrings)
			intensity = "Bold",
			italic = true,
			font = wezterm.font({
				family = "Monaspace Krypton NF",
				weight = 500, -- Medium weight
			}),
		},
	}
end

return M
