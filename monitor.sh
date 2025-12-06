#!/bin/bash

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="/tmp/monitor_daemon.pid"
LOG_DIR="${LOG_DIR:-$SCRIPT_DIR}"
INTERVAL=600

get_metrics() {
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024)}')
        PAGE_SIZE=$(vm_stat | head -1 | grep -oE '[0-9]+')
        FREE_PAGES=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
        FREE_MEM=$((FREE_PAGES * PAGE_SIZE / 1024 / 1024))
        MEM_PERCENT=$(echo "scale=1; (($TOTAL_MEM - $FREE_MEM) * 100) / $TOTAL_MEM" | bc)
        CPU_PERCENT=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
        DISK_PERCENT=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
        LOAD_AVG=$(sysctl -n vm.loadavg | awk '{print $2}')
    else
        read TOTAL_MEM FREE_MEM <<< $(free -m | awk 'NR==2 {print $2, $7}')
        MEM_PERCENT=$(echo "scale=1; (($TOTAL_MEM - $FREE_MEM) * 100) / $TOTAL_MEM" | bc)
        CPU_PERCENT=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        DISK_PERCENT=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
        LOAD_AVG=$(cat /proc/loadavg | awk '{print $1}')
    fi
    
    echo "$TIMESTAMP;$TOTAL_MEM;$FREE_MEM;$MEM_PERCENT;$CPU_PERCENT;$DISK_PERCENT;$LOAD_AVG"
}

run_daemon() {
    while true; do
        sleep $INTERVAL
        
        CSV_FILE="$LOG_DIR/system_report_$(date +%Y-%m-%d).csv"
        
        if [ ! -f "$CSV_FILE" ]; then
            echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$CSV_FILE"
        fi
        
        get_metrics >> "$CSV_FILE"
    done
}

write_first_record() {
    CSV_FILE="$LOG_DIR/system_report_$(date +%Y-%m-%d).csv"
    if [ ! -f "$CSV_FILE" ]; then
        echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$CSV_FILE"
    fi
    get_metrics >> "$CSV_FILE"
}

start_monitor() {
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if kill -0 "$OLD_PID" 2>/dev/null; then
            echo "Монитор уже запущен (PID: $OLD_PID)"
            exit 1
        fi
        rm -f "$PID_FILE"
    fi
    
    write_first_record
    
    nohup "$0" _daemon > /dev/null 2>&1 &
    NEW_PID=$!
    echo $NEW_PID > "$PID_FILE"
    echo "Монитор запущен (PID: $NEW_PID)"
}

stop_monitor() {
    if [ ! -f "$PID_FILE" ]; then
        echo "Монитор не запущен"
        exit 1
    fi
    
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PID_FILE"
        echo "Монитор остановлен (PID: $PID)"
    else
        rm -f "$PID_FILE"
        echo "Процесс не найден, PID файл удален"
    fi
}

status_monitor() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Монитор запущен (PID: $PID)"
            exit 0
        fi
        rm -f "$PID_FILE"
    fi
    echo "Монитор не запущен"
}

case "$1" in
    START)
        start_monitor
        ;;
    STOP)
        stop_monitor
        ;;
    STATUS)
        status_monitor
        ;;
    _daemon)
        run_daemon
        ;;
    *)
        echo "Usage: $0 {START|STOP|STATUS}"
        exit 1
        ;;
esac

