#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import base64
from os import walk,access,R_OK,stat,remove
from os.path import join,basename

flist=[["json\\ca_list_active.json","certs\\active"],["json\\ca_list_all.json","certs\\all"],["json\\root_list.json","certs\\root"]]

#flist=[["json\\ca_list_all.json","certs\\all"],["json\\root_list.json","certs\\root"]]

def cert_parse(dj,fname):
    tmpks=dj[unicode("ПрограммноАппаратныеКомплексы",'utf8')]
    for kt0 in tmpks.keys():
        for t1 in tmpks[kt0]:
            ks=t1[unicode("КлючиУполномоченныхЛиц",'utf8')][unicode("Ключ",'utf8')]
            for t2 in ks:
                id=fname+'\\'+t2[unicode("ИдентификаторКлюча",'utf8')]+'.cer'
                certs=t2[unicode("Сертификаты",'utf8')][unicode("ДанныеСертификата",'utf8')][0][unicode("Данные",'utf8')]
                fout=open(id,'wb')
                fout.write(base64.b64decode(certs))
                fout.close()

def certs_parse(ifile):
    f=open(ifile[0])
    d=json.load(f)
    if type(d) is dict and d.has_key('data'):
        for tmp in d['data']: cert_parse(tmp,ifile[1])
    else: cert_parse(d,ifile[1])
    f.close()

for f in flist: certs_parse(f)

db=[]

for root,dirs,files in walk('certs\\root',topdown=False):
    dirs.sort()
    for f in sorted(files):
        fname=join(root,f)
        try:
            if access(fname,R_OK): db.append(basename(fname))
        except: pass

for root,dirs,files in walk('certs\\all',topdown=False):
    dirs.sort()
    for f in sorted(files):
        fname=join(root,f)
        try:
            if access(fname,R_OK):
                if basename(fname) in db:
                    remove(fname)
        except: pass

for root,dirs,files in walk('certs\\active',topdown=False):
    dirs.sort()
    for f in sorted(files):
        fname=join(root,f)
        try:
            if access(fname,R_OK):
                if basename(fname) in db:
                    remove(fname)
        except: pass
