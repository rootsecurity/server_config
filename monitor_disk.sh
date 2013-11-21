#!/bin/bash

i=`df -h /var/log/http.log | grep G | awk '{print $3}' | awk -F"[.G]" '{print $1}'`
if [ $i -gt 10 ] ; then
        cat /dev/null > /var/log/http.log
fi
