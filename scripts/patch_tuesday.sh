#!/bin/bash

log_line () {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$@" >> /var/log/apt/cron.log 2>&1
}

log_cmd () {
  "$@" | while IFS= read -r line; do log_line "$line"; done
}

apt_cmd () {
  log_cmd /usr/bin/apt-get "$@" -q -y
}

log_line '=== Clean apt cache'
apt_cmd clean all

log_line '=== Autoremove packages'
apt_cmd autoremove

log_line '=== Update apt cache'
apt_cmd update

log_line '=== Upgrade packages'
apt_cmd upgrade

log_line '=== Rebooting'
log_cmd /usr/sbin/reboot
