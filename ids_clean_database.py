#!/usr/bin/env python
'''	--------------IDS系统数据库自动清理脚本-------------
	@Name:ids_clean_database.py
	@time:2014-07-14
	@author:rootsecurity
	@usage:python ids_clean_database.py
	----------------------------------------------------
'''
import urllib 
import requests
import os
import datetime

class idsession(requests.Session):
    def __init__(self):
        requests.Session.__init__(self)
        self.headers = {
            'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36',
            'Content-Type':'application/x-www-form-urlencoded',
            'Referer':'http://xxx.corp.domain.com/base/base_maintenance.php',
            'Accept-Encoding':'gzip,deflate,sdch',
	    'Accept-Language':'zh-CN,zh;q=0.8,en;q=0.6',
	    'Cache-Control':'max-age=0',
	    'Origin':'http://xxx.corp.domain.com',
	    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
	    'Host':'xxx.corp.domain.com',
	    'Content-Length':'24',
	    'Cookie':'BASERole=d825fc3fa4633ec76877fce157dbd4c8|admin|; PHPSESSID=aol74duuleofjq1o7sigamo160',
	    'Proxy-Connection':'keep-alive'
	}
	
	self.data = {
	    'submit':'Clear Data Tables',
	}
    def main(self):
        self.post_url = "http://xxx.corp.domain.com/base/base_maintenance.php"
	res2 = self.post(self.post_url,self.data,headers=self.headers)
    
if __name__ == '__main__':
    os.system("/usr/local/mysql/bin/mysqldump -u ids -pids2014 ids > /data/backup/ids."+str(datetime.datetime.now())[:10]+".sql")
    session=idsession()
    session.main()
    os.system("/etc/init.d/barnyard2 stop && /etc/init.d/suricata stop")
    os.system("/etc/init.d/barnyard2 start && /etc/init.d/suricata start")
