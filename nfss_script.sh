#!/bin/bash

apt update
apt install -y nfs-kernel-server ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow proto udp from 192.168.50.11/32 to any port 2049
ufw allow proto udp from 192.168.50.11/32 to any port 111
ufw allow proto udp from 192.168.50.11/32 to any port 33333
sed -i 's/ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf
ufw reload

mkdir -p /srv/nfs/upload
chown -R nobody:nogroup /srv/nfs
chmod 0777 /srv/nfs/upload
sed -i 's/RPCMOUNTDOPTS="--manage-gids"/RPCMOUNTDOPTS="--port 33333"/' /etc/default/nfs-kernel-server
echo '/srv/nfs 192.168.50.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)' >> /etc/exports
systemctl restart nfs-kernel-server
