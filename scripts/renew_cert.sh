#!/bin/bash
log_line () {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$@" >> /var/log/letsencrypt/cron.log 2>&1
}

log_cmd () {
  "$@" | while IFS= read -r line; do log_line "$line"; done
}

log_line '=== Renewing certificates'
log_cmd /usr/bin/certbot renew --webroot -w /var/www/html --cert-name dc3.se

log_line '=== Reloading nginx'
log_cmd /usr/bin/systemctl reload nginx
