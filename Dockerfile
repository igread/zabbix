FROM zabbix/zabbix-appliance:latest
ENV TZ=Asia/Shanghai
COPY nginx.conf /etc/zabbix/nginx/
COPY mfont.ttf /usr/share/zabbix/assets/fonts/DejaVuSans.ttf
RUN sed -i 's/^date\.timezone=Europe\/Riga/date\.timezone=Asia\/Shanghai/g' /etc/php7/conf.d/99-zabbix.ini