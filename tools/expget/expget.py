#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

from PyQt6.QtCore import QUrl,QFile,qInstallMessageHandler
from PyQt6.QtWidgets import QApplication,QLineEdit,QMainWindow,QPushButton,QWidget,\
     QGridLayout,QHBoxLayout,QLabel
from PyQt6.QtWebEngineCore import QWebEnginePage
from PyQt6.QtWebEngineWidgets import QWebEngineView

from os import remove,mkdir,utime
from os.path import join,realpath,basename,exists,isfile,isdir,getsize
from time import time,mktime
from datetime import datetime
from hashlib import md5
from copy import deepcopy

#qInstallMessageHandler(lambda a,b,c: None)

def gethash(f):
    hasher=md5()
    try:
        ifile=open(f,'rb')
        while True:
            buf=ifile.read(0x800000)
            if len(buf)==0: break
            hasher.update(buf)
        ifile.close()
    except: pass
    return hasher.hexdigest().upper()

class MainWindow(QWidget):
    def cleanup(self):
        self.file_list=[]
        self.webEngineView.history().clear()
        if not self.isEnabled(): self.setDisabled(False)
        try:
            self.webEngineView.loadFinished.disconnect()
            self.webEngineView.page().profile().downloadRequested.disconnect()
        except: pass
        self.label.setText('Статус...')

    def reload(self):
        self.webEngineView.reload()

    def on_downloadRequestState(self,event):
        if not len(self.file_list): return
        if event.value>1:
            if event.value==2:
                if len(self.file_list[-1])>3:
                    h0=self.file_list[-1][3]
                    h1=gethash(self.file_list[-1][-1])
                    if h0==h1:
                        try:
                            tm=mktime(datetime.strptime(self.file_list[-1][2],"%d.%m.%Y %H:%M").timetuple())
                            tm+=(int(self.file_list[-1][1])%60)
                            utime(self.file_list[-1][-1],(tm,tm))
                        except: pass
                        print('Ok. ("%s") - %i'%(self.file_list[-1][-1],event.value))
                    else:  print('Error. ("%s") - %i'%(self.file_list[-1][-1],event.value))
                self.file_list.pop()
                self.download_files()
            else: print('Error. ("%s") - %i'%(self.file_list[-1][-1],event.value))

    def on_downloadRequested(self,event):
        if event.state().value==0:
            event.stateChanged.connect(lambda event: self.on_downloadRequestState(event))
            event.accept()

    def download_files(self):
        if len(self.file_list):
            tmp=self.file_list[-1]
            if exists(tmp[-1]):
                try: remove(tmp[-1])
                except: pass
            self.webEngineView.page().profile().downloadRequested.connect(lambda event:\
                self.on_downloadRequested(event))
            self.label.setText('Статус: скачивание файла '+tmp[0])
            if len(tmp)>3: self.webEngineView.page().download(QUrl(tmp[4]),tmp[-1])
            else:  self.webEngineView.page().download(QUrl(tmp[1]),tmp[-1])
        else: self.cleanup()

    def get_details_finished_back(self,links,path):
        if len(links):
            self.webEngineView.loadFinished.connect(lambda: self.get_details_callback(links,path))
            self.webEngineView.load(QUrl(links[-1]))

    def get_details_js_callback(self,result,links,path):
        if len(result) and len(links):
            for i in range(len(result)):
                self.file_list.append(result[i])
                self.file_list[-1].append(realpath(join(path,result[i][0])))
            self.webEngineView.loadFinished.disconnect()
            links.pop()
            if len(links):
                self.webEngineView.loadFinished.connect(lambda: self.get_details_finished_back(links,path))
            else: self.download_files()
            self.webEngineView.back()
        else: self.webEngineView.loadFinished.disconnect()

    def get_details_callback(self,links,path):
        self.webEngineView.page().runJavaScript(\
            "function getlinks(){\
              var list=[];\
              var req=document.querySelectorAll('a[href*=\"GetFile\"]');\
              for(const e of req){\
                if(e.text.includes(\".sig\")) list.push([e.text,e.href]);\
              };\
              return list;\
            };\
            getlinks();",lambda x: self.get_details_js_callback(x,links,path))

    def get_row_details(self,links,path):
        self.webEngineView.loadFinished.connect(lambda: self.get_details_callback(links,path))
        self.webEngineView.load(QUrl(links[-1]))

    def get_rows_js_callback(self,path,result):
        if len(path) and len(result):
            result=sorted(result,key=lambda s: s[0],reverse=False)
            detail_links=[]
            for i in range(len(result)):
                result[i].append(realpath(join(path,result[i][0])))
                s=result[i][4].split('/')[-1]
                detail_links.append('https://lk.spbexp.ru/SF/FileCspViewer/'+s)
            self.file_list=deepcopy(result)
            self.get_row_details(detail_links,path)
        else: self.cleanup()

    def get_header_js_callback(self,result):
        if len(result) and result!='Отсутствует':
            path=join(self.basepath,result.strip().rstrip().replace('"','_')[:64])
            try: mkdir(path)
            except:
                self.cleamup()
                return
            self.webEngineView.page().runJavaScript(\
                "function listrows(){\
                    var grid=$('#grid').data('kendoGrid');\
                    var files=[];\
                    grid._data.forEach(function(item,index,array){\
                        files.push([item.Nazvanie,item.Number,item.sDateTo,item.sMD5,'https://lk.spbexp.ru/File/GetFile/'+item.IDRow.toString()]);\
                    });\
                    return files;\
                };\
                listrows();",lambda x: self.get_rows_js_callback(path,x))
        else: self.cleanup()

    def getfilelist(self):
        self.file_list=[]
        self.webEngineView.page().runJavaScript(\
            "function find_header(){\
                var v=document.querySelector('span[style=\"font-weight:600; color:darkblue\"]');\
                if(v!=null) return v.textContent;\
                return '';\
            };\
            find_header();",self.get_header_js_callback)

    def __init__(self):
        super().__init__()
        self.setWindowTitle('ExpGet')

        self.webEngineView=QWebEngineView()
        ws=self.webEngineView.page().profile().defaultProfile()
        ws.setHttpCacheMaximumSize(0)
        ws=self.webEngineView.settings()
        ws.setAttribute(ws.WebAttribute.AutoLoadImages,True)
        ws.setAttribute(ws.WebAttribute.PluginsEnabled,False)

        self.grid=QGridLayout()
        self.grid.setContentsMargins(0,0,0,0)
        self.grid.setVerticalSpacing(0)
        self.grid.setHorizontalSpacing(0)
        self.hbox=QHBoxLayout()
        self.hbox.setSpacing(0)
        self.reload_button=QPushButton('Обновить страницу')
        self.get_data_button=QPushButton('Получить данные')
        self.hbox.addWidget(self.reload_button,1)
        self.hbox.addWidget(self.get_data_button,1)
        self.grid.addLayout(self.hbox,0,0)
        self.grid.addWidget(self.webEngineView,1,0)
        self.label=QLabel('Статус:...')
        self.label.setStyleSheet("QLabel {background-color:gray;color:black;}")
        self.grid.addWidget(self.label,2,0)
        self.grid.setRowStretch(0,0)
        self.grid.setRowStretch(1,1)
        self.grid.setRowStretch(2,0)
        self.setLayout(self.grid)

        self.webEngineView.load(QUrl('https://lk.spbexp.ru'))
        self.webEngineView.loadFinished.connect(self.login)

        self.file_list=[]
        self.basepath='out'
        try: mkdir(self.basepath)
        except: pass

        self.reload_button.clicked.connect(self.reload)
        self.get_data_button.clicked.connect(self.getfilelist)

    def goto_projects(self):
        self.webEngineView.load(QUrl('https://lk.spbexp.ru/SF/Zayava/'))
        self.webEngineView.loadFinished.disconnect()

    def login_callback(self,result):
        if len(result):
            self.webEngineView.loadFinished.connect(self.goto_projects)

    def login(self):
        l=p=''
        try:
            f=open('login','r')
            d=f.readlines()
            f.close()
            l=d[0].strip()
            p=d[1].strip()
        except:
            self.webEngineView.loadFinished.disconnect()
            return
        self.webEngineView.page().runJavaScript(\
            "function find_login_form(){\
                var v=document.querySelector('input[id=Login]');\
                if(v!=null){\
                    v.value=`%s`;\
                    v=document.querySelector('input[id=Password]');\
                    if(v!=null){\
                        v.value=`%s`;\
                        v=document.querySelector('button[type=submit]');\
                        if(v!=null){\
                            v.click();\
                            return 'ok';\
                        };\
                    };\
                }\
                return '';\
            };\
            find_login_form();"%(l,p),self.login_callback)

    def load(self):
        if url.isValid():
            self.webEngineView.load(url)

if __name__ == '__main__':
    app=QApplication(sys.argv)
    mainWin=MainWindow()
    availableGeometry=mainWin.screen().availableGeometry()
    mainWin.resize(int(availableGeometry.width()*2/3),int(availableGeometry.height()*2/3))
    mainWin.show()
    sys.exit(app.exec())
