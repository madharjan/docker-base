#!/bin/bash
set -e
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

if [ "${DEBUG}" == true ]; then
  set -x
fi

CRON_BUILD_PATH=/build/services/cron

apt-get install -y --no-install-recommends cron

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
