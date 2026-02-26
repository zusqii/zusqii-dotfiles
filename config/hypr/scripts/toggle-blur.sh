#!/usr/bin/env bash
# ~/.config/hypr/scripts/toggle-blur.sh

CURRENT=$(hyprctl getoption decoration:blur:enabled | awk '/int:/{print $2}')

if [ "$CURRENT" = "1" ]; then
    hyprctl keyword decoration:blur:enabled false
    notify-send "Blur OFF"
else
    hyprctl keyword decoration:blur:enabled true
    notify-send "Blur ON"
fi
