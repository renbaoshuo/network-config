#!/bin/bash

echo '*** Removing old bird config file...'
rm -r /etc/bird

echo '*** Cloning renbaoshuo/network-configs ...'
git clone https://github.com/renbaoshuo/network-configs.git /etc/bird

echo '*** Write crontab configs to /etc/crontab ...'
echo '0 * * * * root /etc/bird/scripts/update.sh' >> /etc/crontab
echo '*/30 * * * * root /etc/bird/scripts/cron-generate-ptp-cost.sh && birdc configure' >> /etc/crontab
systemctl restart cron

echo '*** Updating System Networking Configurations...'
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p

echo '*** Please complete configs in /etc/bird/local.conf !'
echo ''
