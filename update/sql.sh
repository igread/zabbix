#!/bin/bash

docker pull registry.cn-hangzhou.aliyuncs.com/vcun/zabbix-server:latest

docker exec zabbix-server /bin/sh -c "mysqldump -uzabbix -pzabbix --opt zabbix > /tmp/zabbix.sql" || exit

[ ! -d "/root/.zabbix" ] && mkdir -p "/root/.zabbix"

[ -f "/root/.zabbix/zabbix.sql" ] && cp /root/.zabbix/zabbix.sql /root/.zabbix/zabbix.sql."$(date +"%Y%m%d%H%M%S")".bak

docker cp zabbix-server:/tmp/zabbix.sql /root/.zabbix/zabbix.sql || exit

docker rm zabbix-server -f

docker run --name zabbix-server -t \
      -p 10051:10051 \
      -p 80:80 \
      -p 443:443 -e PHP_TZ="Asia/Shanghai" \
      --net="bridge" \
      -d registry.cn-hangzhou.aliyuncs.com/vcun/zabbix-server:latest
docker cp /root/.zabbix/zabbix.sql zabbix-server:/tmp/zabbix.sql || exit

while true; do

      docker exec zabbix-server /bin/sh -c "mysql -uzabbix -pzabbix zabbix < /tmp/zabbix.sql" 2>/dev/null

      if [ $? == 0 ]; then
            docker exec zabbix-server /bin/sh -c "[ -f "/tmp/zabbix.sql" ] && rm /tmp/zabbix.sql"

            break
      fi

      echo please wait..
      sleep 2

done
