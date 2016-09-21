#!/bin/bash
DIRECTORY=/var/lib/php
DIRSESSION=/var/lib/php/session

chown -R web-user:web-user /var/www/api
if [ ! -d "$DIRECTORY" ] || [ ! -d "DIRSESSION" ] ; then
mkdir -p /var/lib/php/session
chown -R web-user:web-user /var/lib/php
fi
php-fpm

