#!/bin/sh

state=$(hyprctl monitors all | grep -A25 'eDP-1' | grep 'disabled: false')

if [[ $? -eq 0 ]]; then
  hyprctl keyword monitor eDP-1,disable
else
  hyprctl keyword monitor eDP-1,preferred,0x0,1.6
fi

