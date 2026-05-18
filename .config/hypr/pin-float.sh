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
    monitor=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
    monitor_w=$(echo "$monitor" | jq -r '.width')
    gap=15
    x=$((monitor_w - 300 - gap))
    hyprctl dispatch resizeactive exact 300 300
    hyprctl dispatch moveactive exact $x $gap
fi
