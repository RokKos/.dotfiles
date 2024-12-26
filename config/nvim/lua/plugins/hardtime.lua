return {
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
			disabled_keys = {
				["<Up>"] = { "n" },
				["<Down>"] = { "n" },
				["<Left>"] = { "n" },
				["<Right>"] = { "n" },
			},
		},
	},
}
