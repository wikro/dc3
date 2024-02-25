#!/bin/bash

cd /tmp
md5sum -c md5sums.txt || exit 1

# Temp deploy dir
mkdir -p deploy

# Install web
if [ -f web.tar ]; then
  tar -xf web.tar -C deploy/

  rm -rf /var/www/html/*
  rm -rf /var/www/html/.*
  cp -R deploy/web/* /var/www/html/

  chmod -R ug+rwX,o+rX /var/www/html
fi

# Install api
if [ -f api.tar ]; then
  tar -xf api.tar -C deploy/

  rm -rf /opt/directus/*
  rm -rf /opt/directus/.*
  cp -R deploy/api/* /opt/directus/

  chmod -R ug+rwX,o+rX /opt/directus

  sudo docker compose --project-directory /opt/directus up -d
fi

# Install pocketbase
if [ -f pb.tar ]; then
  tar -xf pb.tar -C deploy/

  rm -rf /opt/pocketbase/*
  rm -rf /opt/pocketbase/.*

  cp -R deploy/pb/* /opt/pocketbase/

  chmod -R ug+rwX,o+rX /opt/directus
  sudo systemctl restart pocketbase
fi

# Clean up
rm -rf web.tar api.tar pb.tar md5sums.txt deploy/ install.sh
