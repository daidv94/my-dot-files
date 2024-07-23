# Make the terminal look more professional

Hope this guide will help you :smiley:
You can refer my [.zshrc](./zshrc) file

## Install Iterm2 or any alternative terminal tool

- [Iterm2](https://iterm2.com/)

## Install oh my zsh

Oh My Zsh is an open source, community-driven framework for managing your zsh configuration, plugin theme.

- Link for documentation and installation: [Oh-My-ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki)
- Install custom oh-my-zsh plugins: `zsh-syntax-highlighting` and `zsh-autosuggestions`
  - :point_right: [Guide](https://gist.github.com/dogrocker/1efb8fd9427779c827058f873b94df95)

In the end, you should have the follwing in the `.zshrc` file

```bash
plugins=(
  git
  oc
  helm
  git-prompt
  kubectl
  aws
  zsh-syntax-highlighting
  zsh-autosuggestions
)
```

Beside of `zsh-syntax-highlighting` and `zsh-autosuggestions`, those are the plugins I'm using. You can refer the list [here](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) to declare your own.

## Install the terminal theme

You can choose one in these two options

- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [starship](https://starship.rs/installing/)

## Better history searching, listfile, etc

- Follow the [fzf](https://github.com/junegunn/fzf) on github, it's really good for you terminal usage.

## Alias

By default, If you install the zsh plugins, the alias will come with it. For example git, kubectl. Try to use command `alias` after you finish installing those above steps.

You can refer my addition alias

```bash
alias gfe='git fetch --prune'
alias gpf='git push -u --force-with-lease'
alias glo='git log --oneline'
alias gb='git branch'
alias gp='git pull'
alias gbr='git branch --remote'
alias gba='git branch --all'
alias gco='git checkout'
alias gst='git status'
alias gca='git commit --amend --no-edit'
alias glg='git log --oneline --graph --decorate'
alias gacapf='git add -u; git commit --amend --no-edit; git push -u --force-with-lease'
alias grh='git reset --hard'
alias grs='git reset --sort'
alias tf='terraform'
alias tg='terragrunt'
alias golint='golangci-lint'
alias h='heroku'
alias a='aws'
```

## Utilities function on bash

You can group some command into a function to reuse them in terminal. For instance, I have a function to unset the AWS credentinal

```bash
unset_aws_cred_env () {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}
```
