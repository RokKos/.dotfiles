-- TODO(Rok Kos):lsp
-- harpoon
-- persitance

-- Make sure to snetup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- VIM OPTIONS
-- Disable mouse
vim.opt.mouse = ""
vim.o.clipboard = "unnamedplus"

vim.o.sidescrolloff = 8 -- Columns of context
vim.o.scrolloff = 999

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 10

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.inccommand = "split" -- preview incremental substitute

-- VIM KEYBINDINGS
local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc })
end
local vmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("v", "<Leader>" .. suffix, rhs, { desc = desc })
end

local nxomap_leader = function(suffix, rhs, desc)
	vim.keymap.set({ "n", "x", "o" }, "<Leader>" .. suffix, rhs, { desc = desc })
end

-- require("config.lazy")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true },
})

nmap_leader("cc", "<cmd>source %<CR>", "CONFIG/Reload Whole File")
nmap_leader("cl", ":.lua<CR>", "CONFIG/Reload Line")
vmap_leader("cl", ":lua<CR>", "CONFIG/Reload Line")

--vim.keymap.set("n", "<M-j>", "<CMD>cnext<CR>", { desc = "Next Quickfix Item" })
--vim.keymap.set("n", "<M-k>", "<CMD>cprev<CR>", { desc = "Prev Quickfix Item" })

-- AUTO RELOAD FILE
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = auto_reload_group,
	pattern = "*",
	command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
})

-- RESIZE
nmap_leader("h", "<CMD>vertical resize -5 <CR>", "Decrease window width")

nmap_leader("l", "<CMD>vertical resize +5 <CR>", "Decrease window width")
