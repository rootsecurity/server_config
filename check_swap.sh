#!/bin/bash

# @Name: check_swap.sh
# @author:rootsecurity
# @time: 2016/12/25

echo -e "PID\t\tSwap\t\tProc_Name"
    for pid in `ls -l /proc |grep ^d |awk '{print $9}' |grep -v [^0-9]`
    do
        # Do Not Check init Process
        if [ ${pid} -eq 1 ]; then
            continue;
        fi
        grep -q "Swap" /Proc/${pid}/smaps 2>/dev/null
        #检查是否占用SWAP分区
        if [ $? -eq 0 ]; then
            swap=$(gawk '/Swap/{ sum+=$2; } END{ print sum }' /proc/$pid/smaps)
            #统计占用的swap分区的大小 单位是KB
            proc_name=$(ps aux | grep -w "$pid" | awk '!/grep/{ for(i=11;i<=NF;i++){ printf("%s ",$i);  } }')
            #取出进程的名字
            if [ $swap -gt 0  ];then
                #判断是否占用swap  只有占用才会输出
                echo -e "$pid\t${swap}\t$proc_name"
            fi
        fi
    #按占用swap的大小排序，再用awk实现单位转换。
    done | sort -k2 -n | gawk -F'\t' '{
    if($2<1024)
        printf("%-10s\t%15sKB\t%s\n",$1,$2,$3);
    else if($2<1048576)
        printf("%-10s\t%15.2fMB\t%s\n",$1,$2/1024,$3);
    else
        printf("%-10s\t%15.2fGB\t%s\n",$1,$2/1048576,$3);
}'
