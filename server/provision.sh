#!/usr/bin/env bash

# Laravel homestead original provisioning script
# https://github.com/laravel/settler

# Update Package List
apt-get update
apt-get upgrade -y

# Force Locale
apt-get install -y locales
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# Install ssh server
apt-get -y install openssh-server pwgen
mkdir -p /var/run/sshd
sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

# Basic packages
apt-get install -y sudo software-properties-common nano curl \
build-essential dos2unix gcc git git-flow libpcre3-dev apt-utils \
make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim zip unzip

# PPA
apt-add-repository ppa:ondrej/php -y

# Update Package Lists
apt-get update

# Create homestead user
adduser homestead
usermod -p $(echo secret | openssl passwd -1 -stdin) homestead
# Add homestead to the sudo group and www-data
usermod -aG sudo homestead
usermod -aG www-data homestead

# Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# PHP
apt-get install -y php7.3-cli php7.3-dev \
php7.3-mysql php7.3-pgsql php7.3-sqlite3 php7.3-soap \
php7.3-json php7.3-curl php7.3-gd \
php7.3-gmp php7.3-imap php-xdebug \
php7.3-mbstring php7.3-zip \
php-pear php-apcu php-memcached php-redis \
php7.3-dom php7.3-bcmath

# Nginx & PHP-FPM
apt-get install -y nginx php7.3-fpm

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path
printf "\nPATH=\"/home/homestead/.composer/vendor/bin:\$PATH\"\n" | tee -a /home/homestead/.profile

# Laravel Envoy
su homestead <<'EOF'
/usr/local/bin/composer global require "laravel/envoy=~1.5.0"
EOF

# Set Some PHP CLI Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.3/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.3/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/cli/php.ini

sed -i "s/.*daemonize.*/daemonize = no/" /etc/php/7.3/fpm/php-fpm.conf
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.3/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.3/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.3/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/fpm/php.ini

# Enable Remote xdebug
echo "xdebug.remote_enable = 1" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini
echo "xdebug.var_display_max_depth = -1" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini
echo "xdebug.var_display_max_children = -1" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini
echo "xdebug.var_display_max_data = -1" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini
echo "xdebug.max_nesting_level = 500" >> /etc/php/7.3/fpm/conf.d/20-xdebug.ini

# Not xdebug when on cli
phpdismod -s cli xdebug

# Set The Nginx & PHP-FPM User
sed -i '1 idaemon off;' /etc/nginx/nginx.conf
sed -i "s/user www-data;/user homestead;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

mkdir -p /run/php
touch /run/php/php7.3-fpm.sock
sed -i "s/user = www-data/user = homestead/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = homestead/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/;listen\.owner.*/listen.owner = homestead/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/;listen\.group.*/listen.group = homestead/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.3/fpm/pool.d/www.conf

# Install SQLite
apt-get install -y sqlite3 libsqlite3-dev

# Beanstalkd
apt-get install -y beanstalkd
sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd

# Redis
apt-get install -y redis-server
sed -i "s/daemonize yes/daemonize no/" /etc/redis/redis.conf
