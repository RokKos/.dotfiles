local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")


local previewers = require('telescope.previewers')
local previewers_utils = require('telescope.previewers.utils')

-- for large files that freeze editor
local max_size = 500000
local truncate_large_files = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > max_size then
      local cmd = { "head", "-c", max_size, filepath }
      previewers_utils.job_maker(cmd, bufnr, opts)
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require("telescope").setup({
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
    buffer_previewer_maker = truncate_large_files,
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },

  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    },
    file_browser = {
      --  theme = "ivy",
      hijack_netrw = true,
    }
  }

})

pcall(require("telescope").load_extension, "fzf")
require("telescope").load_extension("ui-select")

require("telescope").load_extension("file_browser")
vim.g.loaded_netrwPlugin = 0


local builtin = require("telescope.builtin")

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

function project_files()
  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    builtin.git_files({
      recurse_submodules = true,
    })
  else
    builtin.find_files()
  end
end

vim.keymap.set("n", "<leader><leader>", project_files)
vim.keymap.set("n", "<leader>sf", builtin.find_files)
vim.keymap.set("n", "<leader>sg", function()
  builtin.live_grep({ recurse_submodules = true })
end)
vim.keymap.set("n", "<leader>sv", function()
  builtin.grep_string({ recurse_submodules = true })
end)
vim.keymap.set("n", "<leader>sb", builtin.buffers)
vim.keymap.set("n", "<leader>sr", builtin.resume)
vim.keymap.set("n", "<leader>sh", builtin.help_tags)
