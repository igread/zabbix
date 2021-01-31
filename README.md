# zabbix



```bash
docker run --name zabbix-server -t \
      -p 10051:10051 \
      -p 80:80 \
      -p 443:443\
      -e PHP_TZ="Asia/Shanghai" \
      --net="bridge"\
      -d registry.cn-hangzhou.aliyuncs.com/igread/zabbix-server:0.5
```

