#!/bin/bash

#监控logstash进程
while true;
do
        l=`ps aux |grep logstash |grep -v grep`
        if [ "$?" != "0" ] ; then
                echo "logstash is down..."
                /etc/init.d/logstash start
        else
                echo "logstash is running..."
        fi
sleep 3
done
