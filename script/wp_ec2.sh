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

# Download TNA themes
curl -H "Authorization: token ${github_token}" -L https://github.com/nationalarchives/tna/archive/master.zip > /home/ec2-user/themes/tna.zip
curl https://github.com/nationalarchives/tna-base/archive/master.zip > /home/ec2-user/themes/tna-base.zip
curl https://github.com/nationalarchives/tna-child-blog/archive/master.zip > /home/ec2-user/themes/tna-child-blog.zip
curl https://github.com/nationalarchives/tna-child-about-us-foi/archive/master.zip > /home/ec2-user/themes/tna-child-about-us-foi.zip
curl https://github.com/nationalarchives/tna-child-pressroom/archive/master.zip > /home/ec2-user/themes/tna-child-pressroom.zip
curl https://github.com/nationalarchives/tna-child-home/archive/master.zip > /home/ec2-user/themes/tna-child-home.zip
curl https://github.com/nationalarchives/tna-child-contact/archive/develop.zip > /home/ec2-user/themes/tna-child-contact.zip
curl https://github.com/nationalarchives/ds-wp-child-education/archive/master.zip > /home/ec2-user/themes/ds-wp-child-education.zip
curl https://github.com/nationalarchives/tna-child-legal/archive/master.zip > /home/ec2-user/themes/tna-child-legal.zip
curl https://github.com/nationalarchives/tna-child-labs/archive/master.zip > /home/ec2-user/themes/tna-child-labs.zip
curl https://github.com/nationalarchives/tna-child-suffrage/archive/master.zip > /home/ec2-user/themes/tna-child-suffrage.zip
curl https://github.com/nationalarchives/tna-child-ourrole/archive/master.zip > /home/ec2-user/themes/tna-child-ourrole.zip
curl https://github.com/nationalarchives/great-wharton-theme/archive/master.zip > /home/ec2-user/themes/great-wharton-theme.zip
curl https://github.com/nationalarchives/tna-child-latin/archive/master.zip > /home/ec2-user/themes/tna-child-latin.zip
curl https://github.com/nationalarchives/tna-child-commercial-opportunities/archive/master.zip > /home/ec2-user/themes/tna-child-commercial-opportunities.zip
curl https://github.com/nationalarchives/tna-child-black-history/archive/master.zip > /home/ec2-user/themes/tna-child-black-history.zip
curl https://github.com/nationalarchives/tna-child-design-guide/archive/master.zip > /home/ec2-user/themes/tna-child-design-guide.zip
curl https://github.com/nationalarchives/tna-child-help-legal/archive/master.zip > /home/ec2-user/themes/tna-child-help-legal.zip
curl https://github.com/nationalarchives/tna-child-get-involved/archive/master.zip > /home/ec2-user/themes/tna-child-get-involved.zip
curl https://github.com/nationalarchives/tna-child-web-archive/archive/master.zip > /home/ec2-user/themes/tna-child-web-archive.zip
curl https://github.com/nationalarchives/tna-child-domesday/archive/master.zip > /home/ec2-user/themes/tna-child-domesday.zip
curl https://github.com/nationalarchives/tna-child-about-us-research/archive/master.zip > /home/ec2-user/themes/tna-child-about-us-research.zip
curl https://github.com/nationalarchives/ds-wp-child-about-us/archive/master.zip > /home/ec2-user/themes/ds-wp-child-about-us.zip
curl https://github.com/nationalarchives/tna-child-re-using-psi/archive/master.zip > /home/ec2-user/themes/tna-child-re-using-psi.zip
curl https://github.com/nationalarchives/tna-child-archives-inspire/archive/master.zip > /home/ec2-user/themes/tna-child-archives-inspire.zip
curl https://github.com/nationalarchives/tna-child-about-us-jobs/archive/master.zip > /home/ec2-user/themes/tna-child-about-us-jobs.zip
curl https://github.com/nationalarchives/ds-wp-child-information-management/archive/master.zip > /home/ec2-user/themes/ds-wp-child-information-management.zip
curl https://github.com/nationalarchives/tna-child-first-world-war/archive/master.zip > /home/ec2-user/themes/tna-child-first-world-war.zip
curl https://github.com/nationalarchives/tna-child-cabinet-papers-100/archive/master.zip > /home/ec2-user/themes/tna-child-cabinet-papers-100.zip
curl https://github.com/nationalarchives/tna-base-child-stories-resource/archive/master.zip > /home/ec2-user/themes/tna-base-child-stories-resource.zip
curl https://github.com/nationalarchives/tna-child-about-us-commercial/archive/master.zip > /home/ec2-user/themes/tna-child-about-us-commercial.zip
curl https://github.com/nationalarchives/ds-wp-child-help-with-your-research/archive/master.zip > /home/ec2-user/themes/ds-wp-child-help-with-your-research.zip
curl https://github.com/nationalarchives/tna-currency-converter/archive/master.zip > /home/ec2-user/themes/tna-currency-converter.zip
curl https://github.com/nationalarchives/tna-long-form-template-BT/archive/master.zip > /home/ec2-user/themes/tna-long-form-template-BT.zip
curl https://github.com/nationalarchives/tna-research-redesign/archive/master.zip > /home/ec2-user/themes/tna-research-redesign.zip
curl https://github.com/nationalarchives/tna-child-archives-sector/archive/master.zip > /home/ec2-user/themes/tna-child-archives-sector.zip
curl https://cdn.nationalarchives.gov.uk/wp-plugins/acf-flexible-content.zip > /home/ec2-user/themes/acf-flexible-content.zip
curl https://cdn.nationalarchives.gov.uk/wp-plugins/acf-options-page.zip > /home/ec2-user/themes/acf-options-page.zip
curl https://cdn.nationalarchives.gov.uk/wp-plugins/acf-repeater.zip > /home/ec2-user/themes/acf-repeater.zip
curl https://cdn.nationalarchives.gov.uk/wp-plugins/advanced-custom-fields-code-area-field.zip > /home/ec2-user/themes/advanced-custom-fields-code-area-field.zip
curl https://cdn.nationalarchives.gov.uk/wp-plugins/post-tags-and-categories-for-pages.zip > /home/ec2-user/themes/post-tags-and-categories-for-pages.zip
curl https://cdn.nationalarchives.gov.uk/wp-plugins/wds-active-plugin-data.zip > /home/ec2-user/themes/wds-active-plugin-data.zip
curl https://github.com/wp-sync-db/wp-sync-db/archive/master.zip > /home/ec2-user/themes/wp-sync-db.zip
curl https://github.com/nationalarchives/tna-editorial-review/archive/master.zip > /home/ec2-user/themes/tna-editorial-review.zip
curl https://github.com/nationalarchives/tna-wp-aws/archive/master.zip > /home/ec2-user/themes/tna-wp-aws.zip
curl https://github.com/nationalarchives/tna-password-message/archive/master.zip > /home/ec2-user/themes/tna-password-message.zip
curl https://github.com/nationalarchives/tna-profile-page/archive/master.zip > /home/ec2-user/themes/tna-profile-page.zip
curl https://github.com/nationalarchives/tna-eventbrite-api/archive/master.zip > /home/ec2-user/themes/tna-eventbrite-api.zip
curl https://github.com/nationalarchives/tna-forms/archive/master.zip > /home/ec2-user/themes/tna-forms.zip
curl https://github.com/nationalarchives/tna-newsletter/archive/master.zip > /home/ec2-user/themes/tna-newsletter.zip
