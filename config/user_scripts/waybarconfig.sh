#!/bin/bash

# --- Waybar Numbered Switcher ---

# List of available Waybar setups
waybars=("Minimal" "Dock" "Full-Dock")

# Add numbers in front for the Rofi menu
numbered_waybars=()
for i in "${!waybars[@]}"; do
    n=$((i+1))
    numbered_waybars+=("$n. ${waybars[i]}")
done

# Show Rofi menu
choice=$(printf "%s\n" "${numbered_waybars[@]}" | rofi -dmenu -p "Select Waybar Setup")

# Exit if nothing selected
[ -z "$choice" ] && exit 0

# Strip number prefix to get the actual directory name
selected_waybar=$(echo "$choice" | sed 's/^[0-9]\+\. //')

# Kill existing Waybar and wait for it to die
pkill -x waybar
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

# Launch the selected Waybar based on your folder structure
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
        # Points to the new setup in ~/.config/waybar/fulldock/ [cite: 1, 3]
        waybar -c ~/.config/waybar/fulldock/config.jsonc \
               -s ~/.config/waybar/fulldock/style.css & disown [cite: 1, 3]
        ;;
    *)
        notify-send "Waybar Switcher" "Invalid option: $selected_waybar"
        ;;
esac
