return {
	"josephburgess/nvumi",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		virtual_text = "inline", -- or "newline"
		prefix = "= ", -- prefix shown before the virtual text output
		keys = {
			run = "<CR>", -- run/refresh calculations
			reset = "R", -- reset buffer
			yank = "<leader>y", -- yank last output
		},
	},
}
