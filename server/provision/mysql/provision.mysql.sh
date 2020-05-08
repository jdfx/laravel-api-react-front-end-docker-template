#!/usr/bin/env bash

mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' WITH GRANT OPTION;"
mysql -u root -e "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '';" #// disable caching_sha2_password for MySQL 8.0 as Laravel doesn't support this. (password is blank anyway, but might change..)
mysql -u root -e "FLUSH PRIVILEGES;" #// flush privilege cache
mysql -u root -e "CREATE DATABASE IF NOT EXISTS laravel_api;"