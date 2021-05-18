#!/bin/bash

systemctl stop apt-daily.timer
systemctl disable apt-daily.timer
systemctl mask apt-daily.service

systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer
systemctl mask apt-daily-upgrade..service

sed -i -e "s/\*:09,39/1:09/" /etc/systemd/system/timers.target.wants/phpsessionclean.timer

systemctl daemon-reload

echo '# redirect rngd output on Raspberry Pi Buster
:programname,startswith,"rng" /dev/null
:programname,startswith,"rng" stop
'>/etc/rsyslog.d/rng.conf

systemctl stop cups
systemctl stop cups-browsed
systemctl disable cups
systemctl disable cups-browsed
