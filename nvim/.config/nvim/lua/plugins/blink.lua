-- Refer https://github.com/ThorstenRhau/neovim/blob/main/lua/optional/blink-cmp.lua
return {
  {
    "micangl/cmp-vimtex",
    ft = "tex",
    config = function()
      require("cmp_vimtex").setup({})
    end,
  },
  {
    "saghen/blink.compat",
    version = "*",
    opts = { impersonate_nvim_cmp = false },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "xzbdmw/colorful-menu.nvim" },
      { "rafamadriz/friendly-snippets" },
      { "micangl/cmp-vimtex" },
      { "giuxtaposition/blink-cmp-copilot" },
    },
    lazy = false,
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      cmdline = {
        keymap = {
          ["<Tab>"] = { "show", "accept" },
        },
        completion = { menu = { auto_show = true } },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },

        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },

        menu = {
          border = "rounded",

          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },

      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            return cmp.select_next()
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            return cmp.select_prev()
          end,
          "snippet_backward",
          "fallback",
        },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
      },

      -- Experimental signature help support
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "cmdline", "vimtex", "copilot" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
          lsp = {
            min_keyword_length = 1, -- Number of characters to trigger provider
            score_offset = 0,       -- Boost/penalize the score of the items
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            score_offset = -1000, -- Copilot items are always at the end
          },
          path = {
            min_keyword_length = 1,
          },
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            min_keyword_length = 2,
            max_items = 10,
          },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          vimtex = {
            name = "vimtex",
            module = "blink.compat.source",
            score_offset = 3,
          },
        },
      },
    },
  },
}
