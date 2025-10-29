#!/bin/bash

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"spotify\") | .workspace.id" | head -n 1)

if [[ $running != "" ]]; then
    playerctl -p spotify $@
else
    playerctl $@
fi

