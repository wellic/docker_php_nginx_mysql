#!/bin/bash

#set -x
set -v

chown -R web-user:web-user /var/www/api
cd /var/www/api

#sudo -u web-user ./bin/commands/update_cache
sudo -u web-user /usr/local/bin/composer self-update
sudo -u web-user /usr/local/bin/composer install

MAX_CNT=90
TIME_SLEEP=1
CNT=0
MYSQL_OK=0
while [ $CNT -le $MAX_CNT ]
do
    if mysql -hdevotion_mysql -uroot -pcpcs -e 'show databases;' | grep -qP '\bmysql\b' ; then 
      echo -e '\n* Mysql ready !!!'
      MYSQL_OK=1
      break
    fi
    sleep $TIME_SLEEP
    CNT=$(( $CNT + 1 ))
done

[ -z $MYSQL_OK ] && exit 1

mysql -hdevotion_mysql -pcpcs -uroot -e "show databases;" | grep -qv devotion && \
  sudo -u web-user app/console --no-interaction doctrine:database:create

sudo -u web-user app/console --no-interaction doctrine:migrations:migrate
sudo -u web-user app/console --no-interaction doctrine:fixtures:load
#php-fpm
