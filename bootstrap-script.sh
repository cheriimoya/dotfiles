#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.dotfiles"

function print_usage() {
    echo "Bootstrap script for cheriimoya/dotfiles"
    echo "Usage:"
    echo "$0 [-d <install directory>]"
}

function check_requirements() {
    programs=(
        "git"
        "zsh"
    )

    exit_code=0
    for program in "${programs[@]}"; do
        set +e
        type $program &> /dev/null
        if [ $? -ne 0 ]; then
            echo " -> Couldn't find $program, please make sure it's installed and can be found in \$PATH"
            exit_code=1
        fi
        set -e
    done

    if [ "$exit_code" -ne 0 ]; then
        echo "Failed to find some programs"
        exit 1
    fi
}

while getopts 'hd:f:' OPTION; do
    case "$OPTION" in
        h)
            print_usage
            exit 0
            ;;
        d)
            darg="$OPTARG"
            # TODO implement
            echo "This is not implemented yet."
            exit 2
            ;;
        *)
            print_usage
            exit 1
        ;;
    esac
done

echo "Checking the requirements"
check_requirements


if [ -d "$INSTALL_DIR" -a "$INSTALL_DIR/.git" ]; then
    echo "There already is a git repo located at $INSTALL_DIR, skipping cloning"
else
    echo "Cloning the repository"
    git clone --recurse-submodules "https://github.com/cheriimoya/dotfiles" "$INSTALL_DIR"
fi

echo "Executing the setup script"
export INSTALL_DIR
exec "$INSTALL_DIR/setup.sh"
