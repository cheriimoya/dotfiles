#!/usr/bin/env sh
set -euxo pipefail

pkill sxhkd || true; sxhkd &
pkill flameshot || true; flameshot &
pkill ununclutter || true; unclutter &
pkill dunst || true; dunst &
pkill polybar || true

nextcloud_pid=$(pgrep nextcloud || echo 0)
if [[ $nextcloud_pid == 0 ]]; then
    echo "Starting nextcloud client"
    nextcloud &
fi
