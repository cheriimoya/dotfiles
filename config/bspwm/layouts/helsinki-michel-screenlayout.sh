#!/usr/bin/env sh
set -xeuo pipefail

xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --output DP2-1 --mode 1920x1080 --pos 3840x0 --rotate normal
xrandr --output DP2-2 --mode 1920x1080 --pos 1920x0 --rotate normal

bspc monitor eDP1 -d 1 2 3
bspc monitor DP2-2 -d 4 5 6 7
bspc monitor DP2-1 -d 8 9 0

polybar --config=$HOME/.config/polybar/config.ini 3_primary-top &
polybar --config=$HOME/.config/polybar/config.ini 3_primary-bottom &
polybar --config=$HOME/.config/polybar/config.ini 3_docking1-top &
polybar --config=$HOME/.config/polybar/config.ini 3_docking2-top &
