#!/bin/sh
player_cmd="playerctl -p spotify"
player_status=$($player_cmd status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo "<span color='#1DB954' ></span> $($player_cmd metadata artist) - $($player_cmd metadata title)"
elif [ "$player_status" = "Paused" ]; then
    echo " $($player_cmd metadata artist) - $($player_cmd metadata title)"
fi
