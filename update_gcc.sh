#!/bin/bash
dv=1.1
devtoolset=`rpm -qa |grep devtoolset |wc -l`

if [ ! -f "/etc/yum.repos.d/devtools-${dv}.repo" ]; then
	wget http://people.centos.org/tru/devtools-1.1/devtools-1.1.repo -P /etc/yum.repos.d
	sh -c 'echo "enabled=1" >> /etc/yum.repos.d/devtools-1.1.repo'
fi

if [ $devtoolset == "0" ]; then
	yum -y install devtoolset-1.1
fi

scl enable devtoolset-1.1 bash
export CC=/opt/centos/devtoolset-1.1/root/usr/bin/gcc  
export CPP=/opt/centos/devtoolset-1.1/root/usr/bin/cpp
export CXX=/opt/centos/devtoolset-1.1/root/usr/bin/c++
