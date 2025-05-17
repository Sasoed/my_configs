#!/bin/bash
INTERFACE="wlan0"

# Получение имени сети
SSID=$(iwgetid -r)

# Сохранение предыдущих значений в временных файлах
RX_PREV=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_PREV=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
sleep 0.5
RX_NEXT=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_NEXT=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

RX_DIFF=$((RX_NEXT - RX_PREV))
TX_DIFF=$((TX_NEXT - TX_PREV))

# Перевод скорости в KB/s
RX_RATE=$(echo "$RX_DIFF / 1024" | bc)
TX_RATE=$(echo "$TX_DIFF / 1024" | bc)

# Формирование JSON-вывода
echo -n "{\"text\": \"$SSID\", \"tooltip\": \"Download: ${RX_RATE} KB/s\\nUpload: ${TX_RATE} KB/s\", \"class\": \"network\"}"
