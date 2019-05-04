#!/bin/bash

set -e

if [ "${DEBUG}" = true ]; then
  set -x
fi

DISABLE_SYSLOG=${DISABLE_SYSLOG:-0}

syslogng_wait() {
  if [ "$2" -ne 0 ]; then
      return 1
  fi

  RET=1
  for i in $(seq 1 30); do
      status=0
      syslog-ng-ctl stats >/dev/null 2>&1 || status=$?
      if [ "$status" != "$1" ]; then
          RET=0
          break
      fi
      sleep 1s
  done
  return $RET
}

SYSLOGNG_PIDFILE="/var/run/syslog-ng.pid"

if [ "${DISABLE_SYSLOG}" -eq 0 ]; then
  # wait for syslog-ng to exit
  if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE")
  fi

  syslogng_wait 0 $?
fi
