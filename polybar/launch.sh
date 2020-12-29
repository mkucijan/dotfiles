#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar -q main -c "$DIR"/config.ini &


# Lunch extra monitor bar
external_monitor=$(xrandr --query | grep 'DVI-I-0')
if [[ $external_monitor = *connected* ]]; then
    echo "Extra monitor connected: $external_monitor"
    polybar -q top_external -c "$DIR"/config.ini &
fi