autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
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
  git
  fzf-tab
  kube-ps1
  fzf
  docker
  terraform
  kind
  direnv
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.

PROMPT='$(kube_ps1)'$PROMPT

# https://github.com/kurkale6ka/zsh/#fuzzy-cd-based-on-bookmarks
chpwd_functions+=(update_marks)

# Command to execute when pressing Ctrl-t
export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'

# History settings
setopt histignorespace           # skip cmds w/ leading space from history
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

export EDITOR="nvim"
export SUDO_EDITOR="nvim"

# Terraform settings
export TFENV_ARCH="amd64"

# export TF_LOG="INFO"

export AWS_VAULT_BACKEND="pass"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use terminal console for pinentry
# export GPG_TTY=$(tty)
# https://unix.stackexchange.com/a/608921/485981
export GPG_TTY=${TTY}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(direnv hook zsh)"
eval "$(ssh-agent)"
