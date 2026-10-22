#!/bin/bash
while [ 1 == 1 ]; do
    ifup thunderbolt0
    ifup thunderbolt1
    ip link set thunderbolt0 up
    ip link set thunderbolt1 up
    brctl addif vmbr1 thunderbolt0
    brctl addif vmbr1 thunderbolt1
    sleep 10
done
