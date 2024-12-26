return {
	{
		"mbbill/undotree",
		config = function()
			local nmap_leader = function(suffix, rhs, desc)
				vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
			end

			nmap_leader("ut", vim.cmd.UndotreeToggle, "[U]ndo [T]ree Toggle")
		end,
	},
}
