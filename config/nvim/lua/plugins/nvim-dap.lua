return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
			},
			"leoluz/nvim-dap-go",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup({
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.5,
							},
							{
								id = "breakpoints",
								size = 0.5,
							},
						},
						position = "bottom",
						size = 20,
					},
				},
			})

			require("dap-go").setup()
			require("nvim-dap-virtual-text").setup()

			dap.adapters.lldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}

			local sep = package.config:sub(1, 1)
			local function read_target()
				local cwd = string.format("%s%s", vim.fn.getcwd(), sep)
				return vim.fn.input("Path to executable: ", cwd, "file")
			end
			local cfg = {
				name = "Debug",
				type = "lldb",
				request = "launch",
				cwd = "${workspaceFolder}",
				program = read_target,
				stopOnEntry = false,
			}

			dap.configurations.c = {
				cfg,
				vim.tbl_extend("force", cfg, { name = "Attach debugger", request = "attach" }),
			}
			dap.configurations.cpp = vim.tbl_extend("keep", {}, dap.configurations.c)

			local nmap_leader = function(suffix, rhs, desc)
				vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
			end
			nmap_leader("db", dap.toggle_breakpoint, "[D]ebug set [B]reakpoint")
			nmap_leader("dr", dap.run_to_cursor, "[D]ebug [R]un to cursor")

			nmap_leader("dc", dap.continue, "[D]ebug [C]ontinue")
			nmap_leader("dsi", dap.step_into, "[D]ebug [S]tep [I]nto")
			nmap_leader("dso", dap.step_over, "[D]ebug [S]tep [O]over")
			nmap_leader("dse", dap.step_out, "[D]ebug [S]tep out([E]xit)")
			nmap_leader("dsb", dap.step_back, "[D]ebug [S]tep [B]ack")
			nmap_leader("dd", dap.restart, "[D]ebug restart ([D], as to just repeat))")

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
