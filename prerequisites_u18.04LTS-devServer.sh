#!/bin/bash
	sudo apt-get update
	echo -e "******************* Installing Common properties *******************"
	sudo apt-get install -y build-essential
	sudo apt-get install -y software-properties-common
	sudo apt-get install -y dirmngr
	sudo apt-get install -y curl wget
	sudo apt-get install -y git-core
	sudo apt-get install -y libmysqlclient-dev
	sudo apt-get install -y libssl-dev libssl1.0-dev
	echo -e "********************************************************************"
	echo -e ""
	echo -e "******************* Installing Python Common properties & packages **"
	sudo apt-get install -y python-pip
	sudo apt-get install -y python3-pymysql
	sudo apt-get install -y python3.6-dev
	pip install --upgrade setuptools
	echo "Some Time MySQL-Python Shows ERROR So Don't Worry go Ahead ..........."
	pip install MySQL-python --no-use-wheel
	pip install ansible
	sudo apt-get install -y virtualenv
	echo -e "********************************************************************"
	echo -e ""
	echo -e "******************* Installing Web Server Packages *****************"
	echo -e "Installing Nginx :" && sudo apt-get install -y nginx
	echo -e "Installing Supervisor :" && sudo apt-get install -y supervisor
	echo -e "Installing Redis-Server :" && sudo apt-get install -y redis-server
	redis-server -v
	echo -e "Installing wkhtmltopdf:"
	sudo apt-get -y install libxrender1 libxext6 xfonts-75dpi xfonts-base
	wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
	sudo tar -xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /opt
	sudo ln -s /opt/wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
	sudo ln -s /opt/wkhtmltox/bin/wkhtmltoimage /usr/bin/wkhtmltoimage
	wkhtmltopdf -V
	echo -e ""
	echo -e ""
	echo -e "****************** Installing Nodejs and yarn **********************"
	echo -e "Installing Nodejs and npm:"
	curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
	sudo apt-get install -y nodejs
	node -v && npm -v
	echo -e "Installing Yarn:"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt-get update && sudo apt-get install yarn
	sudo apt install  gcc g++ make
	sudo npm install -y -g json
	echo -e "********************************************************************"
	echo -e ""
	echo -e "******************Installing  MySQL and DB Packages ****************"
	sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
	sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://archive.mariadb.org/mariadb-10.2.22/repo/ubuntu/ bionic main'
	sudo apt-get update
	sudo apt-get install -y mariadb-server-10.2 mariadb-client-10.2
	sudo wget https://raw.githubusercontent.com/shrikant9867/frappe-erpnext-manual-script/main/settings.cnf  -P /etc/mysql/conf.d/
	sudo service mysql restart
	echo -e "********************************************************************"
	echo "If Some Package is Missing to Install Please Refere ---> https://github.com/frappe/bench#easy-install -y "
	echo "Thank you .....!"
echo -e "Before Running ERPNext Installation Script Please Add Following Lines in my.cnf at /etc/mysql/my.cnf \n:"
echo "============================================================================================================\n"
echo -e "\n[mysqld] \n\ninnodb-file-format=barracuda \ninnodb-file-per-table=1 \ninnodb-large-prefix=1 \ncharacter-set-client-handshake = FALSE  \ncharacter-set-server = utf8mb4 \ncollation-server = utf8mb4_unicode_ci \n\n[mysql] \n\ndefault-character-set = utf8mb4 \n"
echo -e "============================================================================================================\n"
