return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		labels = "fjdksla;ghrueiwoqpvncmx,z.",
		search = {
			mode = "",
		},
		jump = {
			autojump = true,
		},
		label = {
			rainbow = {
				enabled = true,
			},
		},
		continue = false,
	},

	enabled = true,
	config = function()
		local nxomap_leader = function(suffix, rhs, desc)
			vim.keymap.set({ "n", "x", "o" }, "<Leader>" .. suffix, rhs, { desc = desc })
		end

		local flash = require("flash")
		nxomap_leader("<Leader>", function()
			flash.jump()
		end, "FLASH/Jump")
		nxomap_leader("ft", function()
			flash.treesitter()
		end, "[F]LASH [T]reesitter select around")
		nxomap_leader("fs", function()
			flash.treesitter_search()
		end, "[F]lash Treesitter [S]earch and Select")
	end,
}
