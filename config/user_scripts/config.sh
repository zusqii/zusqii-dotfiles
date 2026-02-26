#!/bin/bash

# --- Main Config Menu ---
options=("Hyprland" "Kitty" "Waybar")

# Add numbers for Rofi
numbered_options=()
for i in "${!options[@]}"; do
    n=$((i+1))
    numbered_options+=("$n. ${options[i]}")
done

choice=$(printf "%s\n" "${numbered_options[@]}" | rofi -dmenu -p "🔍 Config Menu" -theme="~/.config/rofi/minimal/config.rasi")
[ -z "$choice" ] && exit 0
selected=$(echo "$choice" | sed 's/^[0-9]\+\. //')

case "$selected" in
    "Hyprland")
        "$HOME/.config/user_scripts/hyprlandconfig.sh"
        ;;
    "Kitty")
        kitty --hold nvim "$HOME/.config/kitty/kitty.conf"
        ;;
    "Waybar")
        # --- SUBMENU: Waybar Switcher ---
        # Include your new Full-Dock setup here
        waybars=("Minimal" "Dock" "Full-Dock")
        numbered_waybars=()
        for i in "${!waybars[@]}"; do
            n=$((i+1))
            numbered_waybars+=("$n. ${waybars[i]}")
        done

        choice2=$(printf "%s\n" "${numbered_waybars[@]}" | rofi -dmenu -p "Select Waybar")
        [ -z "$choice2" ] && exit 0
        selected_waybar=$(echo "$choice2" | sed 's/^[0-9]\+\. //')

        # Kill and wait for Waybar to close before relaunching
        pkill -x waybar
        while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

        case "$selected_waybar" in
            "Minimal")
                waybar -c ~/.config/waybar/minimal/config.jsonc \
                       -s ~/.config/waybar/minimal/style.css & disown
                ;;
            "Dock")
                waybar -c ~/.config/waybar/dock/config.jsonc \
                       -s ~/.config/waybar/dock/style.css & disown
                ;;
            "Full-Dock")
                # Using the fulldock directory we created
                waybar -c ~/.config/waybar/fulldock/config.jsonc \
                       -s ~/.config/waybar/fulldock/style.css & disown
                ;;
        esac
        ;;
esac
