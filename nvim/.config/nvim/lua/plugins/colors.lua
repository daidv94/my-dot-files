return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
      })
      vim.cmd.colorscheme("rose-pine")

      -- transparent background
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      --
      -- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "none" })
    end,
  },
}
