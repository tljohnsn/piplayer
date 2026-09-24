#!/bin/bash
exit

mysql='/usr/bin/mysql'
server='10.0.40.73'
user='virsh'
password='0r4ng3'
db='virsh'
host=`hostname -s`
virsh='/usr/bin/virsh'
cmd=''

for guest in `$virsh list | awk '/running/ {print $2}'`
do
	cmd=$cmd" insert into guests values('$guest','$host') on duplicate key update host='$host';"
done

echo $cmd | $mysql -h $server -u $user -p$password $db
