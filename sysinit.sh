#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export LANG=en_US.UTF-8
arch=`uname -m`
ipaddr=`ifconfig eth0 | grep "inet addr" | awk '{print $2}'|grep -v "127.0.0.1"|tr -d "addr:"|awk '{print $1}'`

#------------------check start-------------------------#
if [ ! /etc/yum.repos.d/run.lock ]; then
        echo "***the init script has been first running!***"
else
        echo "***the run.lock has been exists,the process will exit***"
        exit 0
fi
#--------------------check end-------------------------#

#------------------安装epel for rhel6------------------#
if [ -s /etc/issue ] && grep 'CentOS release 6.*' /etc/issue; then
	wget http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm -ivh epel-release-6-8.noarch.rpm
	rm -f epel-release-6-8.noarch.rpm
	echo 'install ipv6 /bin/true' > /etc/modprobe.d/disable-ipv6.conf
	echo 'IPV6INIT=no' >> /etc/sysconfig/network
	rpm --import http://mirrors.ustc.edu.cn/fedora/epel/RPM-GPG-KEY-EPEL-6
	echo `date  +"%Y-%m-%d %H:%S:%M"` > /etc/yum.repos.d/run.lock
fi
#------------------------------------------------------#

#-----------------安装epel for rhel5-------------------#
if [ -s /etc/issue ] && grep 'CentOS release 5.*' /etc/issue; then
	wget http://mirrors.ustc.edu.cn/fedora/epel/5/x86_64/epel-release-5-4.noarch.rpm
	rpm -ivh epel-release-5-4.noarch.rpm
	rm -f epel-release-5-4.noarch.rpm
	rpm --import http://mirrors.ustc.edu.cn/fedora/epel/RPM-GPG-KEY-EPEL-5
	echo `date  +"%Y-%m-%d %H:%S:%M"` > /etc/yum.repos.d/run.lock
fi
#------------------------------------------------------#

#------------------------mongodb-----------------------#
#if [ ! -f "/etc/yum.repos.d/mongo.repo" ]; then
#cat > /etc/yum.repos.d/mongo.repo<<mon
#[mongodb]
#name=MongoDB Repository
#baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/${arch}/
#gpgcheck=0
#enabled=1
#mon
#fi
#else
#echo "mongo.repo already exists!"
#------------------------------------------------------#

#------------------------ntop--------------------------#
#if [ ! -f "/etc/yum.repos.d/ntop.repo" ]; then
#cat > /etc/yum.repos.d/ntop.repo <<ntop
#[ntop]
#name=ntop packages
#baseurl=http://www.nmon.net/centos/$releasever/$basearch/
#enabled=1
#gpgcheck=1
#gpgkey=http://www.nmon.net/centos/RPM-GPG-KEY-deri
#[ntop-noarch]
#name=ntop packages
#baseurl=http://www.nmon.net/centos/$releasever/noarch/
#enabled=1
#gpgcheck=1
#gpgkey=http://www.nmon.net/centos/RPM-GPG-KEY-deri
#ntop
#fi
#else
#echo "ntop.repo already exists!"
#-------------------------------------------------------#

#----------------update Yum sources--------------------#
yum -y clean all && yum -y makecache
#------------------------------------------------------#

yum -y install gcc gcc-c++ kernel kernel* make libedit pcre pcre-devel magic flex libtool* gperftools-libs bzip2-devel iptraf pptp-setup python-devel python-setuptools libxml2 libxml2-devel gettext gettext-devel ncurses-devel file file-devel libyaml libyaml-devel libhtp libhtp-devel gd gd-devel freetype freetype-devel openssl openssl-devel libcurl libcurl-devel libpcap libpcap-devel lrzsz gd gd-devel libcurl libcurl-devel freetype freetype-devel tcl tcl-devel perl-Time-HiRes
yum -y remove postfix
yum -y remove httpd
yum -y remove mysql-libs
yum -y install sysstat sendmail cronie crontabs cronie-anacron
yum -y install mongodb mongodb-server
yum -y install redis

#-----------------优化limits.conf----------------------#
echo '*       soft    nproc   2047'	>> /etc/security/limits.conf
echo '*       hard    nproc   16384' 	>> /etc/security/limits.conf
echo '*       soft    nofile  32767'    >> /etc/security/limits.conf
echo '*       hard    nofile  65536'    >> /etc/security/limits.conf
#------------------------------------------------------#

#-------------------PS1--------------------------------#
[ -z "`cat ~/.bashrc | grep ^PS1`" ] && echo 'PPS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ \[\e[33;40m\]"' >> ~/.bashrc
#------------------------------------------------------#

