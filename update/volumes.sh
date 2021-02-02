#!/bin/bash

docker pull registry.cn-hangzhou.aliyuncs.com/vcun/zabbix-server:latest
docker stop zabbix-server
docker rename zabbix-server zabbix-server-temp

docker run --name zabbix-server -t \
--volumes-from zabbix-server-temp \
    -p 10051:10051 \
    -p 80:80 \
    -p 443:443\
    -e PHP_TZ="Asia/Shanghai" \
    --net="bridge"\
    -d registry.cn-hangzhou.aliyuncs.com/vcun/zabbix-server:latest
docker container update --restart=always zabbix-server
docker rm zabbix-server-temp
