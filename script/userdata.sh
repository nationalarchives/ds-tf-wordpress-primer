#!/bin/bash

# Update yum
sudo yum update -y

# Install apache
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd
sudo systemctl start httpd

# Install php 7.4
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear -y
sudo yum install php-{cli,cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip,simplexml,gd} -y

# Install mysql5.7
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install mysql-community-server -y
sudo systemctl enable mysqld
sudo systemctl start mysqld

# Install ImageMagick
sudo yum -y install php-devel gcc ImageMagick ImageMagick-devel
sudo bash -c "yes '' | pecl install -f imagick"
sudo bash -c "echo 'extension=imagick.so' > /etc/php.d/imagick.ini"

sudo systemctl restart php-fpm.service
sudo systemctl restart httpd.service

# Install NFS packages
sudo yum install -y amazon-efs-utils
sudo yum install -y nfs-utils
sudo service nfs start
sudo service nfs status

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1s

# Install WP CLI
mkdir /build
cd /build
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp cli info
cd /

cd /var/www/html
echo "<html><head><title>Health Check</title></head><body><h1>Hello world!</h1></body></html>" >> healthcheck.html
echo "apache_modules:
  - mod_rewrite" >> wp-cli.yml
if [[ "${environment}" == "live" ]]; then
    echo $"User-agent: *
Disallow: /wp-admin/
Allow: /wp-admin/admin-ajax.php" >> robots.txt
else
    echo $"User-agent: *
Disallow: /" >> robots.txt
    echo "<?php phpinfo() ?>" >> phpinfo.php
fi

wp core download --allow-root

sudo chown apache:apache /var/www -R
find /var/www -type d -exec chmod 775 {} \;
find /var/www -type f -exec chmod 664 {} \;
