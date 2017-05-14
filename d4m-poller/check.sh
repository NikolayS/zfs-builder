#!/bin/bash
for X in stable beta; do
    mkdir -p tmp
    cd tmp
    curl -sSL -o Docker.dmg https://download.docker.com/mac/$X/Docker.dmg
    7z x Docker.dmg >/dev/null
    strings 4.hfs |grep "#1 SMP" |awk '{print $1}' |awk -F "-" '{print $1}'
    cd ..
    rm -rf tmp
done