#!/bin/bash

# Извлечение температур всех ядер, пропуская строки с метаданными
ALL_CORES=$(sensors | grep -i 'Core' | awk '{printf "%s: %s\n", $1, $3}' | tr -d '+')

# Форматирование для тултипа с экранированием
TOOLTIP=$(echo "$ALL_CORES" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g' | tr -d '\r')

# Температура первого ядра (первая строка с температурой)
TEMP=$(echo "$ALL_CORES" | grep -Eo '[0-9]+\.[0-9]+' | head -n 1)
TEMP=${TEMP:-"N/A"}  # Устанавливаем значение по умолчанию, если пусто

# Формирование JSON-объекта
printf '{"text":" %s°C", "tooltip":"%s"}\n' "$TEMP" "$TOOLTIP"
