FROM zabbix/zabbix-appliance:latest
ENV TZ=Asia/Shanghai
# COPY nginx.conf /etc/zabbix/nginx/
COPY mfont.ttf /usr/share/zabbix/assets/fonts/mfont.ttf
RUN apk add -U tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && sed -i 's/^date\.timezone=Europe\/Riga/date\.timezone=Asia\/Shanghai/g' /etc/php7/conf.d/99-zabbix.ini \
    && sed -i 's/DejaVuSans/mfont\.ttf/g' /usr/share/zabbix/include/defines.inc.php 
