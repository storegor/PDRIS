#!/bin/bash

IMAGE_NAME="lab4-web"

if [ "$#" -ge 1 ]; then
  DOCKER_USERNAME=$1
else
  if [ -z "$DOCKER_USERNAME" ]; then
    echo "Ошибка: Имя пользователя Docker Hub не указано."
    echo "Использование: ./build_and_push_to_registry.sh [DOCKER_USERNAME] [DOCKER_PASSWORD]"
    echo "Или установите переменную окружения DOCKER_USERNAME."
    exit 1
  fi
fi

if [ "$#" -ge 2 ]; then
  DOCKER_PASSWORD=$2
else
  if [ -z "$DOCKER_PASSWORD" ]; then
    echo "Для входа в Docker Hub будет запрошен пароль."
  fi
fi

echo "Logging in to Docker Hub..."
if [ -n "$DOCKER_PASSWORD" ]; then
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
else
    docker login -u "$DOCKER_USERNAME"
fi

if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось залогиниться в Docker Hub."
  exit 1
fi

echo "Building Docker image from './app' directory..."
docker build -t "$IMAGE_NAME" ./app
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось собрать Docker образ."
  exit 1
fi

TAG="$DOCKER_USERNAME/$IMAGE_NAME:latest"

echo "Tagging image as $TAG..."
docker tag "$IMAGE_NAME" "$TAG"

echo "Pushing Docker image to registry: $TAG..."
docker push "$TAG"
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось выгрузить Docker образ в реестр."
  exit 1
fi

echo "Docker image $TAG successfully pushed to Docker Registry."
echo ""
echo "ВАЖНО: Не забудьте обновить имя образа в файле 'k8s/web-deployment.yaml' на '$TAG', чтобы Kubernetes использовал вашу новую версию."
