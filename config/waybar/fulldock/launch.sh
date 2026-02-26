#!/usr/bin/env bash
# =============================================================================
#  ~/.config/waybar/fulldock/launch.sh
#  Install & launch the fulldock Waybar configuration.
#  Run this once to set up, then call it from your Hyprland config.
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FULLDOCK_DIR="$HOME/.config/waybar/fulldock"

# ---------------------------------------------------------------------------
#  1. Make scripts executable
# ---------------------------------------------------------------------------
chmod +x "$FULLDOCK_DIR/scripts/cava.sh"

# ---------------------------------------------------------------------------
#  2. Create Pywal CSS symlink so style.css can use a relative import.
#     Uncomment and update the @import in style.css to use ./colors.css
# ---------------------------------------------------------------------------
# ln -sf "$HOME/.cache/wal/colors-waybar.css" "$FULLDOCK_DIR/colors.css"

# ---------------------------------------------------------------------------
#  3. Kill any existing Waybar and launch with this config
# ---------------------------------------------------------------------------
pkill -x waybar 2>/dev/null
waybar -c "$FULLDOCK_DIR/config.jsonc" -s "$FULLDOCK_DIR/style.css" &

echo "✓ Waybar fulldock launched from $FULLDOCK_DIR"
