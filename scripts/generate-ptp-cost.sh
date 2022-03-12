#!/bin/bash

# gathering all interfaces with IPv6 link-local address
for with_ll in $(cat /proc/net/if_inet6 | grep "^fe80" | tr -s ' ' | cut -d ' ' -f 6 | sort -u); do
    # POINTOPOINT flag is 1 << 4, filter non-PTP interfaces out
    if [ $(expr \( $(($(cat /sys/class/net/$with_ll/flags))) / 16 \) % 2) -ne 1 ]; then
        continue
    fi
    cost=65535
    ping_rtt=N/A
    ping_result=$(ping -6 -q -L -n -i 1 -c 10 -W 10 ff02::1%$with_ll)
    ping_loss=$(echo "$ping_result" | grep -oP '\d+(?=% packet loss)')
    if [ $ping_loss -ne 100 ]; then
        ping_rtt=$(echo "$ping_result" | tail -1 | cut -d ' ' -f 4 | cut -d '/' -f 2)
        cost=$(echo | awk '{ printf "%0.0f\n", ('$ping_rtt' * 100 / (100 - '$ping_loss') * 10); }')
    fi
    echo "interface \"$with_ll\" {"
    echo "    cost $cost; # loss $ping_loss %, rtt $ping_rtt ms"
    echo "};"
done
