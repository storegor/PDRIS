#!/bin/bash

check_port_available() {
  PORT=$1
  if lsof -i :$PORT > /dev/null; then
    echo "Ошибка: Порт $PORT уже занят другим процессом на вашей хостовой машине. "
    echo "Пожалуйста, освободите порт $PORT (например, завершите конфликтное приложение) и попробуйте снова."
    echo "На macOS это часто бывает 'Control Center' или 'AirPlay Receiver'. Вы можете найти его с помощью 'lsof -i :$PORT' и завершить процесс."
    exit 1
  fi
}

check_port_available 8000

echo "Stopping and removing old containers and networks..."
docker-compose down --volumes --remove-orphans

echo "Starting containers..."
docker-compose up -d

echo "Checking Flask app availability..."
for i in $(seq 1 10);
do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/)
  if [ "$STATUS" == "200" ]; then
    echo "Flask app is available!"
    echo "You can access the Flask application at: http://localhost:8000/"
    exit 0
  fi
  echo "Waiting for Flask app to be available (attempt $i/10)..."
  sleep 5
done

echo "Flask app did not become available after multiple attempts."
exit 1
