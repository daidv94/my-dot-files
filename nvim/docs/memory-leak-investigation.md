# Neovim Memory Leak Investigation & Fixes

**Date:** 2026-06-22

## Problem

Neovim accumulating ~8GB memory over long sessions.

## Root Cause (from process analysis)

Multiple orphaned `nvim --embed` processes + copilot Node.js servers that didn't exit when nvim sessions were closed. The config also had settings that amplified background work significantly.

## Config Issues Found

| Issue | File | Details |
|---|---|---|
| `updatetime = 50` | `options.lua:46` | 80x faster than default — amplifies all background plugins |
| `defaults.lazy = false` | `lazy.lua:26` | All 50 plugins load eagerly at startup |
| `checker = { enabled = true }` | `lazy.lua:29` | Background git polling across all plugins |
| gitsigns no debounce | `gitsign.lua:8` | Runs `git diff` on every change |
| gopls heavy codelenses | `lsp.lua:62-71` | `govulncheck`, `vendor`, `regenerate_cgo` running in background |
| vimtex in blink default sources | `blink.lua:108` | LaTeX completion queried on every filetype |
| nvim-tree `lazy = false` | `treeview.lua:4` | Redundant with oil.nvim, loaded eagerly |

## Changes Applied (safe, no breakage)

```
options.lua    updatetime 50 → 300
lazy.lua       checker.enabled true → false
gitsign.lua    update_debounce = 300, max_file_length = 10000
lsp.lua        regenerate_cgo, run_govulncheck, vendor codelenses → false
```

## Changes Reverted (broke nvim)

`defaults.lazy = true` — too broad, broke plugins without explicit triggers. Would need per-plugin `event`/`cmd`/`keys` entries added before re-attempting.

## Deferred Improvements (not yet applied)

- `defaults.lazy = true` + add explicit triggers per plugin (high impact, needs careful per-plugin work)
- Remove `vimtex` from blink default sources (`blink.lua:108`)
- nvim-tree `cmd`-based lazy loading (`treeview.lua`)
- SmartFolds autocmd (fallback to indent folds when no TS parser available)

## Orphaned Process Hygiene

Always quit nvim with `:qa` rather than closing the terminal/tmux pane — otherwise `--embed` child processes and LSP servers (especially copilot Node.js) become orphaned and accumulate. Periodically check:

```bash
ps aux | grep 'nvim\|copilot\|gopls' | grep -v grep
```
