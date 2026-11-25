#!/usr/bin/env bash
# Float the active window if it isn't already, then toggle pin.
# When pinning, snap to 300x300 in the top-right corner.

win=$(hyprctl activewindow -j)
floating=$(echo "$win" | jq -r '.floating')
pinned=$(echo "$win" | jq -r '.pinned')

if [ "$floating" = "false" ]; then
    hyprctl dispatch 'hl.dsp.window.float({ action = "toggle" })'
fi

hyprctl dispatch 'hl.dsp.window.pin()'

# Only resize/move when pinning (not when unpinning)
if [ "$pinned" = "false" ]; then
    hyprctl dispatch 'hl.dsp.window.resize({ x = 600, y = 450, relative = false })'
    hyprctl dispatch 'hl.dsp.window.move({ x = 3200, y = 150, relative = false })'
fi
