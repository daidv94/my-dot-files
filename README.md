# Collection of my dot files for all my laptops.

I love working in terminal, I'm using vim everyday, currently all my working flows are on terminal.
My `dotfiles` are managed by this repository with the wonderful help of [stow](https://github.com/aspiers/stow)

## List

- [zshrc](./zsh/)
- [wezterm](./wezterm/)
- [tmux](./tmux/)
- [yazi](./yazi/)
- [neovim](./nvim/)
- [agents](./agents/)

## Keybinding layers

**tmux is the only multiplexer.** WezTerm and tmux both ship panes and tabs, and
running both means answering "which one am I splitting?" on every split. tmux wins
that comparison: sessions survive a restart via tmux-resurrect/continuum, they work
over SSH, they detach and reattach, and vim-tmux-navigator makes them continuous with
nvim splits. WezTerm is a renderer here, nothing more.

So the rule is simple:

- **WezTerm binds no leader and no pane or tab management.** Every CTRL key reaches
  tmux and nvim untouched. WezTerm keeps only rendering, the random background
  (`CTRL+SHIFT+b`), OPT+arrow word motion, and its own CMD defaults for font size,
  copy/paste, and window-level actions.
- **`C-a` is the tmux prefix.** `C-h/j/k/l` navigates tmux panes and nvim splits
  interchangeably, via
  [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - the tmux
  side binds them in the root table and forwards the keypress to nvim when the pane
  is running nvim, so one keystroke crosses both.

If navigation ever breaks, run `wezterm show-keys`. A bare lowercase `CTRL h` entry
means something in WezTerm is shadowing tmux. Uppercase (`CTRL H`) is Ctrl+Shift and
is harmless.

Escape hatches for keys tmux swallows:

| Keys | Sends |
| --- | --- |
| `C-a` `C-a` | literal `C-a` (beginning-of-line in the shell) |
| `C-a` `C-l` | literal `C-l` (clear screen) |

Two known gaps, both deliberate:

- `C-j` in nvim insert mode is mapped to `<Esc>`, so it does not navigate from insert
  mode. Leave insert mode first.
- `C-h/j/k/l` in a shell pane is consumed by tmux, so `C-h` no longer backspaces.

### Switching to WezTerm-only

The removed WezTerm multiplexing layer is preserved at
[`multiplexer.lua.disabled`](./wezterm/.config/wezterm/multiplexer.lua.disabled) with
re-enable instructions in its header. The short version: rename it to
`multiplexer.lua`, call `require("multiplexer").apply(config)` from `wezterm.lua`,
stop launching tmux, and swap vim-tmux-navigator for
[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) - that last step
is not optional, since vim-tmux-navigator cannot drive WezTerm panes.

## Dependencies

- Need to use terminal emulator like `wezterm` or `iterm2`... to display theme correctly and even the image background
- Use `Nerfont` for icon, text, folder,... Check the [wezterm](./wezterm/.config/wezterm/wezterm.lua)
- `ripgrep` installed
- *Optional* Background image can be searched in this webpage [WallpaperHD](https://www.wallpaperflare.com/)

### Fonts

- Download and install this font: [Lilex](https://github.com/mishamyrt/Lilex)

## How to use

Run the following command to install all the dotfiles in your home directory:

```bash
stow -v -t ~ zsh wezterm tmux yazi nvim agents
```

### Global agents memory files & skill

Single source of truth for all agents memory files and skills. This is useful when you have multiple agents and want to share the same memory files and skills across them.

1. CLAUDE agents file

```bash
ln -s ~/dotfiles/agents/.agents/AGENTS.md ~/.claude/CLAUDE.md
```

2. Opencode

```bash
ln -s ~/dotfiles/agents/.agents/AGENTS.md ~/.config/opencode/AGENTS.md
```

3. Google Antigravity

```bash
ln -s ~/dotfiles/agents/.agents/AGENTS.md ~/.gemini/config/GEMINI.md
```

3. Skills

```bash
ln -s ~/dotfiles/agents/.agents/skills ~/.claude/skills
```
