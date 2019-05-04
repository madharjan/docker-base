#!/bin/bash

set -e

if [ "${DEBUG}" = true ]; then
  set -x
fi

DISABLE_SYSLOG=${DISABLE_SYSLOG:-0}
DISABLE_CRON=${DISABLE_CRON:-0}

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

if [ "${DISABLE_SYSLOG}" -eq 0 ]; then
  # start syslog-ng

  # If /dev/log is either a named pipe or it was placed there accidentally,
  # e.g. because of the issue documented at https://github.com/phusion/baseimage-docker/pull/25,
  # then we remove it.
  if [ ! -S /dev/log ]; then rm -f /dev/log; fi
  if [ ! -S /var/lib/syslog-ng/syslog-ng.ctl ]; then rm -f /var/lib/syslog-ng/syslog-ng.ctl; fi

  # determine output mode on /dev/stdout because of the issue documented at https://github.com/phusion/baseimage-docker/issues/468
  if [ -p /dev/stdout ]; then
    sed -i 's/##SYSLOG_OUTPUT_MODE_DEV_STDOUT##/pipe/' /etc/syslog-ng/syslog-ng.conf
  else
    sed -i 's/##SYSLOG_OUTPUT_MODE_DEV_STDOUT##/file/' /etc/syslog-ng/syslog-ng.conf
  fi

  # If /var/log is writable by another user logrotate will fail
  /bin/chown root:root /var/log
  /bin/chmod 0755 /var/log

  SYSLOGNG_PIDFILE="/var/run/syslog-ng.pid"
  SYSLOGNG_OPTS=""

  [ -r /etc/default/syslog-ng ] && . /etc/default/syslog-ng

  case "x$CONSOLE_LOG_LEVEL" in
    x[1-8])
      dmesg -n $CONSOLE_LOG_LEVEL
      ;;
    x)
      ;;
    *)
      echo "CONSOLE_LOG_LEVEL is of unaccepted value."
      ;;
  esac

  if [ ! -e /dev/xconsole ]
  then
    mknod -m 640 /dev/xconsole p
    chown root:adm /dev/xconsole
    [ -x /sbin/restorecon ] && /sbin/restorecon $XCONSOLE
  fi

  exec syslog-ng -F -p $SYSLOGNG_PIDFILE $SYSLOGNG_OPTS &
  syslogng_wait 1 $?
fi

if [ ! "${DISABLE_SYSLOG}" -eq 0 ]; then
  touch /etc/service/syslog-forwarder/down
else
  rm -f /etc/service/syslog-forwarder/down
fi

if [ ! "${DISABLE_CRON}" -eq 0 ]; then
  touch /etc/service/cron/down
else
  rm -f /etc/service/cron/down
fi
