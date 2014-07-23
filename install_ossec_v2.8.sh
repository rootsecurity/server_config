#!/bin/bash

##########################################
##					 ##
##	$Name: install_ossec_v2.8.sh	 ##
##	$Time: 2014/06/19		 ##
##	$Version:0.1.8           	 ##
##      $Author:daiqy                    ##
##					 ##
##########################################

yum install -y expect
test -e /var/ossec && rm -rf /var/ossec
cd /usr/local/src/
wget http://www.ossec.net/files/ossec-hids-2.8.tar.gz
tar -zxf ossec-hids-2.8.tar.gz
cd ossec-hids-2.8/
expect -c "set timeout 100;spawn sh install.sh;expect \"en\";send \"en\r\";
expect \"ENTER\";send \"\r\";
expect \"1- What kind of installation do you want \(server, agent, local, hybrid or help\)?\";send \"agent\r\";
expect \"OSSEC HIDS\";send \"/var/ossec\r\";
expect \"OSSEC HIDS server?: \";send \"1.2.3.4\r\";
expect \"check daemon?\";send \"y\r\";
expect \"rootkit detection engine\";send \"y\r\";
expect \"active response\";send \"y\r\";
expect \"Press ENTER to continue\";send \"\r\";
expect \"Press ENTER to finish (maybe more information below)\";send \"\r\";
expect eof"
ip=`ip addr|grep inet|grep 10|awk -F "( |/)+" '{print $3}'`
echo "$ip finished"
