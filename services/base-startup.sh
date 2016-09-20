#!/bin/bash

set -e

if [ "${DEBUG}" == true ]; then
  set -x
fi

DISABLE_SYSLOG=${DISABLE_SYSLOG:-0}
DISABLE_CRON=${DISABLE_CRON:-0}

if ! [ "${DISABLE_SYSLOG}" -eq 0 ]; then
  touch /etc/service/syslog-ng/down
  touch /etc/service/syslog-forwarder/down
else
  rm -f /etc/service/syslog-ng/down
  rm -f /etc/service/syslog-forwarder/down
fi

if ! [ "${DISABLE_CRON}" -eq 0 ]; then
  touch /etc/service/cron/down
else
  rm -f /etc/service/cron/down
fi
