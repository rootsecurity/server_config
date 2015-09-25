#!/bin/bash
# 监控硬盘/var/wd分区使用

#当/var/wd/使用大于70%时SHIYONGLV为1，否则为0
SHIYONGLV=`df | grep var | grep -v wd/ | grep -c -E \([7-9][0-9]\%\)\|\(100\%\)`

if [ $SHIYONGLV -gt 0 ]; then
	/bin/rm -rf /var/wd/hadoop/tmp/dfs/data/current/subdir*
	/bin/rm -rf /var/wd/hadoop/tmp/dfs/data/current/blk*
	echo -e "\033[1;32;40m `date '+%Y-%m-%d %H:%M:%S\033[0m'`\033[0m" "\033[1;32;40m硬盘空间清理完毕\033[0m"
else
	echo -e "\033[1;32;40m `date '+%Y-%m-%d %H:%M:%S\033[0m'`\033[0m" "\033[1;32;40m硬盘空间合理，无需操作\033[0m"
fi
sleep 3
