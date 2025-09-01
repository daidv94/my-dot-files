return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      git = {
        ignore = false,
      },
      filters = {
        dotfiles = false,
      },
      view = {
        adaptive_size = true,
      },
      update_focused_file = {
        enable = true,
      },
    })
    -- rollback oil keymap before enabling this again
    vim.keymap.set("n", "<leader>te", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>tr", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
  end,
}
