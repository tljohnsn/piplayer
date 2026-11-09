tljohnsn@faucet5:~$ cat /usr/local/sbin/nsupdate.sh
#!/bin/bash

until ping -c 1 -W 1 "dyn.dns.he.net" > /dev/null 2>&1; do
    echo "wait for network..."
    sleep 1
done

echo "network is up..."

source /boot/tunes.txt
curl -k -6 "https://`hostname -s`.trentjohnson.net:$dns_key@dyn.dns.he.net/nic/update?hostname=`hostname -s`.trentjohnson.net"
echo ""
echo "Sent initial update"

while [ 1 ]; do
    echo "sleeping for 5 min"
    sleep 240
    echo "sleeping again..."
    sleep  $(( RANDOM % 60 + 1 ))
    curl -k -6 "https://`hostname -s`.trentjohnson.net:$dns_key@dyn.dns.he.net/nic/update?hostname=`hostname -s`.trentjohnson.net"
    echo ""
done
