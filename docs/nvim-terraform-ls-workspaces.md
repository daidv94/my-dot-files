# Neovim: one shared terraform-ls and project switching

Files: [`workspaces.lua`](../nvim/.config/nvim/lua/plugins/workspaces.lua), [`lsp.lua`](../nvim/.config/nvim/lua/plugins/lsp.lua), [`neo-tree.lua`](../nvim/.config/nvim/lua/plugins/neo-tree.lua), [`.tmux.conf`](../tmux/.tmux.conf)

## Problem

Neovim started one `terraform-ls` per module folder and never stopped it after the files were closed. Each process holds the provider schemas in memory (370 to 600 MB). One Neovim reached five servers, and several Neovims across tmux windows reached about 7 GB.

## Decision

We use one Neovim and one `terraform-ls`, and switch projects inside Neovim. We did not use the client-server setup (one Neovim server for all tmux windows). It only lets you edit in one tmux window, so we reverted it.

## Terms

- **Buffer:** a file open in Neovim's memory.
- **LSP server / client:** a helper process (`terraform-ls`) that provides hover, `gd` and completion, and Neovim's connection to it.
- **Root dir:** the folder a server treats as the project.
- **Workspace folder:** a folder registered with a running server. One server can have several.
- **Autocmd:** a rule that runs code when an event happens.

## Project switching

File: `nvim/.config/nvim/lua/plugins/workspaces.lua`

It installs `sessions.nvim` (saves and restores layout) and `workspaces.nvim` (project list and picker).

- `<leader>e` opens the Telescope project picker.
- On quit, the session for the current folder is saved to `~/.local/share/nvim/sessions`.
- On a plain `nvim` start (no arguments), the session for the current folder is restored. `nvim .` and `nvim file.tf` do not restore, because the arguments are opened instead.

A switch with `<leader>e` runs these steps in order:

1. Save all modified files.
2. Save the current project's session.
3. Close Neo-tree so it stays out of the session.
4. Wipe all buffers, so the old project's servers can stop.
5. Load the new project's session, or open a file finder if there is none.

Register a project once:

```vim
:WorkspacesAdd <name> <path>
```

Start from scratch:

```bash
rm -rf ~/.local/share/nvim/sessions/*
rm -f ~/.local/share/nvim/workspaces
```

## Shared terraform-ls

File: `nvim/.config/nvim/lua/plugins/lsp.lua`

`terraform_root()` returns the nearest folder with `.terraform`, or `.git` if there is none. A module such as `env/<account>/prd/secrets` is its own root.

- **`reuse_client`:** every `terraformls` buffer attaches to the same client, whatever its root.
- **`on_attach`:** registers the buffer's root as a workspace folder on that client with `client:_add_workspace_folder`.
- **`LspDetach` autocmd:** when the last buffer leaves a `terraformls` or `tflint` client, it waits 1 second, checks again, and force-stops the client.

Why the stop waits and forces:

- A session restore reopens files right away, so an immediate stop killed the client it was about to reuse.
- `terraform-ls` ignores a graceful stop while it indexes, so the process never exited and a new client started next to it.

A root of `.git` only gave one server per repo, but `gd` failed inside module folders. The shared server fixed that.

## Keymaps and tmux

- `<leader>te` toggles Neo-tree (it was `<leader>e`).
- tmux window names show the folder name again (`automatic-rename on`, `#{b:pane_current_path}`). Reload with `<prefix> r`.

## Verify

```bash
pgrep -fl terraform-ls
```

Expect one process, with several projects open. In Neovim, list the client and its folders:

```vim
:lua for _, c in ipairs(vim.lsp.get_clients({ name = "terraformls" })) do print(c.id, vim.inspect(vim.tbl_map(function(f) return f.name end, c.workspace_folders))) end
```

Check the parent of each process with `ps -o pid,ppid,etime,rss,command -p $(pgrep -d, terraform-ls)`. A PPID of `1` means an orphan, which you can kill.

## Limits

- One `terraform-ls` crash drops LSP in every open project until it restarts.
- `client:_add_workspace_folder` is a private Neovim method. A Neovim update can break it.
- A module and its parent can both be registered as folders. We have not seen problems, but we don't know how `terraform-ls` treats overlapping folders.
- `reuse_client` set through `vim.lsp.config` worked on our Neovim. If a future version ignores it, several `terraform-ls` processes come back.
