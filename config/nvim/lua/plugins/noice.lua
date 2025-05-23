return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		presets = {
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim_lua
			lsp_doc_border = false, -- add a border to hover docs and signature help
			command_palette = true, -- position the cmdline and popupmenu together
		},
	},
}
