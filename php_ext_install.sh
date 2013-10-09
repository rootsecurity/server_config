#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export LANG="en_US.UTF-8"



##########################################
##					 ##
##	$Name: php_ext_install.sh	 ##
##	$Time: 2013/06/19		 ##
##	$Version:0.1.8           	 ##
##      $Author:rootsecurity             ##
##					 ##
##########################################

##########################################
##                                      ##
##          CHANGE-LOG                  ##
##                                      ##
##                                      ##
##  2013/03/20  Fix script error        ##
##  2012/12/20  Fix Bugs                ##
##  2012/06/03  Add install memcache    ##
##  2012/02/01  Create script           ##
##                                      ##
##########################################

# CHECK RUNNING USER
if [[ "$(whoami)" != "root" ]]; then
  echo "Please run this script as root." >&2
  exit 1
fi

# VERSION DEFINE
AVN="2.13"
PVN="8.12"
LVN="1.13.1"
LIVN="2.5.8"
MVN="0.9.9.9"
MCVN="2.6.8"
MEVN="2.2.6"
PDVN="1.0.2"

install_init()
{
	for packages in patch make gcc gcc-c++ flex bison file libtool libtool-libs autoconf gd gd-devel kernel-devel libjpeg \
	libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel \
	zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel \
	e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese \
	gettext gettext-devel ncurses-devel gmp-devel pspell-devel unzip libhtp libhtp-devel libpcap libpcap-devel
	do yum -y install $packages;
	done
}



install_autoconf()
{
	if [ ! -e "autoconf-${AVN}.tar.gz" ];then
		wget -c http://ftp.gnu.org/gnu/autoconf/autoconf-${AVN}.tar.gz
	fi

	if [ -s "autoconf-${AVN}.tar.gz" ];then
		echo "autoconf-${AVN}.tar.gz [Found]"
	else
		echo "autoconf-${AVN}.tar.gz [Not Found]"
		exit 1
	fi
	
	tar zxvf autoconf-${AVN}.tar.gz
	cd autoconf-${AVN}/
	./configure --prefix=/usr/local/autoconf-${AVN}
	make && make install
	ln -s /usr/local/autoconf-${AVN} /usr/local/autoconf
	cd ../
}
	
install_pcre()
{
	if [ ! -e "pcre-${PVN}.tar.gz" ];then
		wget -c http://downloads.sourceforge.net/project/pcre/pcre/${PVN}/pcre-${PVN}.tar.gz
	fi

	if [ -s "pcre-${PVN}.tar.gz" ];then
		echo "pcre-${PVN}.tar.gz [Found]"
	else
		echo "pcre-${PVN}.tar.gz [Not Found]"
		exit 1
	fi
	
	tar zxvf pcre-${PVN}.tar.gz
	cd pcre-${PVN}/
	./configure
	make && make install
	cd ../
}

install_libiconv()
{
	if [ ! -e "libiconv-${LVN}.tar.gz" ];then
		wget -c http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LVN}.tar.gz
	fi

	if [ -s "libiconv-${LVN}.tar.gz" ];then
		echo "libiconv-${LVN}.tar.gz [Found]"
	else
		echo "libiconv-${LVN}.tar.gz [Not Found]"
		exit 1
	fi

	tar zxvf libiconv-${LVN}.tar.gz
	cd libiconv-${LVN}/
	./configure
	make && make install
	cd ../
}

install_libmcrypt()
{
	if [ ! -e "libmcrypt-${LIVN}.tar.gz" ];then
		wget -c http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/${LIVN}/libmcrypt-${LIVN}.tar.gz
	fi

	if [ -s "libmcrypt-${LIVN}.tar.gz" ];then
		echo "libmcrypt-${LIVN}.tar.gz [Found]"
	else
		echo "Error:libmcrypt-${LIVN}.tar.gz [Not Found]"
		exit 1
	fi
	
	tar zxvf libmcrypt-${LIVN}.tar.gz
	cd libmcrypt-${LIVN}/
	./configure
	make && make install
	/sbin/ldconfig
	cd libltdl/
	./configure --enable-ltdl-install
	make && make install
	cd ../../
}

