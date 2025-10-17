-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  "windwp/nvim-autopairs",
  version = "*",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({})
  end,
}
