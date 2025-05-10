# My Neovim configuration

My neovim configuration including config, custom keymap. Start from [LazyVim](https://github.com/LazyVim/LazyVim).
Simple just clone this repository into `~/.config/nvim` and start `nvim`

```bash
nvim
```

## Dependencies

- [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) is required for
  `live_grep` and `grep_string` and is the first priority for `find_files`.

## TODO

### Upgrade to nvim 0.11

Update the lsp.lua by following

```lua
-- Define capabilities if needed
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Configure LSP servers
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
      },
    },
  },
  capabilities = capabilities,
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
  capabilities = capabilities,
})

vim.lsp.config('zls', {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig', 'zls.json', '.git' },
  settings = {
    zls = {
      enable_inlay_hints = true,
      enable_snippets = true,
      warn_style = true,
    },
  },
  capabilities = capabilities,
})

vim.lsp.config('harper_ls', {
  cmd = { 'harper-ls' },
  filetypes = { 'markdown' },
  root_markers = { '.git' },
  settings = {
    ['harper-ls'] = {
      userDictPath = '~/dict.txt',
      fileDictPath = '~/.harper/',
      markdown = {
        ignore_link_title = true,
      },
    },
  },
  capabilities = capabilities,
})

-- Enable the configured LSP servers
vim.lsp.enable({ 'lua_ls', 'gopls', 'zls', 'harper_ls' })

-- Configure diagnostics
vim.diagnostic.config({
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

```

- Keep mason to install language server
- Remove mason-lsp config
