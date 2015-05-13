#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

'''
删除elasticsearch集群日志
输入开始日期(例如：20150101)，输入结束日期（例如：20150430）开始删除
当看到{"acknowledged":true}表明删除成功

'''

read -p "Please input start date:" date
read -p "Please inpur end date:" edate
date=${date:0:4}-${date:4:2}-${date:6:2}
edate=`date -d "$edate 1 days" "+%Y-%m-%d"`
while [[ "$date" < "$edate" ]]
    do
            d=${date:0:4}.${date:5:2}.${date:8:2}
            echo "Del $d log ..."
            #curl -XDELETE "http://xx.xx.xx.xx:9200/logstash-nids-${d}"           
            #curl -XDELETE "http://xx.xx.xx.xx:9200/logstash-p2plog-${d}"
            date=`date -d "$date 1 days" "+%Y-%m-%d"`
    done
