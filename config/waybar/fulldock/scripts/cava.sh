#!/bin/bash
set -o pipefail

bars=18
vert=0
clean=0

usage() {
    local fd=1
    (( ${1:-0} )) && fd=2
    printf 'Usage: %s [--vert] [--clean] [--bars N | --N]\n' "${0##*/}" >&$fd
    exit "${1:-0}"
}

validate_bars() {
    [[ $1 =~ ^[0-9]+$ ]] && (( $1 >= 1 )) || {
        printf 'Invalid bar count: %s\n' "$1" >&2
        exit 1
    }
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage 0 ;;
        --vert)    vert=1 ;;
        --clean)   clean=1 ;;
        --bars)
            [[ -n ${2+x} ]] || { printf 'Missing value for --bars\n' >&2; exit 1; }
            bars="$2"; shift
            validate_bars "$bars"
            ;;
        --bars=*)
            bars="${1#--bars=}"
            validate_bars "$bars"
            ;;
        --[0-9]*)
            bars="${1#--}"
            validate_bars "$bars"
            ;;
        *)
            printf 'Unknown option: %s\n' "$1" >&2
            usage 1
            ;;
    esac
    shift
done

command -v cava >/dev/null 2>&1 || {
    printf 'cava: command not found\n' >&2
    exit 1
}

trap 'kill 0 2>/dev/null' EXIT

# printf is a bash builtin — no fork, unlike the original cat-in-process-substitution
cava -p <(printf '%s\n' \
    '[general]' \
    "bars = $bars" \
    'framerate = 60' \
    '' \
    '[output]' \
    'method = raw' \
    'raw_target = /dev/stdout' \
    'data_format = ascii' \
    'ascii_max_range = 7'
) | awk -v vert="$vert" -v clean="$clean" '
BEGIN {
    c[0] = "▁"; c[1] = "▂"; c[2] = "▃"; c[3] = "▄"
    c[4] = "▅"; c[5] = "▆"; c[6] = "▇"; c[7] = "█"
    idle     = 0
    blanked  = 0
    # 60 consecutive all-zero *displayed* frames ≈ 1 second at 60 fps
    threshold = 60
}
{
    n       = split($0, raw, ";")
    nbars   = 0
    all_zero = 1

    for (i = 1; i <= n; i++) {
        if (raw[i] == "") continue
        nbars++

        actual = raw[i] + 0
        if (actual < 0) actual = 0
        if (actual > 7) actual = 7

        # Gradual decay: the displayed level may drop at most 2 per frame.
        # On the first frame prev[] is implicitly 0, so decayed = -2
        # and displayed = max(actual, -2) = actual.  Correct cold-start.
        decayed   = prev[nbars] - 2
        displayed = (actual > decayed) ? actual : decayed
        if (displayed < 0) displayed = 0

        prev[nbars] = displayed
        if (displayed > 0) all_zero = 0
    }

    # ── debounce ────────────────────────────────────────────────
    if (clean && all_zero) idle++
    else                   idle = 0

    # Once idle long enough, emit one blank line to hide the module,
    # then suppress further output until audio returns.
    if (clean && idle > threshold) {
        if (!blanked) {
            if (vert) printf "{\"text\":\"\"}\n"
            else      printf "\n"
            fflush()
            blanked = 1
        }
        next
    }
    blanked = 0

    # ── build visible output ────────────────────────────────────
    if (vert) {
        out = ""
        for (i = 1; i <= nbars; i++) {
            if (i > 1) out = out "\\n"
            out = out c[prev[i]]
        }
        printf "{\"text\":\"%s\"}\n", out
    } else {
        out = ""
        for (i = 1; i <= nbars; i++)
            out = out c[prev[i]]
        printf "%s\n", out
    }

    fflush()
}'
