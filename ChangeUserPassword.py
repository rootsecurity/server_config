#!/usr/bin/env python

'''
@ Change Password for Users
@ 2017/03/03  09:24:30

'''

import os
import random
import commands
import string

def random_str(randomlength=32):
    p = ''.join(random.sample(string.ascii_letters + string.digits, randomlength))
    return p

def do_ChangePassword():
    newPass = random_str()
    IPAddr = commands.getoutput("ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'")
    cmd = 'echo '+ newPass+' | passwd --stdin root'
    os.system(cmd)
    print '========================'
    print 'IP:\n',  IPAddr
    print 'New Password will be:\n',  newPass
    print '========================'

if __name__ == '__main__':
    do_ChangePassword()
