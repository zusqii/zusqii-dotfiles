#!/usr/bin/env bash
# Launch clock-rs with pywal color

COLOR=$(cat ~/.cache/wal/colors.json | grep '"color11"' | grep -oP '#[a-fA-F0-9]{6}')

exec clock-rs --color "$COLOR" "$@"
