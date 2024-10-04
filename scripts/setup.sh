#!/bin/bash

rm -rf /var/www/html

cp -R /tmp/dist/html /var/www/html

chmod -R ug+rwX,o+rX /var/www/html

# Clean up
rm -rf /tmp/dist /tmp/dist.tar /tmp/dist.tar.md5
