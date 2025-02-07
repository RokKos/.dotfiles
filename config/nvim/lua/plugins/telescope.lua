return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "debugloop/telescope-undo.nvim" },
		},
		config = function()
			local previewers = require("telescope.previewers")
			local previewers_utils = require("telescope.previewers.utils")

			-- for large files that freeze editor
			local max_size = 500000
			local truncate_large_files = function(filepath, bufnr, opts)
				opts = opts or {}

				filepath = vim.fn.expand(filepath)
				vim.loop.fs_stat(filepath, function(_, stat)
					if not stat then
						return
					end
					if stat.size > max_size then
						local cmd = { "head", "-c", max_size, filepath }
						previewers_utils.job_maker(cmd, bufnr, opts)
					else
						previewers.buffer_previewer_maker(filepath, bufnr, opts)
					end
				end)
			end

			local actions = require("telescope.actions")
			-- Replacing default open Quickfix view with Trouble
			actions.open_qflist:replace(function()
				vim.cmd("Trouble qflist toggle focus=true")
			end)

			require("telescope").setup({
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					fzf = {},

					undo = {
						side_by_side = true,
						layout_strategy = "vertical",
						layout_config = {
							preview_height = 0.8,
						},
						mappings = {
							i = {
								["<cr>"] = require("telescope-undo.actions").yank_additions,
								["<C-y>"] = require("telescope-undo.actions").yank_deletions,
								["<C-r>"] = require("telescope-undo.actions").restore,
							},
							n = {
								["y"] = require("telescope-undo.actions").yank_additions,
								["Y"] = require("telescope-undo.actions").yank_deletions,
								["u"] = require("telescope-undo.actions").restore,
							},
						},
					},
				},
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					--path_display = { "smart" },
					buffer_previewer_maker = truncate_large_files,
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.45,
						},
						width = 0.95,
						height = 0.95,
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
							-- <C-w> -> Deletes whole word
						},
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension("undo"))

			local nmap_leader = function(suffix, rhs, desc)
				vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
			end
			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			nmap_leader("sh", builtin.help_tags, "[S]earch [H]elp")
			nmap_leader("sk", builtin.keymaps, "[S]earch [K]eymaps")
			nmap_leader("sf", builtin.find_files, "[S]earch [F]iles")
			nmap_leader("ss", builtin.builtin, "[S]earch [S]elect Telescope")
			nmap_leader("sw", builtin.grep_string, "[S]earch current [W]ord")
			nmap_leader("sg", builtin.live_grep, "[S]earch by [G]rep")
			nmap_leader("sd", builtin.diagnostics, "[S]earch [D]iagnostics")
			nmap_leader("sr", builtin.resume, "[S]earch [R]esume")
			nmap_leader("s.", builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
			nmap_leader("sb", builtin.buffers, "[ ] Find existing buffers")
			nmap_leader("su", require("telescope").extensions.undo.undo, "[S]earch [U]ndo History")

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "live grep in open files",
				})
			end, { desc = "[s]earch [/] in open files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })

			vim.keymap.set("n", "<leader>sp", function()
				builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
			end, { desc = "[S]earch neovim [P]ackages" })

			local conf = require("telescope.config").values
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local pickers = require("telescope.pickers")

			local flatten = vim.tbl_flatten

			-- i would like to be able to do telescope
			-- and have telescope do some filtering on files and some grepping

			local multi_live_grep = function(opts)
				opts = opts or {}
				opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
				opts.shortcuts = opts.shortcuts
					or {
						["l"] = "*.lua",
						["c"] = "*.c",
						["g"] = "*.go",
						["j"] = "*.{js,jsx,ts,tsx}",
						["z"] = "*.zig",
						["n"] = "*.json",
					}
				opts.pattern = opts.pattern or "%s"

				local custom_grep = finders.new_async_job({
					command_generator = function(prompt)
						if not prompt or prompt == "" then
							return nil
						end

						local prompt_split = vim.split(prompt, "  ")

						local args = { "rg" }
						if prompt_split[1] then
							table.insert(args, "-e")
							table.insert(args, prompt_split[1])
						end

						if prompt_split[2] then
							table.insert(args, "-g")

							local pattern
							if opts.shortcuts[prompt_split[2]] then
								pattern = opts.shortcuts[prompt_split[2]]
							else
								pattern = prompt_split[2]
							end

							table.insert(args, string.format(opts.pattern, pattern))
						end

						return flatten({
							args,
							{
								"--color=never",
								"--no-heading",
								"--with-filename",
								"--line-number",
								"--column",
								"--smart-case",
							},
						})
					end,
					entry_maker = make_entry.gen_from_vimgrep(opts),
					cwd = opts.cwd,
				})

				pickers
					.new(opts, {
						debounce = 100,
						prompt_title = "Live Grep (with shortcuts)",
						finder = custom_grep,
						previewer = conf.grep_previewer(opts),
						sorter = require("telescope.sorters").empty(),
					})
					:find()
			end

			nmap_leader("sl", multi_live_grep, "Multi [L]ive Grep")
		end,
	},
}
