#!/bin/bash

# Update yum
sudo yum update -y

# Install LAMP Web Server on Amazon Linux 2
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd

# Install additional PHP repos
sudo yum install -y php-simplexml
sudo yum install -y php72-gd
sudo yum install -y php-pecl-imagick

sudo systemctl restart php-fpm.service
sudo systemctl restart httpd.service
sudo systemctl enable httpd

# Install NFS packages
sudo apt install -y nfs-common

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

sudo chown apache:apache /var/www -R
find /var/www -type d -exec chmod 775 {} \;
find /var/www -type f -exec chmod 664 {} \;

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

# Download TNA theme
curl -H "Authorization: token ${github_token}" -L https://github.com/nationalarchives/tna/archive/master.zip > /build/master.zip

wp core download --allow-root

echo "<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'user');
define('DB_PASSWORD', 'password');
define('DB_HOST', 'mysql');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY',         '3bba11cd2ed10d24a0d505ee57edc58c6366af69');
define('SECURE_AUTH_KEY',  'ab4c1842e0ab8654d829188fe7f2cd279a012b37');
define('LOGGED_IN_KEY',    '356e6522c933f191d574d26862a32ef5acec0b51');
define('NONCE_KEY',        '1755d990a468794358f60c70c1903681a8e7087b');
define('AUTH_SALT',        '68e31d7241b5f9c818504f7c38dbb316bc319d52');
define('SECURE_AUTH_SALT', '4ae5209b77d50c4a4fa3cc1f1fcf4de48df5a2fd');
define('LOGGED_IN_SALT',   '96fdee9ea54c4c1ba009bf7e1b68f4e83581dbc2');
define('NONCE_SALT',       'b89f0539aaab47f3322205dcf04e5f594fc022b8');
require_once(ABSPATH . 'wp-settings.php');" >> wp-config.php

# Install themes and plugins
wp theme install /build/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-base/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-blog/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-about-us-foi/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-pressroom/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-home/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-contact/archive/develop.zip --force --allow-root
wp theme install https://github.com/nationalarchives/ds-wp-child-education/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-legal/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-labs/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-suffrage/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-ourrole/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/great-wharton-theme/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-latin/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-commercial-opportunities/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-black-history/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-design-guide/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-help-legal/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-get-involved/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-web-archive/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-domesday/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-about-us-research/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/ds-wp-child-about-us/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-re-using-psi/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-archives-inspire/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-about-us-jobs/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/ds-wp-child-information-management/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-first-world-war/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-cabinet-papers-100/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-base-child-stories-resource/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-about-us-commercial/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/ds-wp-child-help-with-your-research/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-currency-converter/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-long-form-template-BT/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-research-redesign/archive/master.zip --force --allow-root
wp theme install https://github.com/nationalarchives/tna-child-archives-sector/archive/master.zip --force --allow-root
wp plugin install amazon-s3-and-cloudfront --force --allow-root
wp plugin install co-authors-plus --force --allow-root
wp plugin install wordpress-seo --force --allow-root
wp plugin install wp-mail-smtp --force --allow-root
wp plugin install jquery-colorbox --force --allow-root
wp plugin install simple-footnotes --force --allow-root
wp plugin install advanced-custom-fields --force --allow-root
wp plugin install classic-editor --force --allow-root
wp plugin install cms-tree-page-view --force --allow-root
wp plugin install tablepress --force --allow-root
wp plugin install tinymce-advanced --force --allow-root
wp plugin install transients-manager --force --allow-root
wp plugin install wordpress-importer --force --allow-root
wp plugin install wp-smtp --force --allow-root
wp plugin install wp-super-cache --force --allow-root
wp plugin install https://cdn.nationalarchives.gov.uk/wp-plugins/acf-flexible-content.zip --force --allow-root
wp plugin install https://cdn.nationalarchives.gov.uk/wp-plugins/acf-options-page.zip --force --allow-root
wp plugin install https://cdn.nationalarchives.gov.uk/wp-plugins/acf-repeater.zip --force --allow-root
wp plugin install https://cdn.nationalarchives.gov.uk/wp-plugins/advanced-custom-fields-code-area-field.zip --force --allow-root
wp plugin install https://cdn.nationalarchives.gov.uk/wp-plugins/post-tags-and-categories-for-pages.zip --force --allow-root
wp plugin install https://cdn.nationalarchives.gov.uk/wp-plugins/wds-active-plugin-data.zip --force --allow-root
wp plugin install https://github.com/wp-sync-db/wp-sync-db/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-editorial-review/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-wp-aws/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-password-message/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-profile-page/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-eventbrite-api/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-forms/archive/master.zip --force --allow-root
wp plugin install https://github.com/nationalarchives/tna-newsletter/archive/master.zip --force --allow-root

# Set file permissions uploads directory
sudo chown -R apache /var/www/html/wp-content/uploads/
sudo chgrp -R apache /var/www/html/wp-content/uploads/
sudo chmod 2775 /var/www/html/wp-content/uploads/
find /var/www/html/wp-content/uploads/ -type d -exec sudo chmod 2775 {} \;
find /var/www/html/wp-content/uploads/ -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
