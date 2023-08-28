#!/bin/bash
x=$(gpspipe -w -n 10 |grep lon|tail -n1|cut -d":" -f9|cut -d"," -f1)
y=$(gpspipe -w -n 10 |grep lon|tail -n1|cut -d":" -f10|cut -d"," -f1)
echo "$x,$y"
