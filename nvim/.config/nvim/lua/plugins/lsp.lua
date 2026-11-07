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

    local function terraform_root(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      return vim.fs.root(bufnr, { ".terraform", ".git" }) or vim.fs.dirname(name)
    end

    -- Override terraformls built-in config: the lsp/terraformls.lua bundled with
    -- newer nvim-lspconfig calls vim.lsp.codelens.enable() which does not exist
    -- in Neovim 0.11.x. Patch it out via vim.lsp.config before mason loads it.
    vim.lsp.config("terraformls", {
      -- terraform-ls panics on non-file URIs such as diffview://, so only attach to real files.
      root_dir = function(bufnr, on_dir)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match("^%a[%w+.-]*://") then
          return
        end
        on_dir(terraform_root(bufnr))
      end,
      -- One shared terraform-ls: every module root becomes a workspace folder of the same client.
      reuse_client = function(client, config)
        return client.name == config.name
      end,
      on_attach = function(client, bufnr)
        vim.lsp.codelens.refresh({ bufnr = bufnr })
        -- Private Neovim API: the public vim.lsp.buf.add_workspace_folder only acts on the current buffer.
        client:_add_workspace_folder(terraform_root(bufnr))
      end,
    })

    -- Neovim keeps a client alive after its last buffer closes. Stop these heavy
    -- servers so switching workspaces releases the previous project's memory.
    -- The delay lets a session restore re-attach to the same client first, and the
    -- forced stop is needed because terraform-ls ignores a graceful shutdown while indexing.
    local stop_when_unused = { terraformls = true, tflint = true }
    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("StopUnusedLsp", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not stop_when_unused[client.name] then
          return
        end
        for bufnr in pairs(client.attached_buffers) do
          if bufnr ~= args.buf then
            return
          end
        end
        vim.defer_fn(function()
          if not client:is_stopped() and next(client.attached_buffers) == nil then
            client:stop(true)
          end
        end, 1000)
      end,
    })

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
                -- staticcheck = true,
                codelenses = {
                  gc_details = false,
                  generate = true,
                  regenerate_cgo = false,
                  run_govulncheck = false,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                  vendor = false,
                },
              },
            },
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
