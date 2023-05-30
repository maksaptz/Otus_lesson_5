#!/bin/bash

apt update
apt install -y nfs-common ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow proto udp from 192.168.50.10/32 to any port 2049
ufw allow proto udp from 192.168.50.10/32 to any port 111
ufw allow proto udp from 192.168.50.10/32 to any port 33333
sed -i 's/ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf
ufw reload

mkdir -p /mnt/nfs_share
echo "192.168.50.10:/srv/nfs /mnt/nfs_share nfs vers=3,proto=udp 0 0" >> /etc/fstab
mount -a
