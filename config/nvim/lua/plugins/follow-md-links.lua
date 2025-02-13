return {
	"jghauser/follow-md-links.nvim",
	config = function()
		vim.keymap.set("n", "<bs>", ":edit #<cr>", { silent = true })
	end,
}
