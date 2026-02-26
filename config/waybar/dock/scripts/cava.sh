#!/usr/bin/env bash
# cava.sh — pipe cava output as waybar custom module
# Requires: cava

# Bars to display (default 10)
BARS=${1:-10}

# Characters for bar levels (low to high)
BAR_CHARS=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

CONFIG_FILE=$(mktemp /tmp/cava-waybar-XXXX.cfg)

cat > "$CONFIG_FILE" << CAVAEOF
[general]
bars = $BARS
sleep_timer = 1

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
CAVAEOF

cleanup() {
    rm -f "$CONFIG_FILE"
    kill 0
}
trap cleanup EXIT

cava -p "$CONFIG_FILE" | while IFS= read -r line; do
    output=""
    IFS=';' read -ra values <<< "$line"
    for val in "${values[@]}"; do
        val="${val//[^0-9]/}"
        [[ -z "$val" ]] && continue
        (( val > 7 )) && val=7
        output+="${BAR_CHARS[$val]}"
    done
    echo "$output"
done
