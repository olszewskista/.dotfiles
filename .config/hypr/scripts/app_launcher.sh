#!/bin/bash

app_command=$1
app_class=${2:-$1}

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${app_class}\") | .workspace.id" | head -n 1)

if [[ $running != "" ]]; then
    hyprctl dispatch workspace $running
else
    $app_command &
fi

