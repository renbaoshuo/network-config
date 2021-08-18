#!/bin/sh

cd "$(dirname "$0")"/../
./scripts/generate-ptp-cost.sh > ./ospf/interfaces.conf