#------------------alias vi----------------------------#
[ -z "`cat ~/.bashrc | grep 'alias vi='`" ] && sed -i "s@alias mv=\(.*\)@alias mv=\1\nalias vi=vim@" ~/.bashrc && echo 'syntax on' >> /etc/vimrc
#------------------------------------------------------#

#----------if login 5time+ wrong locked 180s-----------#
[ -z "`cat /etc/pam.d/system-auth | grep 'pam_tally2.so'`" ] && sed -i '4a auth        required      pam_tally2.so deny=5  unlock_time=180' /etc/pam.d/system-auth
#------------------------------------------------------#

#-----------cut history log-----------------------------#
export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });user=$(whoami); echo $(date "+%Y-%m-%d %H:%M:%S"):$user:`pwd`/:$msg ---- $(who am i); } >> /tmp/`hostname`.`whoami`.history-timestamp'
#-------------------------------------------------------#

#sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongodb.conf
#sed -i 's/27017/37107/g' /etc/mongodb.conf
sed -i 's/exec \/sbin\/shutdown -r now "Control-Alt-Delete pressed"/#exec \/sbin\/shutdown -r now "Control-Alt-Delete pressed"/g' /etc/init/control-alt-delete.conf
sed -i 's/net.bridge.bridge-nf-call-ip6tables = 0/#net.bridge.bridge-nf-call-ip6tables = 0/g' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call-iptables = 0/#net.bridge.bridge-nf-call-iptables = 0/g' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call-arptables = 0/#net.bridge.bridge-nf-call-arptables = 0/g' /etc/sysctl.conf

sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 6/' /etc/ssh/sshd_config
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
echo 'net.ipv4.tcp_syncookies=1' >> /etc/sysctl.conf
#echo 'export HISTTIMEFORMAT="[ `whoami` %F %T "]' >> /etc/profile

#--------去掉wget英国中部时间-----#
msgunfmt /usr/share/locale/zh_CN/LC_MESSAGES/wget.mo -o - | sed 's/eta(英国中部时间)/ETA/' | msgfmt - -o /tmp/zh_CN.mo
cp -f /tmp/zh_CN.mo /usr/share/locale/zh_CN/LC_MESSAGES/wget.mo
#--------------------------------#

sed -i 's/#GSSAPIAuthentication no/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/GSSAPIAuthentication yes/#GSSAPIAuthentication yes/g' /etc/ssh/sshd_config

#----------优化sysctl-----------#
cat >> /etc/sysctl.conf <<SYSCTL
net.core.somaxconn = 32768
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 0
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.ip_local_port_range = 1024  65535
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 100
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 20000
net.ipv4.ip_default_ttl = 255
SYSCTL

#----------用户---------------#
#for i in `cat /etc/passwd | sort |awk -F ":" '{print $1}'`
#do
#case $i in
#lp |news |sync |uucp |games |operator)
#userdel $i
#groupdel $i
#;;
#esac
#done

#for p in `cat /etc/passwd | sort |awk -F ":" '{print $1}'`
#do
#case $p in 
#www |mysql)
#groupadd $p
#useradd -g $p $p
#;;
#esac
#done
#-----------------------------------------#

#---------------初始化文件夹--------------#
#ln -s /data /export
#if [ -d "/data" ]; then
#	/bin/ln -s /data /export
#else
#	/bin/mkdir -p /export
#	
#fi

#cd /export && mkdir -p {App,Config,Log,MySQLData,MongoData,RedisData,Shell,Server,Service}
#cd /export/Log && mkdir -p {nginx,mysql,debug,php-fpm}
#chown -R mysql.mysql mysql
#chown -R www.www nginx php-fpm
#-----------------------------------------#

/etc/init.d/sshd restart

#-------------优化系统服务----------------#
chkconfig --level 2345 ip6tables off
chkconfig --level 2345 iptables off
chkconfig --level 2345 cups off
chkconfig --level 2345 rpcbind off
chkconfig --level 2345 rpcgssd off
chkconfig --level 2345 rpcidmapd off
chkconfig --level 2345 rpcsvcgssd off
sleep 2
echo "done!"
#-----------------------------------------#

ntp=`rpm -qa |grep ntp-4.2 |wc -l`
if [ $ntp == "0" ]; then
        yum -y install ntp
else
        yum -y remove ntp
        yum -y install ntp
fi
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cat > /etc/sysconfig/clock <<DATE
ZONE="Asia/Shanghai"
UTC=false
ARC=false
DATE
#chkconfig --level 345 ntpd on
#/etc/init.d/ntpd start
ntpdate cn.pool.ntp.org > /dev/null 2>&1
