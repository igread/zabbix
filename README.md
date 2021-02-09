# zabbix

## 新装

```bash
docker run --name zabbix-server -t \
      -p 10051:10051 \
      -p 80:80 \
      -p 443:443\
      -e PHP_TZ="Asia/Shanghai" \
      --net="bridge"\
      -d registry.cn-hangzhou.aliyuncs.com/vcun/zabbix
```

## 升级

bash <(curl -sL https://github.uon.workers.dev/https://raw.githubusercontent.com/igread/zabbix/main/update/sql.sh)