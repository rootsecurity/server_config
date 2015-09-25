#!/bin/bash

#监控/var/log/suricata/http.log
i=`du /var/log/suricata/http.log |awk '{print $1}'`
if [ $i -ge 512000 ] ; then
        cat /dev/null > /var/log/suricata/http.log
fi

#监控/var/log/suricata/fast.log
g=`du /var/log/suricata/fast.log | awk '{print $1}'`
if [ $g -ge 204800 ] ; then
        cat /dev/null > /var/log/suricata/fast.log
fi

#监控/var/log/suricata/stats.log
q=`du /var/log/suricata/stats.log | awk '{print $1}'`
if [ $q -ge 204800 ] ; then
        cat /dev/null > /var/log/suricata/stats.log
fi
