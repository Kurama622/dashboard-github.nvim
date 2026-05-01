local g = vim.api.nvim_create_augroup("dashboard-github", { clear = true })
local function set_base_hl()
	local api = vim.api
	local lighten = require("dashboard-github.color").change_hex_lightness
	local bg = vim.o.bg

	local highlights = {}

	local hexadecimal_to_hex = function(hex)
		return "#" .. ("%06x"):format((hex == nil and 0 or hex))
	end

	if vim.g.base46_cache then
		local colors = dofile(vim.g.base46_cache .. "colors")

		highlights = {
			ExDarkBg = { bg = colors.darker_black, default = true },
			ExDarkBorder = { bg = colors.darker_black, fg = colors.darker_black, default = true },

			ExBlack2Bg = { bg = colors.black2, default = true },
			ExBlack2border = { bg = colors.black2, fg = colors.black2, default = true },

			ExRed = { fg = colors.red, default = true },
			ExYellow = { fg = colors.yellow, default = true },
			ExBlue = { fg = colors.blue, default = true },
			ExGreen = { fg = colors.green, default = true },

			ExBlack3Bg = { bg = colors.one_bg2, default = true },
			ExBlack3Border = { bg = colors.one_bg2, fg = colors.one_bg2, default = true },
			ExLightGrey = { fg = lighten(colors.grey, bg == "dark" and 35 or -35), default = true },
			CommentFg = { fg = colors.light_grey, default = true },
		}
	else
		local normal_bg = api.nvim_get_hl(0, { name = "Normal" }).bg
		local comment_fg = api.nvim_get_hl(0, { name = "comment" }).fg

		normal_bg = hexadecimal_to_hex(normal_bg)
		comment_fg = hexadecimal_to_hex(comment_fg)

		local darker_bg = lighten(normal_bg, -3)
		local lighter_bg = lighten(normal_bg, 5)
		local black3_bg = lighten(normal_bg, 10)

		local get_hl = function(name)
			local data = api.nvim_get_hl(0, { name = name })
			return hexadecimal_to_hex(data.fg)
		end

		highlights = {
			ExDarkBg = { bg = darker_bg, default = true },
			ExDarkBorder = { bg = darker_bg, fg = darker_bg, default = true },

			ExBlack2Bg = { bg = lighter_bg, default = true },
			ExBlack2Border = { bg = lighter_bg, fg = lighter_bg, default = true },

			ExRed = { fg = get_hl("Removed"), default = true },
			ExYellow = { fg = get_hl("Type"), default = true },
			ExBlue = { fg = get_hl("Changed"), default = true },
			ExGreen = { fg = get_hl("Added"), default = true },
			ExBlack3Bg = { bg = black3_bg, default = true },
			CommentFg = { fg = comment_fg, default = true },
			ExBlack3Border = { bg = black3_bg, fg = black3_bg, default = true },
			ExLightGrey = { fg = lighten(comment_fg, bg == "dark" and 20 or -20), default = true },
		}
	end

	for name, val in pairs(highlights) do
		vim.api.nvim_set_hl(0, name, val)
	end
end

vim.api.nvim_create_autocmd("UIEnter", {
	group = g,
	callback = function()
		if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
			set_base_hl()
			require("dashboard-github.hl")(0)
			require("dashboard-github").show()
		end
	end,
})
