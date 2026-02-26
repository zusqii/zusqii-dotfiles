#!/bin/bash

# Original options
options=("Keybinds" "Programs" "Animations" "Look and Feel" "Window Rule" "Input")

# Add numbered options with bold numbers
numbered_options=()
for i in "${!options[@]}"; do
    n=$((i+1))
    numbered_options+=("<b>$n.</b> ${options[i]}")
done

# Show menu
choice=$(printf "%s\n" "${numbered_options[@]}" | rofi -dmenu -markup-rows -p "Edit Config")

# Strip number prefix to get actual value
selected=$(echo "$choice" | sed -E 's/<b>[0-9]+.<\/b> //')

# Execute the selected option
case "$selected" in
    "Input") kitty --hold nvim "$HOME/.config/hypr/configs/input.conf" ;;
    "Keybinds") kitty --hold nvim "$HOME/.config/hypr/configs/keybinds.conf" ;;
    "Programs") kitty --hold nvim "$HOME/.config/hypr/configs/programs.conf" ;;
    "Animations") kitty --hold nvim "$HOME/.config/hypr/configs/animations.conf" ;;
    "Window Rule") kitty --hold nvim "$HOME/.config/hypr/configs/windowrule.conf" ;;
    "Look and Feel") kitty --hold nvim "$HOME/.config/hypr/configs/looknfeel.conf" ;;
esac
