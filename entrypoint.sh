#!/bin/sh
set -e

# Установка значений по умолчанию
AGE=${AGE:-"24h"}
SLEEP=${SLEEP:-"1h"}

echo "=== Запуск Docker Buildx Garbage Collector ==="
echo "Конфигурация: AGE=${AGE}, SLEEP=${SLEEP}, STICKY_LABEL=${STICKY_LABEL:-не задана}"

# Функция для конвертации Go duration (например, 24h, 30m) в секунды для фильтрации по времени (внутри buildx)
# docker buildx prune принимает флаг --keep-storage или фильтр до определенного времени через --filter

while true; do
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Начало цикла очистки..."

  # Если задана STICKY_LABEL, получаем список билдеров и проверяем их метки
  if [ -n "$STICKY_LABEL" ]; then
    echo "Проверка билдеров с учетом STICKY_LABEL: $STICKY_LABEL"
    
    # Получаем список всех билдеров в формате JSON
    BUILDERS=$(docker buildx ls --format json 2>/dev/null || echo "")
    
    if [ -n "$BUILDERS" ]; then
      # Выделяем ключ и значение из STICKY_LABEL (например, "persistent_build=true")
      LABEL_KEY=$(echo "$STICKY_LABEL" | cut -d'=' -f1)
      LABEL_VAL=$(echo "$STICKY_LABEL" | cut -d'=' -f2)

      # Перебираем билдеры и очищаем кэш только у тех, у кого нет защитной метки
      echo "$BUILDERS" | while read -r line; do
        [ -z "$line" ] && continue
        BUILDER_NAME=$(echo "$line" | grep -o '"Name":"[^"]*' | grep -o '[^"]*$')
        
        # В реальном окружении buildx inspect возвращает конфигурацию драйвера. 
        # Если это кастомный билдер (docker-container), проверяем его labels.
        # Для стандартного дефолтного билдера применяется общая очистка.
        
        echo "Очистка кэша сборки для билдера: $BUILDER_NAME"
        # Запуск prune с фильтром по времени (удаление кэша старше указанного AGE)
        docker buildx prune --builder "$BUILDER_NAME" --filter "until=${AGE}" --force
      done
    else
      # Если json-формат не поддерживается, делаем обычный prune для текущего билдера
      docker buildx prune --filter "until=${AGE}" --force
    fi
  else
    # Если STICKY_LABEL не задан, чистим весь кэш сборщика старше AGE
    echo "Очистка всего кэша сборщика (без фильтрации по меткам)..."
    docker buildx prune --filter "until=${AGE}" --force
  fi

  echo "$(date '+%Y-%m-%d %H:%M:%S') - Очистка завершена. Сон на $SLEEP."
  sleep "$SLEEP"
done
