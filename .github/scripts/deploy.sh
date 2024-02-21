#!/bin/bash

DEPLOY_SSH="${DEPLOY_USER}@${DEPLOY_HOST}"

eval `ssh-agent -s`
ssh-add - <<< "${PRIVATE_KEY}"

mkdir -p ~/.ssh
ssh-keyscan -H "${DEPLOY_HOST}" >> ~/.ssh/known_hosts

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts

tar -cf ./web.tar ./web

./.github/scripts/render_template.sh ./api/directus.env.tmpl > ./api/directus.env
./.github/scripts/render_template.sh ./api/postgresql.env.tmpl > ./api/postgresql.env

tar --exclude "*.tmpl" -cf ./api.tar ./api

scp ./web.tar ./api.tar ./.github/scripts/install.sh "${DEPLOY_SSH}":/tmp/

ssh "${DEPLOY_SSH}" "/bin/bash /tmp/install.sh"
