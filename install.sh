#!/bin/bash

# start with a full upgrade
sudo apt-get dist-upgrade 
sudo apt-get install mariadb-client-core-5.5 nginx php5-fpm php5-mysql php5-cli git
sudo sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini

# let's eat the default site
sudo rm /etc/nginx/sites-enabled/default

# in case you want to run the scraper
sudo apt-get install php5-curl php5-mcrypt php5-gmp
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

sudo service nginx restart
sudo service php5-fpm restart

apt-cache show letsencrypt
HAVE_LE=$?
if [$HAVE_LE -gt 0] then
  sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
  sudo ln -s /usr/local/bin/letsencrypt /opt/letsencrypt/letsencrypt-auto
  letsencrypt
else
  sudo apt-get install letsencrypt
fi

sudo cp share /usr/ -Rf
sudo cp local /usr/ -Rf