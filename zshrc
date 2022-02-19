# Init Prompt and completion
autoload -U compinit promptinit

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload -U edit-command-line
zle -N edit-command-line

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.dotfiles/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.dotfiles/zsh"

# set neovim as editor
export EDITOR=nvim

# Add searchpath in bin
export PATH=$PATH:$HOME/bin

# Pipe for sops
export VISOPS_PIPE="gopass keys/id_ed25519 | ssh-to-age -private-key"

# Load aliases
if [ -f $HOME/.dotfiles/aliases_private ]; then
  source $HOME/.dotfiles/aliases_private
fi

# Load aliases
if [ -f $HOME/.dotfiles/aliases ]; then
  source $HOME/.dotfiles/aliases
fi

# Git aliases
if [ -f $HOME/.dotfiles/git_aliases ]; then
  source $HOME/.dotfiles/git_aliases
fi

# Autocorrect
setopt correctall

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt sharehistory hist_ignore_all_dups hist_ignore_space
# No history file in less
export LESSHISTFILE=-

# Disable BEEP
setopt NOBEEP

# Some keybindings
bindkey -e

# https://www.zsh.org/mla/users/2001/msg00870.html
tcsh-backward-delete-word () {
  local WORDCHARS="${WORDCHARS:s#/#}"
  zle backward-delete-word
}
zle -N tcsh-backward-delete-word

# Bindings for ctrl arrow to jump words forward/backwards
bindkey "^[[1;5C" forward-word # ctrl+right
bindkey "^[[1;5D" backward-word # ctrl+left
bindkey "${terminfo[kpp]}" up-line-or-history # page up
bindkey "${terminfo[knp]}" down-line-or-history # page down
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search # arrow up
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search # arrow down
bindkey "${terminfo[kend]}"  end-of-line # end
bindkey "${terminfo[khome]}" beginning-of-line # home
bindkey '\C-x\C-e' edit-command-line # page up
bindkey '^W' tcsh-backward-delete-word
bindkey '^H' tcsh-backward-delete-word # ctrl backspace
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey -s '^N' '¯\\_(ツ)_/¯'

# Type /etc instead of cd /etc
setopt AUTO_CD

# Use extended regex
setopt extendedglob

# Style options
eval "$(dircolors -b)"
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Validate json files
validatejson() {
    python3 -c 'import json; j=json.load(open("'$1'"))'
}

# Pretty print json files
ppjson() {
    python3 -c 'import json; j=json.load(open("'$1'"));json.dump(j, open("pretty_'$1'","w"), indent=4)'
}

send_sms() {
    adb shell service call isms 7 i32 0 s16 "com.android.mms.service" s16 "${1}" s16 "null" s16 "${2}" s16 "null" s16 "null"
}

source $HOME/.dotfiles/zsh-clean.zsh

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
