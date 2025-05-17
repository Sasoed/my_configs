#!/bin/bash

# Предыдущая раскладка
previous_layout=""

while true; do
    # Получаем текущую раскладку
    layout=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

    # Упрощённый вывод: используем только ASCII
    if [[ "$layout" == "Russian" ]]; then
        layout="RU"
    elif [[ "$layout" == "English (US)" ]]; then
        layout="EN"
    else
        layout="??"
    fi

    # Если раскладка не изменилась, ничего не делаем
    if [[ "$layout" == "$previous_layout" ]]; then
        sleep 0.1
        continue
    fi

    # Формируем JSON-объект
   #echo "{\"text\": \"$layout\", \"tooltip\": \"Current layout: $layout\"}" > /tmp/current_keyboard_layout.json
    echo "{\"text\": \"$layout\"}" > /tmp/current_keyboard_layout.json
    previous_layout="$layout"

    # Обновляем Waybar
   # pkill -SIGUSR1 waybar

    sleep 0.1
done
