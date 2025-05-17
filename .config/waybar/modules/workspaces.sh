#!/bin/bash

hyprctl workspaces -j | jq -r '.[] | " " + .name' | tr '\n' ' '
