#!/bin/bash

echo '*** Removing old bird config file...'
rm -r /etc/bird

echo '*** Cloning renbaoshuo/network-configs ...'
git clone https://github.com/renbaoshuo/network-configs.git /etc/bird

echo '*** Setting bird configs...'
ip address
read -p 'IPv4 Address: ' OWNIP
read -p 'IPv6 Address: ' OWNIPv6
echo "define OWNIP           = $OWNIP;
define OWNIPv6         = $OWNIPv6;
" > /etc/bird/variables.conf

echo '*** Write crontab configs to /etc/crontab ...'
echo '0 * * * * root git --git-dir=/etc/bird/.git --work-tree=/etc/bird pull origin master:master && birdc c' >> /etc/crontab
echo '*/30 * * * * root /etc/bird/scripts/cron-generate-ptp-cost.sh && birdc c' >> /etc/crontab
systemctl restart cron

echo '*** Updating System Networking Configurations...'
echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p

echo '*** Creating config folders...'
mkdir -p /etc/bird/transits
mkdir -p /etc/bird/peers

echo '*** Set mode +x to scripts...'
find /etc/bird/scripts/*.sh -exec chmod +x {} \;

echo '*** Reconfiguring BIRD...'
birdc configure

echo '*** All done!'
echo ''
