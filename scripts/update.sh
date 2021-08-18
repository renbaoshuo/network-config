#!/bin/bash

mv /etc/bird/peers /etc/peers
mv /etc/bird/transits /etc/transits

wget -O install.sh https://raw.githubusercontent.com/renbaoshuo/network-configs/master/scripts/install.sh

bash install.sh

mv /etc/peers /etc/bird/peers
mv /etc/transits /etc/bird/transits

exit 0
