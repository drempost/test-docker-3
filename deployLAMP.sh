#!/bin/bash

function install_ubuntu {
	apt-get update
	check_apache=$(command -v apache2 >/dev/null 2>&1 || echo "no")
	if [ "$check_apache" == "no" ]
	then
		apt-get install -y apache2
	fi

	check_php=$(command -v php >/dev/null 2>&1 || echo "no")
	if [ "$check_php" == "no" ]
	then
		apt-get install -y php
		touch info.php && echo "<?php phpinfo(); ?>" > info.php 
		mv info.php /var/www/html/
	fi

	check_mysql=$(command -v mysql >/dev/null 2>&1 || echo "no")
	if [ "$check_mysql" == "no" ]
	then
		echo "install mysql"
		debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
		debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
		apt-get install -y mysql-server
	fi
}
function check_installation_ubuntu {
	check_apache=$(command -v apache2 >/dev/null 2>&1 || echo "no")
	if [ "$check_apache" == "no" ]
	then
		echo "apache2 was not installed"
	fi

	check_php=$(command -v php >/dev/null 2>&1 || echo "no")
	if [ "$check_php" == "no" ]
	then
		echo "php was not installed"
	fi

	check_mysql=$(command -v mysql >/dev/null 2>&1 || echo "no")
	if [ "$check_mysql" == "no" ]
	then
		echo "mysql was not installed"
	fi
}
function install_centos {
	yum update -y 
	check_apache=$(command -v httpd >/dev/null 2>&1 || "no")
	if [ "$check_apache" == "no" ]
	then
		yum install -y httpd
		service httpd start
	fi

	check_php=$(command -v php >/dev/null 2>&1 || echo "no")
	if [ "$check_php" == "no" ]
	then 
		yum install -y php
		touch info.php && echo "<?php phpinfo(); ?>" > info.php
		mv info.php /var/www/html/
	fi

	check_mysql=$(command -v mysql >/dev/null 2>&1 || echo "no")
	if [ "$check_mysql" == "no" ]
	then
		yum install -y wget
		wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
		rpm -ivh mysql-community-release-el7-5.noarch.rpm
		yum update -y 
		yum install -y mysql-server
		service mysqld start
		rm mysql-community-release-el7-5.noarch.rpm
	fi
}
function check_installation_centos {
	check_apache=$(command -v httpd >/dev/null 2>&1 || echo "no")
	if [ "$check_apache" == "no" ]
	then
		echo "apache was not installed"
	fi

	check_php=$(command -v php >/dev/null 2>&1 || echo "no")
	if [ "$check_php" == "no" ]
	then 
		echo "php was not installed"
	fi

	check_mysql=$(command -v mysql >/dev/null 2>&1 || echo "no")
	if [ "$check_mysql" == "no" ]
	then
		echo "mysql was not installed"
	fi
}

check_system=$(cat /etc/*-release | sed -ne 's/.*=//;s/ .*//;1p')

if [ "$check_system" == "Ubuntu" ]
then 
	install_ubuntu
	check_installation_ubuntu
elif [ "$check_system" == "CentOS" ]
then
	install_centos
	check_installation_centos
fi
echo $check_system
