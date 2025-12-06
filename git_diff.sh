#!/bin/bash

set -e

if [ $# -ne 3 ]; then
    echo "Usage: $0 <repo_url> <branch1> <branch2>"
    exit 1
fi

REPO_URL="$1"
BRANCH1="$2"
BRANCH2="$3"

WORK_DIR=$(pwd)
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

REPORT_FILE="diff_report_${BRANCH1}_vs_${BRANCH2}.txt"
REPORT_FILE=$(echo "$REPORT_FILE" | tr '/' '_')

cd "$TEMP_DIR"
git clone --bare "$REPO_URL" repo.git > /dev/null 2>&1
cd repo.git

DIFF_OUTPUT=$(git diff --name-status "$BRANCH1" "$BRANCH2" 2>/dev/null)

ADDED=0
DELETED=0
MODIFIED=0
TOTAL=0

while IFS=$'\t' read -r status file; do
    [ -z "$status" ] && continue
    TOTAL=$((TOTAL + 1))
    case "$status" in
        A*) ADDED=$((ADDED + 1)) ;;
        D*) DELETED=$((DELETED + 1)) ;;
        M*) MODIFIED=$((MODIFIED + 1)) ;;
        R*) MODIFIED=$((MODIFIED + 1)) ;;
        C*) ADDED=$((ADDED + 1)) ;;
        *) MODIFIED=$((MODIFIED + 1)) ;;
    esac
done <<< "$DIFF_OUTPUT"

DATE_NOW=$(date "+%Y-%m-%d %H:%M:%S")

cd "$WORK_DIR"

cat > "$REPORT_FILE" << EOF
Отчет о различиях между ветками

================================
Репозиторий:    $REPO_URL
Ветка 1:        $BRANCH1
Ветка 2:        $BRANCH2
Дата генерации: $DATE_NOW
================================

СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:
$DIFF_OUTPUT

СТАТИСТИКА:
Всего измененных файлов: $TOTAL
Добавлено (A):    $ADDED
Удалено (D):      $DELETED
Изменено (M):     $MODIFIED
EOF

echo "Отчет сохранен: $REPORT_FILE"

