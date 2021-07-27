#!/bin/bash

echo '*** Backing old bird config file...'
cp /etc/bird/bird.conf /etc/bird/bird.conf.bak

echo '*** Downloading config files...'

wget -4 -O /tmp/bird.conf https://raw.githubusercontent.com/renbaoshuo/network-configs/master/bird.conf && mv /tmp/bird.conf /etc/bird/bird.conf
wget -4 -O /tmp/filter.conf https://raw.githubusercontent.com/renbaoshuo/network-configs/master/filter.conf && mv /tmp/filter.conf /etc/bird/filter.conf
wget -4 -O /tmp/ibgp.conf https://raw.githubusercontent.com/renbaoshuo/network-configs/master/ibgp.conf && mv /tmp/ibgp.conf /etc/bird/ibgp.conf

touch /etc/bird/routes.conf

echo '*** Setting bird configs...'

ip address

read -p 'IPv4 Address: ' ownip
read -p 'IPv6 Address: ' ownipv6
read -p 'Confederation ASN: ' confederationas

echo "define OWNAS           = 141776;
define OWNIP           = $ownip;
define OWNIPv6         = $ownipv6;
define CONFEDERATIONAS = $confederationas;
" > /etc/bird/variables.conf

echo '*** Write crontab configs to /etc/crontab ...'

echo '0 * * * * root wget -4 -O /tmp/bird.conf https://raw.githubusercontent.com/renbaoshuo/network-configs/master/bird.conf && mv /tmp/bird.conf /etc/bird/bird.conf && birdc c
0 * * * * root wget -4 -O /tmp/filter.conf https://raw.githubusercontent.com/renbaoshuo/network-configs/master/filter.conf && mv /tmp/filter.conf /etc/bird/filter.conf && birdc c
0 * * * * root wget -4 -O /tmp/ibgp.conf https://raw.githubusercontent.com/renbaoshuo/network-configs/master/ibgp.conf && mv /tmp/ibgp.conf /etc/bird/ibgp.conf && birdc c
' >> /etc/crontab
systemctl restart cron
systemctl status cron

echo '*** Creating /etc/bird/peers/ folder...'

mkdir -p /etc/bird/peers

birdc c
