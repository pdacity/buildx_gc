# Docker Buildx Garbage Collector / Автоматическая сборка мусора для Docker Buildx

[English](#english) | [Русский](#русский)

---

## English

### About
An automated tool designed to periodically clean up unused Docker Buildx build cache (`docker buildx prune`) based on age constraints, with support for protecting specific build environments using labels.

By default, it targets the Buildx cache layer which often accumulates gigabytes of data during continuous integration (CI/CD) processes.

### Configuration
Configure the parameters inside your `docker-compose.yml` file:
* `AGE` - the maximum allowed age for the build cache before deletion. Supports Go duration strings (e.g., `24h`, `1h30m`).
* `SLEEP` - the interval between cleanup checks. Supports Go duration strings (e.g., `1h`, `30m`).
* `STICKY_LABEL` - a key-value pair (`key=value`) used to protect specific custom Buildx builders from being purged.

### Building with STICKY_LABEL
If you want to protect a specific build node/builder from automated cleanup, assign it a matching label during creation:

```bash
docker buildx create --name my_protected_builder --driver-opt labels=persistent_build=true
```

Then, set `STICKY_LABEL: persistent_build=true` in your `buildx_gc` service configuration.

### Deployment
To start the automatic garbage collector, run:
```bash
docker compose up -d
```

---

## Русский

### О проекте
Инструмент для автоматической и периодической очистки неиспользуемого кэша сборки Docker Buildx (`docker buildx prune`) с возможностью защиты определенных окружений сборки с помощью меток.

Позволяет автоматически освобождать дисковое пространство от устаревшего кэша сборщика, который имеет свойство разрастаться в процессах непрерывной интеграции (CI/CD).

### Настройка
Параметры задаются через переменные окружения в файле `docker-compose.yml`:
* `AGE` - максимальный жизненный цикл кэша сборки, после которого он подлежит удалению. Поддерживает формат Go duration (например, `24h`, `1h30m`).
* `SLEEP` - периодичность запуска проверки кэша. Поддерживает формат Go duration (например, `1h`, `30m`).
* `STICKY_LABEL` - пара `ключ=значение`, используемая для защиты кэша конкретных кастомных билдеров (`buildx builders`) от автоматического удаления.

### Использование STICKY_LABEL
Чтобы защитить определенный сборщик от автоматической очистки кэша, добавьте соответствующую метку при его создании:

```bash
docker buildx create --name my_protected_builder --driver-opt labels=persistent_build=true
```

После этого укажите переменную `STICKY_LABEL: persistent_build=true` в настройках сервиса `buildx_gc`.

### Запуск
Для развертывания сервиса очистки выполните команду:
```bash
docker compose up -d
```
---

See also: https://github.com/pdacity/docker_gc

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=pdacity/buildx_gc&type=Timeline)](https://star-history.com/#pdacity/buildx_gc&Timeline)


