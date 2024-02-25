#!/bin/bash

cd /tmp
md5sum -c web.tar.md5 || exit 1

# Temp deploy dir
mkdir -p deploy

# Install Web
tar -xf web.tar -C deploy/

rm -rf /var/www/html/*
rm -rf /var/www/html/.*
cp -R deploy/web/* /var/www/html/

chmod -R ug+rwX,o+rX /var/www/html

# Clean up
rm -rf deploy/web web.tar web.tar.md5 web_install.sh
