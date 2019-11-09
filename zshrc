# Init Prompt and completion
autoload -Uz compinit promptinit

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

# set vim as editor
export EDITOR=${EDITOR:-vim}

# Load aliases
if [ -f ~/.aliases_private ]; then
  source ~/.aliases_private
fi

# Load aliases
if [ -f ~/.aliases ]; then
  source ~/.aliases
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
# Bindings for ctrl arrow to jump words forward/backwards
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Type /etc instead of cd /etc
setopt AUTO_CD

# Use extended regex
setopt extendedglob

#colors
autoload -U colors && colors

# Enable Colors
COLOR_BLACK=$'\033'"[${color[black]}m"
COLOR_RED=$'\033'"[${color[red]}m"
COLOR_GREEN=$'\033'"[${color[green]}m"
COLOR_YELLOW=$'\033'"[${color[yellow]}m"
COLOR_BLUE=$'\033'"[${color[blue]}m"
COLOR_MAGENTA=$'\033'"[${color[magenta]}m"
COLOR_CYAN=$'\033'"[${color[cyan]}m"
COLOR_WHITE=$'\033'"[${color[white]}m"

COLOR_BG_BLACK=$'\033'"[${color[bg-black]}m"
COLOR_BG_RED=$'\033'"[${color[bg-red]}m"
COLOR_BG_GREEN=$'\033'"[${color[bg-green]}m"
COLOR_BG_YELLOW=$'\033'"[${color[bg-yellow]}m"
COLOR_BG_BLUE=$'\033'"[${color[bg-blue]}m"
COLOR_BG_MAGENTA=$'\033'"[${color[bg-magenta]}m"
COLOR_BG_CYAN=$'\033'"[${color[bg-cyan]}m"
COLOR_BG_WHITE=$'\033'"[${color[bg-white]}m"

COLOR_BOLD=$'\033'"[${color[bold]}m"
COLOR_RESET=$'\033'"[${color[none]}m"

# Color for Manpages
export LESS_TERMCAP_md=$COLOR_YELLOW
export LESS_TERMCAP_me=$COLOR_RESET

export LESS_TERMCAP_so=$COLOR_WHITE$COLOR_BG_BLUE
export LESS_TERMCAP_se=$COLOR_RESET

export LESS_TERMCAP_us=$COLOR_RED
export LESS_TERMCAP_ue=$COLOR_RESET

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

#make rm harmless
alias rm="rm -I"

# Extract various archive types
extr() {
    if [[ ! -f $1 ]]; then
        return
    fi

    case $1 in
        (*.tar.gz | *.tgz)  tar -xvzf $1;;
        (*.tar.bz2 | *.tbz2)    tar -xvjf $1;;
        (*.gz)          gunzip -v $1;;
        (*.bz2)         bunzip2 -v $1;;
        (*.zip)         unzip $1;;
    esac
}

# Programmers best friend
help() {
    local string=$(printf "%s " "${@}")
    local url=$(python3 -c \
        'from urllib import parse; print(parse.quote_plus("'${string}'"))')
    firefox "https://stackoverflow.com/search?q=${url}"
}

# Validate json files
validatejson() {
    python3 -c 'import json; j=json.load(open("'$1'"))'
}

# Pretty print json files
ppjson() {
    python3 -c 'import json; j=json.load(open("'$1'"));json.dump(j, open("pretty_'$1'","w"), indent=4)'
}

ZSH_THEME="{{ zsh_theme }}"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

DISABLE_AUTO_UPDATE="true"
export UPDATE_ZSH_DAYS=14

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    adb
    catimg
    colorize
    command-not-found
    cp
    docker
    emoji
    encode64
    gitignore
    jsontools
    lol
    nmap
    python
    pylint
    rsync
    themes
    git
)

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

source $ZSH/oh-my-zsh.sh
