# Лабораторная работа №2 - Docker + Docker Compose

Этот проект представляет собой двухкомпонентное приложение, состоящее из Flask-веб-приложения и базы данных PostgreSQL, развернутых с использованием Docker и Docker Compose.

## Структура проекта

```
. # Корневая директория проекта
├── app/
│   ├── app.py           # Flask-приложение
│   ├── Dockerfile       # Dockerfile для Flask-приложения
│   └── requirements.txt # Зависимости Flask-приложения
├── db/
│   └── init.sql         # Скрипт инициализации PostgreSQL
├── docker-compose.yml   # Конфигурация Docker Compose
├── run_from_registry.sh     # Скрипт для запуска приложения из Docker Registry
└── build_and_push_to_registry.sh # Скрипт для сборки и выгрузки образа в Docker Registry
```

## Требования

Для запуска проекта на вашем компуктере должны быть установлены:
- Docker
- Docker Compose
- `curl` (для проверки доступности приложения)
- `lsof` (для проверки доступности портов)

## 1. Сборка и запуск приложения

Для запуска всего приложения (используя образ из Docker Registry) используйте следующий скрипт:

```bash
./run_from_registry.sh
```

После успешного выполнения скрипта, вы сможете получить доступ к Flask-приложению по адресу: `http://localhost:8000/`.

Каждое обновление страницы Flask-приложения будет добавлять новое сообщение в базу данных PostgreSQL и отображать список всех сообщений.

## 2. Сборка и выгрузка Docker образа в Docker Registry

Для сборки образа и его выгрузки в Docker Registry (например, Docker Hub), используйте следующий скрипт:

```bash
./build_and_push_to_registry.sh [DOCKER_USERNAME] [DOCKER_PASSWORD]
```

**Примеры использования:**

    ```bash
    ./build_and_push_to_registry.sh my_docker_username my_docker_password
    ```

## 3. Проверка работоспособности

После запуска приложения с помощью `./run_from_registry.sh`:

1.  Откройте в браузере `http://localhost:8000/`. Вы должны увидеть страницу Flask с заголовком "Messages from PostgreSQL" и список сообщений. При каждом обновлении страницы должно добавляться новое сообщение.
2.  Вы можете проверить статус запущенных контейнеров командой:
    ```bash
    docker ps
    ```
    Вы должны увидеть два запущенных контейнера: `lab2-web-1` и `lab2-db-1` (или похожие имена).
3.  Для просмотра логов конкретного контейнера:
    ```bash
    docker logs <container_id_или_имя>
    ```
    Например, `docker logs lab2-web-1` или `docker logs lab2-db-1`.

## 4. Сброс и очистка

Чтобы остановить и удалить все контейнеры, сети и тома, связанные с этим проектом, выполните:

```bash
docker-compose down --volumes --remove-orphans
```
