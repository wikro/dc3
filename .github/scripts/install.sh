#!/bin/bash

# Temp deploy dir
mkdir -p /tmp/deploy

# Install web
tar -xf /tmp/web.tar -C /tmp/deploy

rm -rf /var/www/html/*
rm -rf /var/www/html/.*
cp -R /tmp/deploy/web/* /var/www/html/

chmod -R ug+rwX,o+rX /var/www/html/*

# Install api
tar -xf /tmp/api.tar -C /tmp/deploy

rm -rf /opt/directus/*
rm -rf /opt/directus/.*
cp -R /tmp/deploy/api/* /opt/directus/

chmod -R ug+rwX,o+rX /opt/directus/*

cd /opt/directus
sudo docker compose up -d

# Clean up
rm -rf /tmp/web.tar /tmp/api.tar /tmp/deploy/ /tmp/install.sh
