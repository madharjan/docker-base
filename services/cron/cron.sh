#!/bin/bash
set -e
source /build/config/buildconfig
set -x

CRON_BUILD_PATH=/build/services/cron

$minimal_apt_get_install cron

mkdir -p /etc/service/cron
chmod 600 /etc/crontab
cp ${CRON_BUILD_PATH}/cron.runit /etc/service/cron/run
chmod 750 /etc/service/cron/run

## Remove useless cron entries.
# Checks for lost+found and scans for mtab.
rm -f /etc/cron.daily/standard
rm -f /etc/cron.daily/upstart
rm -f /etc/cron.daily/dpkg
rm -f /etc/cron.daily/password
rm -f /etc/cron.weekly/fstrim
