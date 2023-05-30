#!/bin/bash

apt update # обновляем репозитории
apt install -y nfs-kernel-server ufw # устанавливаем межсетевой экран и набор для nfs
ufw default deny incoming # запрещаем все входящие соединения
ufw default allow outgoing # разраешаем все входящие соединения
ufw allow ssh # открываем порт для ssh
ufw allow proto udp from 192.168.50.11/32 to any port 2049 # открываем порт nfs
ufw allow proto udp from 192.168.50.11/32 to any port 111 # открываем порт RPC Portmapper
ufw allow proto udp from 192.168.50.11/32 to any port 33333 # открывваем порт для передачи данных
sed -i 's/ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf # включаем firewall
ufw reload

mkdir -p /srv/nfs/upload # создаем папку для обмена
chown -R nobody:nogroup /srv/nfs # задаем владельца на папку для общего доступа
chmod 0777 /srv/nfs/upload # выставляем права на папку на запись и чтение для всех
sed -i 's/RPCMOUNTDOPTS="--manage-gids"/RPCMOUNTDOPTS="--port 33333"/' /etc/default/nfs-kernel-server # задаем порт для обмена данными в конфиге nfs сервера
echo '/srv/nfs 192.168.50.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)' >> /etc/exports # создаем конфиг для nfs3 udp папки для общего доступа
systemctl restart nfs-kernel-server # перезагружаем служюу nfs, чтобы папка стала активна
