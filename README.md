# Лабораторная работа №5

CI/CD Pipeline: Jenkins + Nexus + SonarQube + Ansible

## Быстрый старт

```bash
./demo.sh
```

Скрипт автоматически:
- Запускает все контейнеры
- Настраивает Jenkins (плагины, credentials, jobs)
- Настраивает SonarQube (права, отключает аутентификацию)
- Настраивает Nexus (пароль, anonymous access, allow redeploy)
- Устанавливает Ansible в Jenkins

## Доступ

| Сервис | URL | Логин |
|--------|-----|-------|
| Jenkins | http://localhost:8080 | admin / admin123 |
| Nexus | http://localhost:8081 | admin / admin123 |
| SonarQube | http://localhost:9000 | admin / admin123 |
| Allure | http://localhost:5050 | - |

## Запуск pipeline

1. Открыть Jenkins
2. build-pipeline → Build Now

## Остановка

```bash
docker-compose down -v
```
