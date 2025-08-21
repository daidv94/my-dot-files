export PATH=/usr/bin:/usr/local/bin:/bin:/sbin:$HOME/bin:/usr/local/go/bin:/opt/homebrew/bin:$HOME/neovim/bin:$PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="$PATH:$HOME/google-cloud-sdk/bin"
export PATH="$PATH:/Library/TeX/texbin"
export ZSH="$HOME/.oh-my-zsh"

# Terminal editor command
export EDITOR="nvim"

eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/half-life.omp.json)"

plugins=(
  git
  helm
  git-prompt
  kubectl
  aws
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# init fzf
source <(fzf --zsh)

# Fzf git integration
source ~/fzf-git.sh/fzf-git.sh

# Bat configuration
BAT_THEME="Catppuccin Mocha"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Alias
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
alias grh='git reset --hard'
alias grs='git reset --sort'

alias tf='terraform'
alias tg='terragrunt'
alias golint='golangci-lint'
alias cd='z'
alias h='heroku'
alias a='aws'
alias n='nvim'
alias c='code'
alias s='stern'
alias dc='docker-compose'
alias b='bat'
alias cat='bat'
alias le="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias gc="gcloud"

/usr/bin/ssh-add -A > /dev/null 2>&1
/usr/bin/ssh-add /Users/danny/.ssh/id_personal > /dev/null 2>&1
/usr/bin/ssh-add /Users/danny/.ssh/id_riverr > /dev/null 2>&1

# Useful function
unset_aws_cred_env () {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

get_aft_session_token () {
  unset_aws_cred_env
  export AWS_PROFILE=riverr
  export JSON=$(aws sts assume-role --role-arn arn:aws:iam::445186940256:role/AWSAFTExecution --role-session-name "AWSAFT-Session")
    export AWS_ACCESS_KEY_ID=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")
    export AWS_SECRET_ACCESS_KEY=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")
    export AWS_SESSION_TOKEN=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")
}

# Remove quarantine attribute from a binary
unquarantine() {
  if [ -z "$1" ]; then
    echo "Usage: unquarantine $1"
    return 1
  fi

  xattr -d com.apple.quarantine "$1"
  echo "Removed quarantine from $1"
}

# Integrate fzf with git
# source ~/fzf-git.sh/fzf-git.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/danny/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/danny/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/danny/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/danny/google-cloud-sdk/completion.zsh.inc'; fi
