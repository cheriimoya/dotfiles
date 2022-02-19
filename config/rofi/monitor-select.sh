#!/usr/bin/env bash
set -euxo pipefail

selections=$(ls $HOME/.config/bspwm/layouts)
monitor=$(printf '%s\n' "${selections[@]}" | rofi -dmenu -p 'Select monitor setup')

selections=$(ls $HOME/.config/bspwm/hosts)
bspwm_config=$(printf '%s\n' "${selections[@]}" | rofi -dmenu -p 'Select bspwm config')
if [ $? -ne 0 ]; then
    exit $?
fi

if [ -n "$bspwm_config" ]; then
    $HOME/.config/bspwm/bspwmrc "$bspwm_config" "$monitor"
fi
