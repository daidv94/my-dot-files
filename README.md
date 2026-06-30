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

## Dependencies

- Need to use terminal emulator like `wezterm` or `iterm2`... to display theme correctly and even the image background
- Use `Nerfont` for icon, text, folder,... I'm using `JetBrains Mono Nerd Font`
- `ripgrep` installed
- *Optional* Background image can be searched in this webpage [WallpaperHD](https://www.wallpaperflare.com/)

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

3. Skills

```bash
ln -s ~/dotfiles/agents/.agents/skills ~/.claude/skills
```
