#!/bin/bash
while [ 1 == 1 ]; do
    ifup thunderbolt0
    ifup thunderbolt1
    sleep 10
done
