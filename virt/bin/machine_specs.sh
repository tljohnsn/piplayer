#!/bin/bash

mysql='/usr/bin/mysql'
server='10.0.40.73'
user='virsh'
password='0r4ng3'
db='virsh'
host=`hostname -s`
virsh='/usr/bin/virsh'

host=`hostname -s`
cpu=`cat /proc/cpuinfo | awk -F ':' 'BEGIN {cpus=0} /model name/ {cpus++;model=$2} END {gsub(/[ \t]+/," ",model);print cpus" x" model}'`
memory=`cat /proc/meminfo | awk '/MemTotal/ {print $2" "$3}'`
os_version=`cat /etc/redhat-release`
kernel_version=`uname -r`

/sbin/clock -w

cmd="insert into specs values('$host','$cpu','$memory','$os_version','$kernel_version') on duplicate key update cpu='$cpu',memory='$memory',os_version='$os_version',kernel_version='$kernel_version';"

echo $cmd | $mysql -h $server -u $user -p$password $db
