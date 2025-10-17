#!/bin/bash

if [ "$#" -eq 2 ]; then
  DOCKER_USERNAME=$1
  DOCKER_PASSWORD=$2
elif [ -z "$DOCKER_USERNAME" ] || [ -z "$DOCKER_PASSWORD" ]; then
  echo "Ошибка: Для выгрузки образа в Docker Registry необходимо установить переменные окружения DOCKER_USERNAME и DOCKER_PASSWORD, либо передать их как аргументы скрипту."
  echo "Использование: ./build_and_push_to_registry.sh [DOCKER_USERNAME] [DOCKER_PASSWORD]"
  exit 1
fi

echo "Logging in to Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось залогиниться в Docker Hub."
  exit 1
fi

echo "Building Docker image..."
docker-compose build
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось собрать Docker образ."
  exit 1
fi

IMAGE_NAME=$(docker-compose config services.web.image 2>/dev/null || echo "lab2-web")
if [ -z "$IMAGE_NAME" ] || [ "$IMAGE_NAME" = "null" ]; then
  IMAGE_NAME="lab2-web"
fi

TAG="$DOCKER_USERNAME/$IMAGE_NAME:latest"

docker tag $IMAGE_NAME $TAG

echo "Pushing Docker image to registry: $TAG..."
docker push $TAG
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось выгрузить Docker образ в реестр."
  exit 1
fi

echo "Docker image $TAG successfully pushed to Docker Registry."
