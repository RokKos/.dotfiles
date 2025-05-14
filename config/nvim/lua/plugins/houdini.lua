return {
	{
		"TheBlob42/houdini.nvim",
		enabled = false,
		config = function()
			require("houdini").setup()
		end,
	},
}
