#!/bin/bash

running=$(hyprctl -j clients | jq -r '.[] | select(.class | test("^spotify$"; "i")) | .workspace.id' | head -n 1)

if [[ $running != "" ]]; then
    playerctl -p spotify $@
else
    playerctl $@
fi

