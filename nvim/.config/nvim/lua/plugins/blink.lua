-- Refer https://github.com/ThorstenRhau/neovim/blob/main/lua/optional/blink-cmp.lua
return {
  "saghen/blink.cmp",
  dependencies = {
    "xzbdmw/colorful-menu.nvim",
  },
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
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
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          min_keyword_length = 2, -- Number of characters to trigger provider
          score_offset = 0, -- Boost/penalize the score of the items
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
      },
    },
  },
}
