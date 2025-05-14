return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    config = function()
      require("conform").setup({
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
        -- formatters = {
        --   yamlfix = {
        --     command = "yamlfix",
        --     env = {
        --       YAMLFIX_SEQUENCE_STYLE = "block_style",
        --       YAMLFIX_EXPLICIT_START = "false",
        --       YAMLFIX_WHITELINES = "1",
        --       YAMLFIX_quote_representation = '"',
        --       YAMLFIX_preserve_quotes = "true"
        --     }
        --   }
        -- },
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          hcl = { "terragrunt_hclfmt" },
          terraform = { "terraform_fmt" },
          json = { "jq" },
          yaml = { "prettier" },
          jsonnet = { "jsonnetfmt" },
          go = { "goimports", "gofmt" },
          rust = { "rustfmt", lsp_format = "fallback" },
        },
      })
    end,
  },
}
