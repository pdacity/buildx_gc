FROM docker:27-cli

# Спецификация OCI-меток для аннотации Docker-образа
LABEL org.opencontainers.image.title="Docker Buildx Garbage Collector" \
      org.opencontainers.image.description="An automated tool designed to periodically clean up unused Docker Buildx build cache" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.authors="Dmitry Malinin" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/pdacity/buildx_gc"

# Самозащита: добавляем собственную метку, чтобы сборщик не удалил свой кэш
LABEL persistent_build=true

# Установка необходимых утилит для работы скрипта
RUN apk add --no-cache bash curl jq

# Копирование и настройка прав исполняемого файла
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
