return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<CMD>Neotree toggle reveal<CR>", desc = "Explorer (tree)" },
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = "open_default",
      follow_current_file = { enabled = true },
      filtered_items = { visible = true },
    },
  },
}
