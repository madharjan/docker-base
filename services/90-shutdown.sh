#!/bin/bash

set -e

if [ "${DEBUG}" = true ]; then
  set -x
fi

DISABLE_SYSLOG=${DISABLE_SYSLOG:-0}

SYSLOGNG_PIDFILE="/var/run/syslog-ng.pid"

if [ "${DISABLE_SYSLOG}" -eq 0 ]; then
  # wait for syslog-ng to exit
  if [ -f "$SYSLOGNG_PIDFILE" ]; then
    kill $(cat "$SYSLOGNG_PIDFILE")
  fi
fi
