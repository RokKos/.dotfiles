return {
	"robitx/gp.nvim",
	config = function()
		local conf = {
			-- For customization, refer to Install > Configuration in the Documentation/Readme
			providers = {
				ollama = {
					endpoint = "http://localhost:11434/v1/chat/completions",
				},
			},
			agents = {
				{
					provider = "ollama",
					name = "deep seek r1:32b",
					chat = true,
					command = true,
					-- string with model name or table with model name and parameters
					model = {
						model = "deepseek-r1:32b",
						-- temperature = 0.4,
						-- top_p = 1,
						-- min_p = 0.05,
					},
					-- system prompt (use this to specify the persona/role of the AI)
					system_prompt = require("gp.defaults").code_system_prompt,
				},
			},
		}
		require("gp").setup(conf)

		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
	end,
}
