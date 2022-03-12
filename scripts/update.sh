#!/bin/sh

cd "$(dirname "$0")"
git pull --ff-only && birdc configure
