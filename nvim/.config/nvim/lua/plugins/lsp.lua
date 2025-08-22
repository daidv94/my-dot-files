return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      version = "*",
    },
    {
      "mason-org/mason-lspconfig.nvim",
      version = "*",
    },
  },

  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "terraformls",
        "tflint",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        zls = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup({
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
        gopls = function()
          local lspconfig = require("lspconfig")
          lspconfig.gopls.setup({
            capabilities = capabilities,
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
              gopls = {
                completeUnimported = true,
                usePlaceholders = true,
                gofumpt = true,
                analyses = {
                  unusedparams = true,
                  shadow = true,
                },
                staticcheck = true,
                codelenses = {
                  gc_details = false,
                  generate = true,
                  regenerate_cgo = true,
                  run_govulncheck = true,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                  vendor = true,
                },
              },
            },
            on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true, buffer = bufnr }
              vim.keymap.set("n", "<leader>go", function()
                vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } } })
              end, { desc = "Organize Go imports", unpack(opts) })
            end,
          })
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,
        ["harper_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.harper_ls.setup({
            settings = {
              ["harper-ls"] = {
                userDictPath = "~/dict.txt",
                fileDictPath = "~/.harper/",
                markdown = {
                  ignore_link_title = true,
                },
              },
            },
          })
        end,
      },
    })
    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
