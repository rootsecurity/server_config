#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export LANG=en_US.UTF-8
ipaddr=`ifconfig eth0 | grep "inet addr" | awk '{print $2}'|grep -v "127.0.0.1"|tr -d "addr:"|awk '{print $1}'`
#rpm --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6


#------------------安装epel for rhel6------------------#
if [ -s /etc/issue ] && grep 'CentOS release 6.*' /etc/issue; then
	wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm -ivh epel-release-6-8.noarch.rpm
	rm -f epel-release-6-8.noarch.rpm
fi
#------------------------------------------------------#


#-----------------安装epel for rhel5-------------------#
if [ -s /etc/issue ] && grep 'CentOS release 5.*' /etc/issue; then
	wget http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
	rpm -ivh epel-release-5-4.noarch.rpm
	rm -f epel-release-5-4.noarch.rpm
fi
#------------------------------------------------------#


yum -y install gcc gcc-c++ make pcre pcre-devel magic pptp-setup python-devel python-setuptools libxml2 libxml2-devel ncurses-devel file-devel libyaml libyaml-devel libhtp libhtp-devel gd gd-devel freetype freetype-devel openssl openssl-devel libcurl libcurl-devel libpcap libpcap-devel lrzsz gd gd-devel libcurl libcurl-devel freetype freetype-devel tcl tcl-devel perl-Time-HiRes
yum -y remove postfix
yum -y remove httpd
yum -y remove mysql-libs
yum -y install sysstat sendmail cronie crontabs cronie-anacron


pear=`which pear`
$pear install Net_SMTP
$pear install Mail


sed -i 's/exec \/sbin\/shutdown -r now "Control-Alt-Delete pressed"/#exec \/sbin\/shutdown -r now "Control-Alt-Delete pressed"/g' /etc/init/control-alt-delete.conf
sed -i 's/net.bridge.bridge-nf-call-ip6tables = 0/#net.bridge.bridge-nf-call-ip6tables = 0/g' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call-iptables = 0/#net.bridge.bridge-nf-call-iptables = 0/g' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call-arptables = 0/#net.bridge.bridge-nf-call-arptables = 0/g' /etc/sysctl.conf


sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 6/' /etc/ssh/sshd_config
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
echo 'net.ipv4.tcp_syncookies=1' >> /etc/sysctl.conf
echo 'export HISTTIMEFORMAT=" `whoami` %F %T "' >> /etc/profile
#----------禁用IPV6-------------#
echo 'install ipv6 /bin/true' > /etc/modprobe.d/disable-ipv6.conf
echo 'IPV6INIT=no' >> /etc/sysconfig/network
#-------------------------------#
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
SYSCTL


#----------删除不必要的用户---------------#
for i in `cat /etc/passwd | sort |awk -F ":" '{print $1}'`
do
case $i in
lp |news |uucp |games |mail)
userdel $i
groupdel $i
;;
esac
done
#-----------------------------------------#


rm -f /etc/httpd/conf.d/welcome.conf
/etc/init.d/mysqld start
/etc/init.d/httpd start
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
chkconfig --level 345 ntpd on
/etc/init.d/ntpd start
ntpdate cn.pool.ntp.org > /dev/null 2>&1

