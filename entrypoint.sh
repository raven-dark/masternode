#!/bin/bash

./ravendarkd -daemon -datadir=/root/data -conf=/root/conf/ravendark.conf

touch /root/data/debug.log

tail -n 100 -f /root/data/debug.log
