# see here https://www.ditig.com/256-colors-cheat-sheet
primary='027'
secondary='226'
danger='196'
white='white'

GIT_PRE="%F{$primary}(%f"
GIT_POST="%F{$primary})%f"

function get_nix_shell() {
    if [ -n "$IN_NIX_SHELL" ]; then
        echo ' %F{$primary}(%f%F{$secondary}nix%f%F{$primary})%f'
    fi
}

function get_git_prompt() {
    # Abort if we aren't in a git repo
    GIT_STATUS=$(git status --porcelain --untracked-files=no 2> /dev/null)
    [ $? -eq 128 ] && return

    GIT_BRANCH_NAME=$(git branch --show-current)
    if [ -z $GIT_BRANCH_NAME ]; then
        GIT_BRANCH_NAME=$(git rev-parse --short)
    fi

    if [ -n "$GIT_STATUS" ]; then
        GIT_STATUS='%F{$danger}✗%f'
    fi

    GIT_PROMPT="%F{$secondary}${GIT_BRANCH_NAME}%f${GIT_STATUS}"

    echo " ${GIT_PRE}${GIT_PROMPT}${GIT_POST}"
}

setopt promptsubst
PROMPT='%B%m: %F{$primary}%2~%f$(get_git_prompt)$(get_nix_shell)%(1j.%j jobs in bg.) %(!.#.$)%b '
RPROMPT='[%*]'
