#!/usr/bin/env python
#-*- coding:utf8 -*-
#author: @rootsecurity
#date:2014-12-23

'''
simply script to scan firstp2p.com just set sep directory
home its can work.
'''

import os,datetime,time
import smtplib
import email
from email.MIMEMultipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header

def awvscan():
	awvs_path = r"C:/wvs_console.lnk"
	outfile_path = r"C:/AWVS/"

	print("=========create working directory===========")
	os.chdir(outfile_path)
	global workdir 
	workdir = outfile_path + str(datetime.date.today())
	try:
		os.makedirs(workdir)
	except OSError:
		workdir = workdir + "-01"
		os.makedirs(workdir)
	
	awvs_command = awvs_path + " /Scan " 'www.website.com' + " /saveFolder " + workdir + " /Save /GenerateReport /ReportFormat PDF"
	os.system(awvs_command)
		
def send_email():
	
	From = "sendmail@163.com"
	To = "to@163.com.com"
	file_name = "report.pdf"
	
	server = smtplib.SMTP("smtp.163.com")
	server.login("username","password")
	
	#构造MIMEMultipart对象做为根容器
	main_msg = email.MIMEMultipart.MIMEMultipart()
	
	#构造MIMEText对象做为邮件显示内容并附加到根容器 
	text_msg = email.MIMEText.MIMEText("This is a report to scan website.com")
	main_msg.attach(text_msg)
	
	# 构造MIMEBase对象做为文件附件内容并附加到根容器  
	contype = 'application/octet-stream'
	maintype, subtype = contype.split('/', 1)
	
	# 读入文件内容并格式化
	data = open(workdir + '/' + file_name, 'rb')
	file_msg = email.MIMEBase.MIMEBase(maintype, subtype)
	file_msg.set_payload(data.read()) 
	data.close()
	email.Encoders.encode_base64(file_msg)
	
	# 设置附件头 
	basename = os.path.basename(file_name)
	file_msg.add_header('Content-Disposition','attachment', filename = basename)
	main_msg.attach(file_msg)
	
	# 设置根容器属性
	main_msg['From'] = From
	main_msg['To'] = To
	main_msg['Subject'] = "[Weekly] website scan report"
	main_msg['Date'] = email.Utils.formatdate()

	# 得到格式化后的完整文本
	fullText = main_msg.as_string()
	
	# 用smtp发送邮件 
	try:
		server.sendmail(From, To, fullText)
	finally:
		server.quit()
		
if __name__ == "__main__":
	awvscan()
	send_email()
