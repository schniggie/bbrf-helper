#!/bin/bash

# Run amass (docker) and import into bbrf
# Requirements: amass, bbrf-amass
# Usage: ./amass.sh <domain>

docker run --rm -v /amass/:/.config/amass/ caffix/amass:latest enum -active -d $1 -src -ip -config /.config/amass/config.ini -json .config/amass/$1.json -v
bbrf-amass -p ${1%.*} -path $1.json
