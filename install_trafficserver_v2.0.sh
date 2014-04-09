#!/bin/bash
# 
# install_trafficserver_v2.0.sh
# Author:@rootsecurity
# Date:2013-09
# Usage:install_trafficserver_v2.0.sh (init|install|uninstall)

TVER="4.2.0"

function_init() {
	for ats_packages in tcl tcl-devel pcre pcre-devel flex bison bison-devel expat-devel libcap-devel gcc-c++ lzma make file file-devel;
	do
	yum -y install $ats_packages;
	done
}

function_install() {
	wget -c http://mirror.bit.edu.cn/apache/trafficserver/trafficserver-${TVER}.tar.bz2
	
	tar jxvf trafficserver-${TVER}.tar.bz2
	cd trafficserver-${TVER}/
	./configure --prefix=/usr/local/trafficserver-${TVER} --enable-static \
	--enable-tproxy=force \
	--enable-posix-cap \
	--enable-shared \
	--enable-wccp \
	--with-zlib \
	--with-pcre
	make && make install
	cd ../
}

function_uninstall() {
	/usr/local/trafficserver-${TVER}/bin/trafficserver stop
	rm -rf /usr/local/trafficserver-${TVER}
}

case $1 in 
   init)
	function_init
	;;
   install)
	function_install
	;;
   uninstall)
	function_uninstall
	;;
   *)
	echo "Usage:$0 {init|install|uninstall}"
	exit 1
esac
