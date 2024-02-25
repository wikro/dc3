#!/bin/bash

cd /tmp
md5sum -c api.tar.md5 || exit 1

# Temp deploy dir
mkdir -p deploy

# Install API
tar -xf api.tar -C deploy/

rm -rf /opt/directus/*
rm -rf /opt/directus/.*
cp -R deploy/api/* /opt/directus/

chmod -R ug+rwX,o+rX /opt/directus

sudo docker compose --project-directory /opt/directus up -d && \
sudo docker system prune --all --force

# Clean up
rm -rf deploy/api api.tar api.tar.md5 api_install.sh
