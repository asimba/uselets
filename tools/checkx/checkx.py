#!/usr/bin/env python
# -*- coding: utf-8 -*-

from tempfile import mkdtemp
from shutil import rmtree
from sys import argv,path,exit
from os import walk,access,mkdir,R_OK,popen
from os.path import isfile,dirname,realpath,join,basename
from subprocess import Popen,PIPE,STDOUT
from platform import system
path.insert(0,join(dirname(realpath(argv[0])),'zipfix.zip'))
import zipfix
from string import find,rstrip
import re

stopmask=re.compile('(\.(ade|adp|bas|bat|chm|cmd|com|cpl|crt|exe|hlp|hta|inf|\
ins|isp|jse|js|lnk|mde|msc|msi|msp|pcd|reg|scr|sct|url|vbs|vbe|wsf|wsh|wsc|\
wmv|wma|mp3|avi|mpg|hta|ppsx)|incorrect|password|not\ supported)',re.IGNORECASE)

stopmask_arc=re.compile('(\.rar|7z|zip|zipx|arj|ace|daa)',re.IGNORECASE)

allowmask=re.compile('(7-Zip|p7zip|Scanning|Testing\ archive|Path|Type|Listing)',re.IGNORECASE)

file_types=re.compile('^.*(\.docx|doc|xlsx|xls|rar|7z|zip|gz|ace|ods|odt|odp|ls|[0-9]{3}|r[0-9]{2})$',re.IGNORECASE)

up='/usr/bin/'
bp='/bin/'
fp=up+'file'
rp=up+'ripole'
pr=up+'unrar'
prt=up+'unrar'
p7=up+'7z'
p7t=up+'7z'
pz=up+'unzip'
pg=bp+'gunzip'
pa=up+'unace'
fp+=' -b '
pr+=' lb -p- '
prt+=' t -p- '
p7+=' l -p- '
p7t+=' t -p- '
pz+=' -l '
pg+=' -lN '
pa+=' l '

def checkcmd(cmd,path):
    lines=None
    try:
        f=Popen(cmd+' "'+path+'"',shell=True,stdin=None,stdout=PIPE,\
            stderr=STDOUT)
        f.wait()
        lines=f.stdout.readlines()
        f.stdout.close()
    except: pass
    return lines

def checktype(lines):
    for l in lines:
        if find(l,'executable')!=-1: print 'stop'; return 1
    return 0

def arctype(src):
    for l in checkcmd(fp,src):
        if find(l,' archive data,')!=-1: print 'stop'; return 1
    return 0

def checkdoc(src):
    if arctype(src): return
    try:
        tdir=mkdtemp()
        try:
            odir=join(tdir,'ole')
            mkdir(odir)
            checkcmd(rp+' -d '+odir+' -i ',src)
            for root,dirs,files in walk(odir,topdown=False):
                for f in files:
                    try:
                        if checktype(checkcmd(fp,join(root,f))): break;
                        elif f[-3:]=='.js':
                            print 'stop'
                            break;
                    except: pass
        except: pass
        try: rmtree(tdir)
        except: pass
    except: return

def checkdocx(src):
    try:
        if not(zipfix.is_zipfile(src)): return
        else:
            tdir=mkdtemp()
            try:
                zsrc=zipfix.ZipFile(src,'r')
                zsrc.extractall(tdir)
                zsrc.close()
                odir=join(tdir,'ole')
                mkdir(odir)
                for root,dirs,files in walk(tdir,topdown=False):
                    for f in files:
                        try:
                            lines=checkcmd(fp,join(root,f))
                            for l in lines:
                                if find(l,'Microsoft Office Document')!=-1\
                                    or find(l,'Composite Document File')!=\
                                    -1:
                                    checkcmd(rp+' -d '+odir+' -i ',\
                                    join(root,f))
                        except: pass
                for root,dirs,files in walk(odir,topdown=False):
                    for f in files:
                        try:
                            if checktype(checkcmd(fp,join(root,f))): break
                            elif f[-3:]=='.js':
                                print 'stop'
                                break;
                        except: pass
            except: pass
            try: rmtree(tdir)
            except: pass
    except: return

def checkarc(cmd,src):
    try:
        for l in checkcmd(cmd,src): 
            if stopmask.search(l) and not allowmask.search(l):
                 print 'stop'
                 break
            if stopmask_arc.search(l) and not allowmask.search(l):
                 print 'stop'
                 break
    except: pass

#from shutil import copy

if __name__ == "__main__":
    if len(argv)>2:
        src=realpath(rstrip(argv[1]))
#        fo=open('/var/log/checkx.log','a')
#        fo.write(src+':'+argv[2]+'\n')
#        if len(argv)>3: fo.write(argv[3]+'\n')
#        fo.close()
#        copy(src,join('/mnt/storage/temp/vx',basename(argv[1])))
        if not(isfile(src) and access(src,R_OK)): exit()
        elif argv[2]=='docx': checkdocx(src)
        elif argv[2]=='doc': checkdoc(src)
        elif argv[2]=='rar':
            checkarc(pr,src)
            checkarc(prt,src)
        elif argv[2]=='7z': checkarc(p7,src)
        elif argv[2]=='zip':
            checkarc(p7,src)
            checkarc(p7t,src)
        elif argv[2]=='gz': checkarc(pg,src)
        elif argv[2]=='ace': checkarc(pa,src)
        elif argv[2]=='bin' and len(argv)>3:
            if not file_types.search(argv[3]): arctype(src)
    else: exit()

