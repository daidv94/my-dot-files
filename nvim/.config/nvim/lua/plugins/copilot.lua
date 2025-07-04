return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            panel = {
              enabled = false
            },
            suggestion = {
              enabled = false,
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
      { "<leader>cc", ":CopilotChat<CR>",         mode = "n", desc = "Chat with Copilot" },
      { "<leader>ce", ":CopilotChatExplain<CR>",  mode = "v", desc = "Explain Code" },
      { "<leader>cr", ":CopilotChatReview<CR>",   mode = "v", desc = "Review Code" },
      { "<leader>cf", ":CopilotChatFix<CR>",      mode = "v", desc = "Fix Code Issues" },
      { "<leader>co", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
      { "<leader>cd", ":CopilotChatDocs<CR>",     mode = "v", desc = "Generate Docs" },
      { "<leader>ct", ":CopilotChatTests<CR>",    mode = "v", desc = "Generate Tests" },
      { "<leader>cm", ":CopilotChatCommit<CR>",   mode = "n", desc = "Generate Commit Message" },
      { "<leader>cs", ":CopilotChatCommit<CR>",   mode = "v", desc = "Generate Commit for Selection" },
    },
  },
}
