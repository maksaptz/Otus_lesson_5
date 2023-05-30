#!/bin/bash

apt update # обновляем репозитории
apt install -y nfs-common ufw # устанавливаем межсетевой экран и набор для nfs
ufw default deny incoming # запрещаем все входящие соединения
ufw default allow outgoing # разрешаем все исходящие соединения
ufw allow ssh # открываем порт для ssh
ufw allow proto udp from 192.168.50.10/32 to any port 2049 # открываем порт nfs
ufw allow proto udp from 192.168.50.10/32 to any port 111 # открываем порт RPC Portmapper
ufw allow proto udp from 192.168.50.10/32 to any port 33333 # открывваем порт для передачи данных
sed -i 's/ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf # включаем firewall
ufw reload

mkdir -p /mnt/nfs_share # создаем папку для обмена
echo "192.168.50.10:/srv/nfs /mnt/nfs_share nfs vers=3,proto=udp 0 0" >> /etc/fstab # добавляем удаленный nfs сервер в автомонтирование
mount -a # монтируем общую  nfs папку
