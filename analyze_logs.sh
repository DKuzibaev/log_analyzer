#!/bin/bash

output_file="report.txt"

echo "Отчет о логе веб-сервера" > "$output_file"
echo '=========================' >> "$output_file"

if [ ! -f "access.log" ]; then
    echo "Файл access.log не найден!" >> "$output_file"
    exit 1
fi

total_requests=$(wc -l < access.log)
echo "Общее количество запросов: $total_requests" >> "$output_file"

echo "Количество уникальных IP-адресов: $(awk '{ips[$1]++} END {print length(ips)}' access.log)" >> "$output_file"
echo "" >> "$output_file"

awk '{
    split($6, parts, "\"")
    split(parts[2], method_parts, " ")
    methods[method_parts[1]]++
}
END {
    print "Количество запросов по методам:"
    for (m in methods) {
        print methods[m] " " m
    }
}' access.log >> "$output_file"

awk '{
    url = $7
    if (url ~ /\?/) {
        url = substr(url, 1, index(url, "?")-1)
    }
    if (url != "") {
        urls[url]++
    }
}
END {
    max_count = 0
    popular_url = ""
    for (u in urls) {
        if (urls[u] > max_count) {
            max_count = urls[u]
            popular_url = u
        }
    }
    if (popular_url == "") {
        print "\nСамый популярный URL: не удалось определить (возможно, некорректный формат лога)"
    } else {
        print "\nСамый популярный URL: " max_count " " popular_url " "
    }
}' access.log >> "$output_file"

echo "Отчет сохранён в файле $output_file"