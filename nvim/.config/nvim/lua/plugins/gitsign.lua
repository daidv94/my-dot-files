return {
  "lewis6991/gitsigns.nvim",
  version = "*",
  lazy = false,
  -- adf
  dependencies = { "sindrets/diffview.nvim" },
  config = function()
    require("gitsigns").setup()
    local gitsigns = require("gitsigns")

    -- Navigation
    vim.keymap.set("n", "<leader>[", function()
      if vim.wo.diff then
        vim.cmd.normal({ "<leader>[", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)

    vim.keymap.set("n", "<leader>]", function()
      if vim.wo.diff then
        vim.cmd.normal({ "<leader>]", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)
    -- Actions
    vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk)
    vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk)
    vim.keymap.set("v", "<leader>gs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    vim.keymap.set("v", "<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer)
    vim.keymap.set("n", "<leader>gb", function()
      gitsigns.blame_line({ full = true })
    end)
    vim.keymap.set("n", "<leader>gd", gitsigns.diffthis)
    vim.keymap.set("n", "<leader>gD", function()
      gitsigns.diffthis("~")
    end)
    -- Diffview
    vim.keymap.set("n", "<leader>gv", function()
      if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
      else
        vim.cmd("DiffviewClose")
      end
    end, { desc = "Toggle Diffview" })
  end,
}