install_mhash()
{
	if [ ! -e "mhash-${MVN}.tar.gz" ];then
		wget -c http://downloads.sourceforge.net/project/mhash/mhash/${MVN}/mhash-${MVN}.tar.gz
	fi
	
	if [ -s "mhash-${MVN}.tar.gz" ];then
		echo "mhash-${MVN}.tar.gz [Found]"
	else
		echo "Error:mhash-${MVN}.tar.gz [Not Found]"
		exit 1
	fi
	
	tar zxvf mhash-${MVN}.tar.gz
	cd mhash-${MVN}/
	./configure
	make && make install
	cd ../

cat >/tmp/config.sh<<TMD1
ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
TMD1

cat > /tmp/config_x86_64.sh<<TMD2
ln -s /usr/local/lib/libmcrypt.la /usr/lib64/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib64/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib64/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib64/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib64/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib64/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib64/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib64/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib64/libmhash.so.2.0.1
TMD2

chmod +x /tmp/config.sh && chmod +x /tmp/config_x86_64.sh

if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
	ln -s /usr/lib/libpng.* /usr/lib64/
	ln -s /usr/lib/libjpeg.* /usr/lib64/
	/tmp/config_x86_64.sh
else 
	ln -s /usr/lib64/libpng.* /usr/lib/
	ln -s /usr/lib64/libjpeg.* /usr/lib/
	/tmp/config.sh
fi
}

install_mcrypt()
{
	if [ ! -e "mcrypt-${MCVN}.tar.gz" ];then
		wget -c http://downloads.sourceforge.net/project/mcrypt/MCrypt/${MCVN}/mcrypt-${MCVN}.tar.gz
	fi
	
	if [ -s "mcrypt-${MCVN}.tar.gz" ];then
		echo "mcrypt-${MCVN}.tar.gz[Found...]"
	else
		echo "Error:mcrypt-${MCVN}.tar.gz[Not Found...]"
		exit 1
	fi

	tar zxvf mcrypt-${MCVN}.tar.gz
	cd mcrypt-${MCVN}/
	./configure
	make && make install
	cd ../
}

install_memcache()
{
	if [ ! -e "memcache-${MEVN}.tgz" ];then
		wget -c http://pecl.php.net/get/memcache-${MEVN}.tgz
	fi
	
	if [ -s "memcache-${MEVN}.tgz" ];then
		echo "memcache-${MEVN}.tgz [Found]"
	else
		echo "Error:memcache-${MEVN}.tgz [Not Found]"
		exit 1
	fi
	
	tar zxvf memcache-${MEVN}.tgz
	cd memcache-${MEVN}/
	/usr/local/php/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config
	make && make install
	cd ../
}

install_pdo_mysql()
{
	if [ ! -e "PDO_MYSQL-${PDVN}.tgz" ];then
		wget -c http://pecl.php.net/get/PDO_MYSQL-${PDVN}.tgz
	fi
	
	if [ -s "PDO_MYSQL-${PDVN}.tgz" ];then
		echo "PDO_MYSQL-${PDVN}.tgz [Found]"
	else
		echo "Error:PDO_MYSQL-${PDVN}.tgz [Not Found]"
		exit 1
	fi
	
	tar zxvf PDO_MYSQL-${PDVN}.tgz
	cd PDO_MYSQL-${PDVN}/
	/usr/local/php/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config \
	--with-pdo-mysql=/usr/local/mysql
	make && make install
	cd ../
}

help_info()
{
	clear
	echo "--------------------------------------------------------help info---------------------------------------------------------"
	echo "																															"
        echo "  init:           init system software                                                                                        "
	echo "	autoconf:	autoconf is GNU environment project.                                                                        "
	echo "	libiconv:	This library can be used with LD_PRELOAD, to override the iconv*.                                           "	
	echo "	libmcrypt:	The companion to MCrypt is Libmcrypt.                                                                       "	
	echo "	mhash:		mhash is a free library which provides a uniform interface to a large number of hash algorithms.            "		
	echo "	mcrypt:		Mcrypt file encryption program for unix.                                                                    "
	echo "	autoconf:	Autoconf is an extensible shell scripts to automatically configure software source code packages.           "
	echo "	memcache:	memcached is a extension.                                                                                   "
	echo "	pdo_mysql:	pdo_mysql is a extension.                                                                                   "	
	echo "																															"
	echo "--------------------------------------------------------------------------------------------------------------------------"
}

case $1 in
	init)
		install_init
		;;
	autoconf)
		install_autoconf
		;;
	libiconv)
		install_libiconv
		;;
	libmcrypt)
		install_libmcrypt
		;;
	mhash)
		install_mhash
		;;
	mcrypt)
		install_mcrypt
		;;
	autoconf)
		install_autoconf
		;;
	memcache)
		install_memcache
		;;
	pcre)
		install_pcre
		;;
	pdo_mysql)
		install_pdo_mysql
		;;
	--help|-h|-help)
		help_info
		;;
	*)
		echo "Usage: $0 {init|autoconf|libiconv|libmcrypt|mhash|mcrypt|pcre|memcache|pdo_mysql}"
		exit 1
		;;
esac
