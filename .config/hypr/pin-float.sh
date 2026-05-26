#!/usr/bin/env bash
# Float the active window if it isn't already, then toggle pin.
# When pinning, snap to 300x300 in the top-right corner.

win=$(hyprctl activewindow -j)
floating=$(echo "$win" | jq -r '.floating')
pinned=$(echo "$win" | jq -r '.pinned')

if [ "$floating" = "false" ]; then
    hyprctl dispatch togglefloating
fi

hyprctl dispatch pin

# Only resize/move when pinning (not when unpinning)
if [ "$pinned" = "false" ]; then
    gap=15
    hyprctl dispatch resizeactive exact 600 450
    hyprctl dispatch moveactive exact 3200 150
fi
