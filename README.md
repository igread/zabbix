# zabbix



```bash
docker run --name zabbix-server -t \
      -p 10051:10051 \
      -p 80:80 \
      -p 443:443\
      -e PHP_TZ="Asia/Shanghai" \
      -d igread/zabbix-server:0.4
```

