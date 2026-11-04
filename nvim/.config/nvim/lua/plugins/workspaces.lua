return {
  {
    "natecraddock/sessions.nvim",
    opts = {
      events = { "VimLeavePre" },
      session_filepath = vim.fn.stdpath("data") .. "/sessions",
      absolute = true,
    },
    config = function(_, opts)
      vim.fn.mkdir(opts.session_filepath, "p")
      vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "folds" }
      local sessions = require("sessions")
      sessions.setup(opts)

      -- Auto-load session for the current working directory on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("AutoLoadSession", { clear = true }),
        nested = true,
        callback = function()
          -- Only auto-load if Neovim was launched without file arguments
          if vim.fn.argc() == 0 then
            sessions.load(nil, { silent = true })
          end
        end,
      })
    end,
  },
  {
    "natecraddock/workspaces.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "natecraddock/sessions.nvim",
    },
    opts = {
      cd_type = "global",
      hooks = {
        open_pre = {
          "silent! wall",
          function()
            require("sessions").save(nil, { silent = true })
          end,
          "silent! Neotree close",
          "silent %bdelete!",
        },
        open = {
          function()
            pcall(function()
              require("sessions").load(nil, { silent = true })
            end)

            -- If no files were restored from a saved session, prompt with find_files
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname == "" then
              vim.schedule(function()
                vim.cmd("Telescope find_files")
              end)
            end
          end,
        },
      },
    },
    config = function(_, opts)
      require("workspaces").setup(opts)
      require("telescope").load_extension("workspaces")
      vim.keymap.set("n", "<leader>e", "<CMD>Telescope workspaces<CR>", { desc = "Search projects/workspaces" })
    end,
  },
}
