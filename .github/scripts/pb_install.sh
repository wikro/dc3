#!/bin/bash

cd /tmp
md5sum -c pb.tar.md5 || exit 1

# Temp deploy dir
mkdir -p deploy

# Install PocketBase
tar -xf pb.tar -C deploy/

rm -rf /opt/pocketbase/*
rm -rf /opt/pocketbase/.*

cp -R deploy/pb/* /opt/pocketbase/

chmod -R ug+rwX,o+rX /opt/pocketbase
sudo systemctl reload pocketbase

# Clean up
rm -rf deploy/pb pb.tar pb.tar.md5 pb_install.sh
