# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  aws
  direnv
  docker
  git
  kube-ps1
  terraform
  zsh-autosuggestions
  fzf-tab
  fast-syntax-highlighting
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Wayland settings
export TERM=xterm-256color
if uwsm check may-start && uwsm select; then
  exec uwsm start default
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Check for aliases in the following directories:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh

# https://github.com/kurkale6ka/zsh/#fuzzy-cd-based-on-bookmarks
chpwd_functions+=(update_marks)

# Start ssh-agent if not already running
# Only start ssh-agent if not running or if socket is missing
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
    eval "$(ssh-agent -s)"
fi

# Command to execute when pressing Ctrl-t
export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'
source <(fzf --zsh)

export TFENV_ARCH="amd64"
export AWS_VAULT_BACKEND="pass"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use terminal console for pinentry
# https://unix.stackexchange.com/a/608921/485981
export GPG_TTY=$(tty)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source <(glab completion -s zsh); compdef _glab glab
eval "$(direnv hook zsh)"
eval "$(dive completion zsh)"
eval "$(circleci completion zsh)"

eval "$(/home/aj/.local/bin/mise activate zsh)" # added by https://mise.run/zsh
export PATH=$HOME/.npm-global/bin:$PATH

complete -o nospace -C /usr/bin/terragrunt terragrunt
