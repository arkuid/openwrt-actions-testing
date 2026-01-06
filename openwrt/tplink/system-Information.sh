#!/bin/bash
# ================================================
# Название скрипта: Системный информационный скрипт
# Описание: Этот скрипт запрашивает базовую информацию о системе, включая CPU, память, диски и т.д.
# Версия: 1.0
# Автор: DHDAXCW
# ================================================

echo "=== Информация о системе ==="
# Информация о CPU
echo -e "\n=== Информация о CPU ==="
echo -e "Общее количество ядер CPU: $(nproc)"
echo "Подробная информация о CPU:"
if [ -f /proc/cpuinfo ]; then
  echo "Название модели: $(grep 'model name' /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^\s*//')"
  echo "Текущая частота: $(grep 'cpu MHz' /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^\s*//') МГц"
  echo "Размер кэша: $(grep 'cache size' /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^\s*//')"
  echo "Тип архитектуры: $(lscpu | grep 'Architecture' | cut -d':' -f2 | sed 's/^\s*//')"
  echo "Ядер на сокет: $(lscpu | grep 'Core(s) per socket' | cut -d':' -f2 | sed 's/^\s*//')"
  echo "Потоков на ядро: $(lscpu | grep 'Thread(s) per core' | cut -d':' -f2 | sed 's/^\s*//')"
      
  # Максимальная и минимальная частота
  MAX_FREQ=$(lscpu | grep -E 'CPU max MHz|CPU MHz max' | cut -d':' -f2 | sed 's/^\s*//')
  MIN_FREQ=$(lscpu | grep -E 'CPU min MHz|CPU MHz min' | cut -d':' -f2 | sed 's/^\s*//')
  echo "Максимальная частота: ${MAX_FREQ:-неизвестно} МГц"
  echo "Минимальная частота: ${MIN_FREQ:-неизвестно} МГц"
else
  echo "Информация о CPU недоступна (файл /proc/cpuinfo отсутствует)"
fi

# Информация о памяти
echo -e "\n=== Информация о памяти ==="
free -h | awk '/^Mem:/ {print "Общая память\t: " $2 "\nИспользуется\t: " $3 "\nСвободно\t: " $4}'

# Информация о дисках
echo -e "\n=== Информация о дисках ==="
df -h | grep -E '^/dev/' | awk '{print "Устройство: " $1 "\tРазмер: " $2 "\tИспользуется: " $3 "\tДоступно: " $4 "\tТочка монтирования: " $6}'

# Информация о сетевых интерфейсах
echo -e "\n=== Информация о сетевых интерфейсах ==="
if command -v ethtool >/dev/null 2>&1; then
  for iface in $(ip -br addr show | awk '{print $1}' | grep -v '^lo$'); do
    echo "Имя интерфейса: $iface"
    echo "Статус\t: $(ip -br addr show | grep "^$iface" | awk '{print $2}')"
    echo "IP-адрес\t: $(ip -br addr show | grep "^$iface" | awk '{print $3}')"
    echo "Скорость\t: $(ethtool "$iface" 2>/dev/null | grep 'Speed:' | awk '{print $2}' || echo 'неизвестно')"
    echo "----------------"
  done
else
  echo "ethtool не установлен, показывается только базовая информация о сетевых интерфейсах"
  ip -br addr show | awk '{print "Интерфейс: " $1 "\tСтатус: " $2 "\tIP: " $3}'
fi

#echo -e "\n=== Тест скорости сети ==="
#if command -v speedtest-cli >/dev/null 2>&1; then
#  echo "Тестирование скорости сети, пожалуйста подождите..."
#  speedtest-cli --simple
#else
#  echo "speedtest-cli не найден, убедитесь что он установлен."
#fi

# Дополнительная информация о системе
echo -e "\n=== Дополнительная информация о системе ==="
uname -a
[ -f /proc/version ] && echo "Версия:" && cat /proc/version
[ -f /etc/issue.net ] && echo "Дистрибутив (net):" && cat /etc/issue.net
[ -f /etc/issue ] && echo "Дистрибутив:" && cat /etc/issue
echo -e "\nОграничения ресурсов:"
ulimit -a
