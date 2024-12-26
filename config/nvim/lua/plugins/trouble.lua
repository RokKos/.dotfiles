return {

	{
		"folke/trouble.nvim",
		opts = {
			-- defaults = {
			-- auto_close = true,   -- auto close when there are no items
			-- auto_open = true,    -- auto open when there are items
			-- auto_preview = true, -- automatically open preview when on an item
			-- auto_refresh = true, -- auto refresh when open
			-- auto_jump = false,   -- auto jump to the item when there's only one
			-- focus = true,        -- Focus the window when opened
			-- restore = true,      -- restores the last location in the list when opening
			-- follow = true,       -- Follow the current item
			-- }
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		config = function()
			nmap_leader("xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", "Diagnostics (Trouble)")
			nmap_leader(
				"xX",
				"<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
				"Buffer Diagnostics (Trouble)"
			)
			nmap_leader("cs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)")
			nmap_leader(
				"cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				"LSP Definitions / references / ... (Trouble)"
			)
			nmap_leader("xL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
			nmap_leader("xq", "<cmd>Trouble qflist toggle focus=true<cr>", "Quickfix List (Trouble)")
		end,
	},
}
