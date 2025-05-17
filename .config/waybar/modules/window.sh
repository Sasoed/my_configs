#!/bin/bash

active_window=$(hyprctl activewindow -j | jq -r '.title // "No Active Window"')

if [[ -z "$active_window" || "$active_window" == "null" ]]; then
  echo "No Active Window"
else
  echo "$active_window"
fi
