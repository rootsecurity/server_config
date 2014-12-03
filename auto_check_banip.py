#coding:utf8
#!/usr/bin/python
'''
        -------------------------
        $Name:auto_check_banip.py
        -------------------------
        $Time:2014-12-03 16:22:00
        -------------------------

'''

import os
import sys
import time
import datetime
import MySQLdb
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from subprocess import Popen,PIPE

#连接数据库
conn=MySQLdb.Connect(host="127.0.0.1",user="s_user_3aee7fl0",passwd="m3Ar5PnaUyjabF",db="s_db_3aee7fl0",port=3306)
cursor = conn.cursor()

#定义时间
t0=int(time.time())+8*3600
t1=datetime.datetime.utcfromtimestamp(t0).strftime("%Y-%m-%d %H:%M:%S")

t2=t0-24*3600
t2=datetime.datetime.utcfromtimestamp(t2).strftime("%Y-%m-%d %H:%M:%S")

#查询条件
sql="select ip from banip where ban_time between '%s' and '%s'" % (t1,t2)
a=cursor.execute(sql)
iplist=[]
for i in cursor.fetchall():
        iplist.append(i[2])
#发送邮件
result = "Today we blocked " +str(a)+" ip \n"+'|'.join([i for i in iplist])
print result
msg=MIMEText(result)
msg["From"] = "no-reply@server.com"
msg["To"] = "security@server.com"
msg["Subject"] = "IP Block Information".decode('utf-8')
p = Popen(["/usr/sbin/sendmail", "-t"], stdin=PIPE)
p.communicate(msg.as_string())
