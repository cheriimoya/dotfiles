#!/usr/bin/env bash

DOTFILES_DIR=${INSTALL_DIR:-"$HOME/.dotfiles"}
CONFIG_DIR="$HOME/.config"

if [ "$INSTALL_DIR" = "$CONFIG_DIR" ]; then
    echo "Cannot install dotfiles into $HOME/.config"
    exit 1
fi

mkdir -p "$CONFIG_DIR"

# Linking all config entries
for entry in $(find "$DOTFILES_DIR/config/" -mindepth 1 -maxdepth 1); do
    if [ -e "$CONFIG_DIR/$entry" ]; then
        echo " -> $CONFIG_DIR/$entry exists, backing up to $DOTFILES_DIR/backup"
        mv -v "$CONFIG_DIR/$entry" "$DOTFILES_DIR/backup/"
    fi
    ln -vs "$entry" "$CONFIG_DIR/"
done

# Setup zshrc
if [ -e "$HOME/.zshrc" ]; then
    echo " -> Moving .zshrc"
    mv -v "$HOME/.zshrc" "$DOTFILES_DIR/backup/"
fi
ln -vs "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

touch "$DOTFILES_DIR/excluded/vim"

# Install tmux plugins
"$DOTFILES_DIR/config/tmux/plugins/tpm/bin/install_plugins"

# Install nvim plugins
nvim "+PlugInstall|:qa"
