#!/usr/bin/env sh
set -euxo pipefail

echo applying office config

xrandr --auto
xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0
xrandr --output HDMI1 --off
xrandr --output HDMI2 --off
xrandr --output DP2-1 --off
xrandr --output DP2-2 --off

bspc monitor eDP1 -d 1 2 3 4 5 6 7 8 9 0
polybar --config=$HOME/.config/polybar/config.ini 3_primary-top &
polybar --config=$HOME/.config/polybar/config.ini 3_primary-bottom &
