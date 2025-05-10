#!/usr/bin/env bash
source "$HOME/gothic/.scripts/variables.bash"

start_waybar() {
    waybar -c $WAYBAR_CONF -s $WAYBAR_STYLE &
}

toggle_waybar() {
    if pgrep -u $USER "waybar" >/dev/null; then
        pkill -u $USER waybar
    else
        start_waybar
    fi
}

toggle_waybar
