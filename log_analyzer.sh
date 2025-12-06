#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <log_file> <keyword>"
    exit 1
fi

LOG_FILE="$1"
KEYWORD="$2"

if [ ! -f "$LOG_FILE" ]; then
    echo "Файл не найден: $LOG_FILE"
    exit 1
fi

BASENAME=$(basename "$LOG_FILE" | sed 's/\.[^.]*$//')
OUTPUT_FILE="${BASENAME}_${KEYWORD}_found.txt"
STATS_FILE="${BASENAME}_${KEYWORD}_stats.txt"

grep -n "$KEYWORD" "$LOG_FILE" > "$OUTPUT_FILE" 2>/dev/null || true

COUNT=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')

cat > "$STATS_FILE" << EOF
Анализ лог-файла
Исходный файл: $LOG_FILE
Ключевое слово: $KEYWORD
Найдено совпадений: $COUNT
Результаты сохранены в: $OUTPUT_FILE
EOF

echo "Найдено: $COUNT"
echo "Результаты: $OUTPUT_FILE"
echo "Статистика: $STATS_FILE"

