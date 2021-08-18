#!/bin/bash

read -p 'Node: ' NODE
read -p 'Wireguard Listen Port: ' LISTEN_PORT
read -p 'WireGuard Private Key: ' PRIVATE_KEY
read -p 'WireGuard EndPoint: ' ENDPOINT
read -p 'WireGuard Public Key: ' PUBLIC_KEY
read -p 'Own IPv6: ' OWN_IPV6
read -p 'Own Link Local: ' OWN_LINK_LOCAL
read -p 'Neighbor IPv6: ' NEIGHBOR_IPV6

echo "# Baoshuo DN42 Network $NODE Node
[Interface]
PrivateKey = $PRIVATE_KEY
ListenPort = $LISTEN_PORT
PostUp     = ip addr add $OWN_LINK_LOCAL dev %i
PostUp     = ip addr add $OWN_IPV6/128 peer $NEIGHBOR_IPV6/128 dev %i
Table      = off

[Peer]
PublicKey  = $PUBLIC_KEY
Endpoint   = $ENDPOINT
AllowedIPs = 0.0.0.0/0, ::/0
" > /etc/wireguard/bsnet-$NODE.conf

systemctl enable --now wg-quick@bsnet-$NODE
