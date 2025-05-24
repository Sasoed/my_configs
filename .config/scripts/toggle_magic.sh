#!/bin/bash

# Получаем текущее активное окно
active_window=$(hyprctl activewindow -j | jq -r '.address')

# Если нет активного окна – выход
if [ -z "$active_window" ]; then
    echo "Ошибка: Нет активного окна."
    exit 1
fi

# Получаем workspace активного окна (извлекаем ТОЛЬКО `name`, а не весь объект)
window_ws=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$active_window\") | .workspace.name")

# Получаем workspace, который фактически активен на мониторе (исключая special)
target_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Проверка, чтобы исключить возможные ошибки
if [ -z "$window_ws" ]; then
    echo "Ошибка: Не удалось определить workspace активного окна."
    exit 1
fi

# Если окно уже в special:magic – вернуть его обратно
if [ "$window_ws" = "special:magic" ]; then
    hyprctl dispatch movetoworkspace "$target_ws"
else
    # Перемещаем окно в special:magic (БЕЗ УКАЗАНИЯ address)
    hyprctl dispatch movetoworkspace special:magic
fi

