#!/bin/bash

docker pull registry.cn-hangzhou.aliyuncs.com/vcun/zabbix-server:latest

docker exec zabbix-server /bin/sh -c "mysqldump -uzabbix -pzabbix --opt zabbix > /tmp/zabbix.sql" || (
      echo "Database backup failed!"
      exit
)

[ ! -d "/root/.zabbix" ] && mkdir -p "/root/.zabbix"

[ -f "/root/.zabbix/zabbix.sql" ] && cp /root/.zabbix/zabbix.sql /root/.zabbix/zabbix.sql."$(date +"%Y%m%d%H%M%S")".bak

docker cp zabbix-server:/tmp/zabbix.sql /root/.zabbix/zabbix.sql || (
      echo "Database export failed!"
      exit
)

docker rm zabbix-server -f
# docker volume prune -f
docker run --name zabbix-server -t \
      -p 10051:10051 \
      -p 8080:80 \
      -p 8443:443 \
      -e PHP_TZ="Asia/Shanghai" \
      --net="bridge" \
      -d registry.cn-hangzhou.aliyuncs.com/vcun/zabbix-server:latest

docker container update --restart=always zabbix-server
docker cp /root/.zabbix/zabbix.sql zabbix-server:/tmp/zabbix.sql || exit

i=1
while true; do

      docker exec zabbix-server /bin/sh -c "mysql -uzabbix -pzabbix zabbix < /tmp/zabbix.sql" 2>/dev/null

      if [ $? == 0 ]; then
            docker exec zabbix-server /bin/sh -c "[ -f "/tmp/zabbix.sql" ] && rm /tmp/zabbix.sql"

            echo -e "\e[1;32mThe database is imported successfully\e[0m"

            break
      fi
      echo "please wait(${i})"
      i=$((i + 1))
      sleep 5

done
