#!/bin/bash
#DenyHosts Shell Script
#2011-04-11

cat /var/log/secure | awk '/Failed/ {print $(NF -3)}' | sort |uniq -c |awk '{print $2"="$1;}' > /tmp/black.txt
DEFINE="5"
for i in `cat /tmp/black.txt`
do
        IP=`echo $i |awk -F = '{print $1}'`
        NUM=`echo $i | awk -F = '{print $2}'`
        if [ $NUM -gt $DEFINE ]; then
                grep $IP /etc/hosts.deny > /dev/null
                if [ $? -ne 0 ]; then
                        echo "sshd:$IP" >> /etc/hosts.deny
                fi
        fi
done
