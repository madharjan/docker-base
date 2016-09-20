@test "checking process: my_init" {
  run docker exec base /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/bin/python3 -u /sbin/my_init'"
  [ "$status" -eq 0 ]
}

@test "checking process: runit" {
  run docker exec base /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/bin/runsvdir -P /etc/service'"
  [ "$status" -eq 0 ]
}

@test "checking process: syslog (default is enabled)" {
  run docker exec base /bin/bash -c "ps aux --forest | grep -v grep | grep 'syslog-ng -F -p /var/run/syslog-ng.pid --no-caps'"
  [ "$status" -eq 0 ]
}

@test "checking process: syslog (disabled by DISABLE_SYSLOG)" {
  run docker exec base_no_syslog /bin/bash -c "ps aux --forest | grep -v grep | grep 'syslog-ng -F -p /var/run/syslog-ng.pid --no-caps'"
  [ "$status" -eq 1 ]
}

@test "checking process: syslog-forwarder (default is enabled)" {
  run docker exec base /bin/bash -c "ps aux --forest | grep -v grep | grep 'tail -F /var/log/syslog'"
  [ "$status" -eq 0 ]
}

@test "checking process: syslog-forwarder (disabled by DISABLE_SYSLOG)" {
  run docker exec base_no_syslog /bin/bash -c "ps aux --forest | grep -v grep | grep 'tail -F /var/log/syslog'"
  [ "$status" -eq 1 ]
}

@test "checking process: cron (default is enabled)" {
  run docker exec base /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/sbin/cron -f'"
  [ "$status" -eq 0 ]
}

@test "checking process: cron (disabled by DISABLE_CRON)" {
  run docker exec base_no_cron /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/sbin/cron -f'"
  [ "$status" -eq 1 ]
}

@test "checking process: syslog-forwarder" {
  run docker exec base /bin/bash -c "ps aux --forest | grep -v grep | grep 'tail -F /var/log/syslog'"
  [ "$status" -eq 0 ]
}
