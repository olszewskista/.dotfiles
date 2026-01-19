#!/bin/bash

if [[ -z $@ ]]; then
  fd ".*\.(conf|json)" $HOME/.config/ --hidden --type file | awk '{ print length, $0 }' | sort -n -s | cut -d' ' -f2-

  exit 0
fi

coproc $(kitty -e nvim $@ >/dev/null 2>&1 )
exit 0
