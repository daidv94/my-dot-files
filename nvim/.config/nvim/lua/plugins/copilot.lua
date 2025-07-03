return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            suggestion = {
              enabled = true,
              auto_trigger = false,
              hide_during_completion = true,
              debounce = 75,
              trigger_on_accept = true,
              keymap = {
                accept = "<Tab>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
              },
            },
            filetypes = {
              yaml = true,
              markdown = true,
              help = false,
              gitcommit = false,
              gitrebase = false,
              hgcommit = false,
              svn = false,
              cvs = false,
              ["."] = false,
            },
          })
        end,
      },                                              -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      prompts = {
        Rename = {
          prompt = 'Please rename the variable correctly in given selection based on context',
          selection = function(source)
            local select = require('CopilotChat.select')
            return select.visual(source)
          end,
        },
      },
    },
    keys = {
      { "<leader>zc", ":CopilotChat<CR>",                                     mode = "n", desc = "Chat with Copilot" },
      { "<leader>ze", ":CopilotChatExplain<CR>",                              mode = "v", desc = "Explain Code" },
      { "<leader>zr", ":CopilotChatReview<CR>",                               mode = "v", desc = "Review Code" },
      { "<leader>zf", ":CopilotChatFix<CR>",                                  mode = "v", desc = "Fix Code Issues" },
      { "<leader>zo", ":CopilotChatOptimize<CR>",                             mode = "v", desc = "Optimize Code" },
      { "<leader>zd", ":CopilotChatDocs<CR>",                                 mode = "v", desc = "Generate Docs" },
      { "<leader>zt", ":CopilotChatTests<CR>",                                mode = "v", desc = "Generate Tests" },
      { "<leader>zm", ":CopilotChatCommit<CR>",                               mode = "n", desc = "Generate Commit Message" },
      { "<leader>zs", ":CopilotChatCommit<CR>",                               mode = "v", desc = "Generate Commit for Selection" },

      -- Mapping to ensure Copilot suggestions work in insert mode
      { "<M-]>",      function() require("copilot.suggestion").next() end,    mode = "i", desc = "Copilot Next Suggestion" },
      { "<M-[>",      function() require("copilot.suggestion").prev() end,    mode = "i", desc = "Copilot Previous Suggestion" },
      { "<C-]>",      function() require("copilot.suggestion").dismiss() end, mode = "i", desc = "Copilot Dismiss Suggestion" },
    },
  },
}
