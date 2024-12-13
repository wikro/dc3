#!/bin/bash

SSH="${DEPLOY_USER}@${DEPLOY_HOST}"

eval `ssh-agent -s`
ssh-add - <<< "$PRIVATE_KEY"

mkdir -p ~/.ssh
ssh-keyscan -H "$DEPLOY_HOST" >> ~/.ssh/known_hosts

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts

rsync --archive --delete html/ "$SSH":/var/www/html/
rsync --archive --delete scripts/ "$SSH":/opt/scripts/

rsync --archive nginx/nginx.conf "$SSH":/etc/nginx/nginx.conf
ssh "$SSH" "sudo systemctl reload nginx"
