#!/bin/bash

# Проверяем, существует ли файл access.log
if [ ! -f "access.log" ]; then
    echo "Файл access.log не найден!"
    exit 1
fi

# Подсчитываем общее количество запросов (строк в файле)
total_requests=$(wc -l < access.log)

# Выводим результат
echo "Общее количество запросов: $total_requests"

#Подсчет уникальный IP-адресов 
echo ""Количество уникальных IP-адресов: $(awk '{print $1}' access.log | sort | uniq | wc -l)"