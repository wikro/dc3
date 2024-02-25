#!/bin/bash

md5sum -c md5sums.txt || exit 1

# Temp deploy dir
mkdir -p /tmp/deploy

# Install web
if [ -f /tmp/web.tar ]; then
  tar -xf /tmp/web.tar -C /tmp/deploy

  rm -rf /var/www/html/*
  rm -rf /var/www/html/.*
  cp -R /tmp/deploy/web/* /var/www/html/

  chmod -R ug+rwX,o+rX /var/www/html
fi

# Install api
if [ -f /tmp/api.tar ]; then
  tar -xf /tmp/api.tar -C /tmp/deploy

  rm -rf /opt/directus/*
  rm -rf /opt/directus/.*
  cp -R /tmp/deploy/api/* /opt/directus/

  chmod -R ug+rwX,o+rX /opt/directus

  cd /opt/directus
  sudo docker compose up -d
fi

# Install pocketbase
if [ -f /tmp/pb.tar ]; then
  tar -xf /tmp/pb.tar -C /tmp/deploy

  rm -rf /opt/pocketbase/*
  rm -rf /opt/pocketbase/.*

  cp -R /tmp/deploy/pocketbase/* /opt/pocketbase/

  chmod -R ug+rwX,o+rX /opt/directus
  sudo systemctl restart pocketbase
fi

# Clean up
rm -rf /tmp/web.tar /tmp/api.tar /tmp/pb.tar /tmp/deploy/ /tmp/install.sh
