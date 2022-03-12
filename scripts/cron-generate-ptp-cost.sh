#!/bin/bash

cd "$(dirname "$0")"/../
./scripts/generate-ptp-cost.sh > ./ospf/ospf.interfaces
