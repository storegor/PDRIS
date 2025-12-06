# Shell Scripts

Три скрипта для работы с git, мониторинга системы и анализа логов.

## Установка

```bash
chmod +x git_diff.sh monitor.sh log_analyzer.sh
```

## git_diff.sh

Сравнивает две ветки репозитория и создает отчет.

```bash
./git_diff.sh https://github.com/storegor/PDRIS.git lab1-1.1 lab1-1.2
```

Создаст файл `diff_report_lab1-1.1_vs_lab1-1.2.txt`

## monitor.sh

Мониторинг системы (CPU, память, диск). Собирает данные каждые 10 минут.

```bash
./monitor.sh START   # запустить (первая запись сразу)
./monitor.sh STATUS  # проверить
./monitor.sh STOP    # остановить
```

CSV файлы сохраняются в папку со скриптами: `system_report_YYYY-MM-DD.csv`

## log_analyzer.sh

Ищет ключевое слово в любом текстовом файле (логи приложений, системные логи).

Типичные ключевые слова: ERROR, WARNING, FATAL, Exception, Failed

```bash
./log_analyzer.sh app.log ERROR
./log_analyzer.sh /var/log/system.log WARNING
```

Тестовый пример:

```bash
echo -e "INFO start\nERROR connection failed\nINFO ok\nERROR timeout" > test.log
./log_analyzer.sh test.log ERROR
```

Создаст два файла:
- `test_ERROR_found.txt` - найденные строки
- `test_ERROR_stats.txt` - статистика
