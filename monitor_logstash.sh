#!/bin/bash

#监控logstash进程
while true;
do
        l=`ps aux |grep logstash |grep -v grep`
        if [ "$?" != "0" ] ; then
                echo "logstash is down..."
                /usr/bin/nohup /usr/bin/java -jar /data/logstash/logstash-1.3.2-flatjar.jar agent -f /data/logstash/idc3.conf &
        else
                echo "logstash is running..."
        fi
sleep 3
done
