#!/bin/bash

# Чтение текущей раскладки из временного файла
if [ -f /tmp/current_keyboard_layout ]; then
    cat /tmp/current_keyboard_layout
else
    echo "N/A"
fi
