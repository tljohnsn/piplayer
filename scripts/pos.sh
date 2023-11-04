#!/bin/bash
x=$(gpspipe -w -n 10 |grep lon|tail -n1|cut -d":" -f11|cut -d"," -f1)
y=$(gpspipe -w -n 10 |grep lon|tail -n1|cut -d":" -f10|cut -d"," -f1)
echo "$x $y"
echo $x $y | ./lonlat2maiden 6
