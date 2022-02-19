#!/usr/bin/env sh
xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --output HDMI1 --mode 1920x1080 --pos 1920x0 --rotate normal

bspc monitor eDP1 -d 1 2 3 4 5
bspc monitor HDMI1 -d 6 7 8 9 0

polybar --config=$HOME/.config/polybar/config.ini 3_primary-top &
polybar --config=$HOME/.config/polybar/config.ini 3_primary-bottom &
# TODO properly make docking1 handle tray icons
sleep 1
polybar --config=$HOME/.config/polybar/config.ini 3_hdmi1-top &
