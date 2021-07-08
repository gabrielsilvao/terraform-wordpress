#!/bin/bash
sudo yum update -y
sudo yum install -y httpd httpd-tools python-simplejson default-jre
sudo systemctl enable httpd
sudo service httpd start

# Change privileges of execution
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Installing php
sudo yum install amazon-linux-extras -y
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y

# Download wordpress
cd
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
cd wordpress
sudo cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/wordpress/' wp-config.php
sudo sed -i 's/username_here/admin/' wp-config.php
sudo sed -i 's/password_here/Seletiva#39/' wp-config.php
sudo sed -i 's/localhost/${aws_db_instance.wordpress.endpoint}' wp-config.php

sudo cp -r wordpress/* /var/www/html/

# Create wordpress configuration file
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php