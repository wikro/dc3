#!/bin/bash

SSH="${DEPLOY_USER}@${DEPLOY_HOST}"

eval `ssh-agent -s`
ssh-add - <<< "$PRIVATE_KEY"

mkdir -p ~/.ssh
ssh-keyscan -H "$DEPLOY_HOST" >> ~/.ssh/known_hosts

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts

tar --transform 's/^./dist/' -cf /tmp/dist.tar .

md5sum /tmp/dist.tar > /tmp/dist.tar.md5

scp /tmp/dist.tar /tmp/dist.tar.md5 "$SSH":/tmp/

ssh "$SSH" "md5sum -c /tmp/dist.tar.md5 && tar -xf /tmp/dist.tar -C /tmp && bash /tmp/dist/scripts/setup.sh"
