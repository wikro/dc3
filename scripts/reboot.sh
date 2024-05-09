#!/bin/bash

reboot_signal="/tmp/reboot"

if [ -f "$reboot_signal" ]; then
  /usr/bin/rm "$reboot_signal"
  /usr/sbin/reboot
fi

