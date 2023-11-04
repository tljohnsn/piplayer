#!/bin/bash
#x=$(gpspipe -w -n 10 |grep lon|tail -n1|cut -d":" -f11|cut -d"," -f1)
x=$(gpspipe -w -n 10 |grep lon|tail -n1 | awk -F lon '{print $2}' | cut -d : -f 2 | cut -d , -f1)
#y=$(gpspipe -w -n 10 |grep lat|tail -n1|cut -d":" -f10|cut -d"," -f1)
y=$(gpspipe -w -n 10 |grep lat|tail -n1 | awk -F lat '{print $2}' | cut -d : -f 2 | cut -d , -f1)
echo "$x $y"
echo $x $y | ./lonlat2maiden 6
sed -i -e "s%locator\":.*,%locator\": \"`echo $x $y | ./lonlat2maiden 6`\",%" ~/.config/pat/config.json

