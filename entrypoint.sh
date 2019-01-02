#!/bin/bash

./ravendarkd --daemon -datadir=/root/data

touch /root/data/debug.log

tail -n 100 -f /root/data/debug.log
