return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin-mocha")

      -- transparent background
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "none" })
    end,
  },
}
