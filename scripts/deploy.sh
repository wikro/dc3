#!/bin/bash

SSH="${DEPLOY_USER}@${DEPLOY_HOST}"

eval `ssh-agent -s`
ssh-add - <<< "$PRIVATE_KEY"

mkdir -p ~/.ssh
ssh-keyscan -H "$DEPLOY_HOST" >> ~/.ssh/known_hosts

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts

rsync --archive --delete html/ "$SSH":/var/www/html/
