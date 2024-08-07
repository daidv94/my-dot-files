# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/opt/bin:/opt/homebrew/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export AWS_PAGER=""

unset_aws_cred_env () {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

get_aft_session_token () {
  unset_aws_cred_env
  export AWS_PROFILE=terraform-prod-admin
  export JSON=$(aws sts assume-role --role-arn arn:aws:iam::434310018552:role/AWSAFTAdmin --role-session-name "AWSAFT-Session")
    export AWS_ACCESS_KEY_ID=$(echo ${JSON} | jq --raw-output ".Credentials[\"AccessKeyId\"]")
    export AWS_SECRET_ACCESS_KEY=$(echo ${JSON} | jq --raw-output ".Credentials[\"SecretAccessKey\"]")
    export AWS_SESSION_TOKEN=$(echo ${JSON} | jq --raw-output ".Credentials[\"SessionToken\"]")
}

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

autoload bashcompinit && bashcompinit
source $(brew --prefix)/etc/bash_completion.d/az

source $ZSH/oh-my-zsh.sh

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
alias gacapf='git add -u; git commit --amend --no-edit; git push -u --force-with-lease'
alias gdmb='git branch -vv | grep "gone" | awk "{print $1}" | xargs git branch -D'
alias grh='git reset --hard'
alias grs='git reset --sort'
alias tf='terraform'
alias tg='terragrunt'
alias golint='golangci-lint'
alias h='heroku'
alias a='aws'

/usr/bin/ssh-add -A > /dev/null 2>&1
/usr/bin/ssh-add /Users/geotech/.ssh/id_ed25519_personal > /dev/null 2>&1

eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
