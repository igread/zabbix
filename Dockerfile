FROM zabbix/zabbix-appliance:latest
ENV TZ=Asia/Shanghai \
    PHP_TZ=Asia/Shanghai
# COPY nginx.conf /etc/zabbix/nginx/
COPY config_file/ /tmp/config_file/
RUN apk add -U tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && sed -i 's/^date\.timezone=Europe\/Riga/date\.timezone=Asia\/Shanghai/g' /etc/php7/conf.d/99-zabbix.ini \
    && mv /tmp/config_file/mfont.ttf /usr/share/zabbix/assets/fonts/ -f \
    && mv /tmp/config_file/cfssl/cfssl* /usr/local/bin/ -f \
    && chmod +x /usr/local/bin/cfssl* \
    && mv /tmp/config_file/ssl /etc/nginx/ -f \
    && cd /etc/nginx/ssl/ssl-conf/ \
    # 生成证书
    && cfssl gencert -initca ca-csr.json | cfssljson -bare ca \
    && cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www self-csr.json | cfssljson -bare self \
    && cat self.pem ca.pem > ssl.crt \
    && cp self-key.pem ssl.key \
    && mv ssl.key /etc/nginx/ssl/ \
    && mv ssl.crt /etc/nginx/ssl/ \
    && mv /tmp/config_file/nginx.conf /etc/zabbix/nginx.conf -f \
    && sed -ri 's/(.*)DejaVuSans(.*font file name)/\1mfont\2/' /usr/share/zabbix/include/defines.inc.php \
    && rm -rf /tmp/config_file
