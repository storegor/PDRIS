
Этот проект демонстрирует развертывание Nginx сервера и Python приложения с использованием Ansible в Docker-окружении.

## Структура проекта

```
.├── ansible/
│   ├── ansible/ # Конфигурация Ansible, инвентарь и плейбуки
│   ├── docker-compose.yml # Определяет многоконтейнерное Docker-приложение
│   ├── dockerfileApp # Dockerfile для Flask приложения
│   ├── dockerfileUbuntu # Dockerfile для целевых Ubuntu хостов (Ansible клиент)
│   ├── dockerfileUbuntuHost # Dockerfile для управляющего хоста Ansible
│   └── images/ # Скриншоты для требований Pull Request
├── README.md # Этот файл
```

## Требования

- Docker Desktop (или Docker Engine и Docker Compose)
- Git

## Настройка и запуск

1.  **Клонируйте репозиторий**
2.  **Соберите и запустите Docker контейнеры:**

    Перейдите в директорию `ansible` и запустите Docker контейнеры, определенные в `docker-compose.yml`:

    ```bash
    cd ansible
    docker-compose down 
    docker-compose build
    docker-compose up -d
    ```

    Это запустит три контейнера:
    - `ansible-control`: Главный узел Ansible, с которого выполняются плейбуки Nginx.
    - `ubuntu-1-ssh-host`: Целевой хост для развертывания Nginx.
    - `flask-app`: Ваше Python приложение, работающее напрямую как Docker сервис.

3.  **Запустите плейбуки Ansible (только для Nginx):**

    После того как контейнеры запущены, вам нужно получить доступ к контейнеру `ansible-control` для выполнения плейбука Ansible для Nginx.

    Выполните следующую команду, чтобы войти в контейнер:

    ```bash
    docker exec -it ansible-control bash
    ```

    Теперь вы находитесь внутри контейнера `ansible-control`, и ваша текущая директория должна быть `/home/admin/ansible`. Теперь запустите плейбук для развертывания Nginx:

    - **Развертывание Nginx:**

        ```bash
        ansible-playbook playbooks/deploy-nginx.yml -i hosts
        ```

## Проверка

После запуска плейбука Nginx и запуска Docker Compose вы можете проверить развертывание:

1.  **Проверка Nginx:**

    Откройте веб-браузер и перейдите по адресу `http://localhost:80` (или `http://your_docker_host_ip:80`). Вы должны увидеть стандартную страницу приветствия Nginx.

2.  **Проверка приложения:**

    Откройте веб-браузер и перейдите по адресу `http://localhost:8081` (или `http://your_docker_host_ip:8081`). Вы должны увидеть вывод из Python приложения: "Hello, World from Flask App!".