local neogit = require("neogit")
neogit.setup()

vim.keymap.set("n", "<leader>gs", neogit.open)
vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>")
vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>")
vim.keymap.set("n", "<leader>gP", ":Neogit push<CR>")
