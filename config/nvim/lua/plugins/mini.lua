return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		-- mini.nvim setup
		require("mini.ai").setup()
		require("mini.surround").setup()
		require("mini.operators").setup()

		local my_active_content = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 999 })
			local git = MiniStatusline.section_git({ trunc_width = 40 })
			local diff = MiniStatusline.section_diff({ trunc_width = 75 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 999 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })
			local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
				"%<", -- Mark general truncate point
				--{ hl = 'MiniStatuslineFilename', strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end

		require("mini.statusline").setup({ content = { active = my_active_content } })
		require("mini.tabline").setup()
		require("mini.icons").setup()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.pairs").setup()
		require("mini.comment").setup()
		require("mini.cursorword").setup()
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				fixme = { pattern = "%f[%w]()IMPORTANT()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()STUDY()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Registers
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},

			clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
		})

		require("mini.basics").setup({
			options = {
				-- Basic options ('number', 'ignorecase', and many more)
				basic = true,
				-- Extra UI features ('winblend', 'cmdheight=0', ...)
				extra_ui = true,
				-- Presets for window borders ('single', 'double', ...)
				win_borders = "default",
			},

			-- Mappings. Set to `false` to disable
			mappings = {
				-- Basic mappings (better 'jk', save with Ctrl+S, ...)
				basic = true,
				-- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
				-- Supply empty string to not create these mappings.
				option_toggle_prefix = [[\]],

				-- Window navigation with <C-hjkl>, resize with <C-arrow>
				windows = true,
				-- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
				move_with_alt = false,
			},
			autocommands = {
				-- Basic autocommands (highlight on yank, start Insert in terminal, ...)
				basic = true,
				-- Set 'relativenumber' only in linewise and blockwise Visual mode
				relnum_in_visual_mode = true,
			},

			-- Whether to disable showing non-error feedback
			silent = false,
		})
	end,
}
