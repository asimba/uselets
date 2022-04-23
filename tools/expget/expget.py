#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

from PyQt6.QtCore import QUrl,QFile,qInstallMessageHandler,QObject,pyqtSlot,QIODeviceBase
from PyQt6.QtWidgets import QApplication,QLineEdit,QMainWindow,QPushButton,QWidget,\
     QGridLayout,QHBoxLayout,QLabel
from PyQt6.QtWebEngineCore import QWebEnginePage
from PyQt6.QtWebEngineWidgets import QWebEngineView
from PyQt6.QtWebChannel import QWebChannel

from os import remove,mkdir,makedirs,utime
from os.path import join,realpath,basename,exists,isfile,isdir,getsize
from time import time,mktime
from datetime import datetime
from hashlib import md5
from copy import deepcopy
from time import sleep

qInstallMessageHandler(lambda a,b,c: None)

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

class CallHandler(QObject):
    def set_parent(self,parent):
        self.parent=parent

    @pyqtSlot(name="backrun_a")
    def backrun_a(self):
        self.parent.get_part_links_py_callback()

    @pyqtSlot(name="backrun_b")
    def backrun_b(self):
        self.parent.getfilelist_cycle_py_callback()

class MainWindow(QWidget):
    def reload(self):
        if len(self.div_list) or len(self.parts_list) or len(self.file_list): return
        self.webEngineView.reload()

    def on_downloadRequestState(self,event):
        if not len(self.file_list):
            self.label.setText('Статус:...'+tmp[0])
            return
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
        print(len(self.file_list))
        if len(self.file_list):
            tmp=self.file_list[-1]
            if exists(tmp[-1]):
                try: remove(tmp[-1])
                except: pass
            self.webEngineView.page().profile().downloadRequested.connect(lambda event:\
                self.on_downloadRequested(event))
            self.label.setText('Статус: скачивание файла '+tmp[0])
            if len(tmp)>3: self.webEngineView.page().download(QUrl(tmp[4]),tmp[-1])
            else: self.webEngineView.page().download(QUrl(tmp[1]),tmp[-1])
        else:
            self.webEngineView.page().profile().downloadRequested.disconnect()
            self.label.setText('Статус:...')
            if len(self.url):
                self.webEngineView.load(QUrl(self.url))
                self.url=''

    def get_details_finished_back(self,links,path):
        if self.lock:
            sleep(1)
            self.get_details_finished_back(links,path)
        else:
            try: self.webEngineView.loadFinished.disconnect()
            except: pass
            if len(links):
                self.webEngineView.loadFinished.connect(lambda: self.get_details_callback(links,path))
                self.webEngineView.load(QUrl(links[-1]))

    def get_details_js_callback(self,result,links,path):
        if self.lock: return
        self.lock=True
        if result and len(result) and len(links):
            for i in range(len(result)):
                if result[i][1] not in self.links:
                    self.links.append(result[i][1])
                    self.file_list.append(result[i])
                    self.file_list[-1].append(realpath(join(path,result[i][0])))
            self.webEngineView.loadFinished.disconnect()
            links.pop()
            self.lock=False
            if len(links):
                self.webEngineView.loadFinished.connect(lambda: self.get_details_finished_back(links,path))
            else:
                if len(self.div_list): self.div_list.pop()
                if len(self.div_list):
                    print(len(self.div_list))
                    self.getfilelist_cycle()
                    return
                else:
                    self.download_files()
                    return
            self.webEngineView.back()
        else: self.webEngineView.loadFinished.disconnect()
        self.lock=False

    def get_details_callback(self,links,path):
        self.webEngineView.page().runJavaScript(\
            """
            function getlinks(){
                var list=[];
                var req=document.querySelectorAll('a[href*=\"GetFile\"]');
                for(const e of req){
                    if(e.text.includes(\".sig\")) list.push([e.text,e.href]);
                };
                return list;
            };\
            getlinks();""",lambda x: self.get_details_js_callback(x,links,path))

    def get_row_details(self,links,path):
        if self.lock:
            sleep(1)
            self.get_row_details(links,path)
        else:
            try: self.webEngineView.loadFinished.disconnect()
            except: pass
            self.webEngineView.loadFinished.connect(lambda: self.get_details_callback(links,path))
            self.webEngineView.load(QUrl(links[-1]))

    def get_rows_js_callback(self,path,result):
        if self.lock: return
        self.lock=True
        if result and len(path) and len(result):
            result=sorted(result,key=lambda s: s[0],reverse=False)
            detail_links=[]
            for i in range(len(result)):
                result[i].append(realpath(join(path,result[i][0])))
                s=result[i][4].split('/')[-1]
                detail_links.append('https://lk.spbexp.ru/SF/FileCspViewer/'+s)
                if result[i][4] not in self.links:
                    self.links.append(result[i][4])
                    self.file_list.append(result[i])
            self.lock=False
            self.get_row_details(detail_links,path)
        self.lock=False

    def get_header_js_callback(self,result):
        if self.lock: return
        self.lock=True
        if result and len(result) and result!='Отсутствует':
            u=self.webEngineView.url().toString()
            if 'ProjectDocuments' in u: u='ПД'
            elif 'RIIDocuments' in u: u='РИИ'
            elif 'SmetaDocuments' in u: u='СД'
            elif 'IrdDocuments' in u: u='ИРД'
            else: u=''
            path=join(self.basepath,u,result.strip().rstrip().replace('"','_')[:64])
            self.lock=False
            try: makedirs(path,exist_ok=True)
            except: return
            self.webEngineView.page().runJavaScript(\
                """function listrows(){
                    var grid=$('#grid').data('kendoGrid');
                    var files=[];
                    grid._data.forEach(function(item,index,array){
                        files.push([item.Nazvanie,item.Number,item.sDateTo,item.sMD5,
                            'https://lk.spbexp.ru/File/GetFile/'+item.IDRow.toString()]);
                    });
                    return files;
                };
                listrows();""",lambda x: self.get_rows_js_callback(path,x))
        self.lock=False

    def getfilelist_cycle_py_callback(self):
        if self.lock: return
        self.lock=True
        self.webEngineView.page().runJavaScript(\
            "find_header();",self.get_header_js_callback)
        self.lock=False

    def getfilelist_cycle_callback(self):
        if self.lock:
            sleep(1)
            self.getfilelist_cycle_callback()
        else:
            try: self.webEngineView.loadFinished.disconnect()
            except: pass
            self.webEngineView.page().runJavaScript(\
                self.qwebchannel_js+"""
                window.find_header_ready=false;
                function find_header(){
                    if(window.find_header_ready==false){
                        var v=document.querySelector('span[style=\"font-weight:600; color:darkblue\"]');
                        if(v!=null) return v.textContent;
                        window.find_header_ready=true;
                    };
                    return '';
                };
                function call_py(){
                    new QWebChannel(qt.webChannelTransport,function(channel){
                        channel.objects.backend.backrun_b();
                    });
                };
                var grid=$("#grid").data("kendoGrid");
                if(grid){
                    grid.bind("dataBound",call_py);
                    grid.dataSource.read();
                };""",lambda x: None)

    def getfilelist_cycle(self):
        if self.lock:
            sleep(1)
            self.getfilelist_cycle()
        else:
            try: self.webEngineView.loadFinished.disconnect()
            except: pass
            if len(self.div_list):
                self.webEngineView.loadFinished.connect(self.getfilelist_cycle_callback)
                self.webEngineView.load(QUrl(self.div_list[-1]))

    def getfilelist(self):
        if len(self.div_list) or len(self.parts_list) or len(self.file_list): return
        self.file_list=[]
        self.links=[]
        self.url=self.webEngineView.url().toString()
        if 'Files/prt' in self.url:
            self.div_list=[self.url]
            self.getfilelist_cycle()

    def get_part_links_back_callback(self):
        if len(self.parts_list): self.parts_list.pop()
        if len(self.parts_list): self.get_part_links()
        else: self.getfilelist_cycle()

    def get_part_links_js_complete_callback(self,result):
        if self.lock: return
        self.lock=True
        selectors=[s+'Files' for s in self.selectors]
        if len(result):
            for r in result:
                if any(s in r for s in selectors) and r not in self.div_list:
                    self.div_list.append(r)
        else:
            self.lock=False
            return;
        self.webEngineView.loadFinished.disconnect()
        self.lock=False
        self.get_part_links_back_callback()

    def get_part_links_py_callback(self):
        if self.lock:
            sleep(1)
            self.get_part_links_py_callback()
        else:
            self.webEngineView.page().runJavaScript(\
                "getlinks();",self.get_part_links_js_complete_callback)

    def get_part_links_callback(self):
        if self.lock:
            sleep(1)
            self.get_part_links_callback()
        else:
            self.webEngineView.page().runJavaScript(\
                self.qwebchannel_js+"""
                window.getlinks_ready=false;
                function getlinks(){
                    var list=[];
                    if(window.getlinks_ready==false){
                        var req=document.querySelectorAll('a[href*=\"Files/prt\"]');
                        for(const e of req) list.push(e.href);
                        window.getlinks_ready=true;
                    };
                    return list;
                };
                function call_py(){
                    new QWebChannel(qt.webChannelTransport,function(channel){
                        channel.objects.backend.backrun_a();
                    });
                };
                var grid=$("#grid").data("kendoGrid");
                if(grid){
                    grid.bind("dataBound",call_py);
                    grid.dataSource.read();
                };""",lambda x: None)

    def get_part_links(self):
        if self.lock:
            sleep(1)
            self.get_part_links()
        else:
            try: self.webEngineView.loadFinished.disconnect()
            except: pass
            if len(self.parts_list):
                self.webEngineView.loadFinished.connect(self.get_part_links_callback)
                self.webEngineView.load(QUrl(self.parts_list[-1]))

    def getallfileslist_js_callback(self,result):
        if self.lock: return
        self.lock=True
        if result and len(result):
            for r in result:
                if any(s in r for s in self.selectors) and  '#' not in r:
                    self.parts_list.append(r)
        self.lock=False
        self.get_part_links()

    def getallfileslist(self):
        if len(self.div_list) or len(self.parts_list) or len(self.file_list): return
        self.file_list=[]
        self.parts_list=[]
        self.div_list=[]
        self.links=[]
        self.url=self.webEngineView.url().toString()
        self.webEngineView.page().runJavaScript(\
            """function getpartlinks(){
              var list=[];
              var req=document.querySelectorAll('a[href]');
              for(const e of req) if(list.includes(e.href)==false && e.href.includes('prt0')) list.push(e.href);
              return list;
            };
            getpartlinks();""",self.getallfileslist_js_callback)

    def __init__(self):
        super().__init__()
        self.setWindowTitle('ExpGet')

        self.webEngineView=QWebEngineView()
        ws=self.webEngineView.page().profile().defaultProfile()
        ws.setHttpCacheMaximumSize(0)
        ws=self.webEngineView.settings()
        ws.setAttribute(ws.WebAttribute.AutoLoadImages,True)
        ws.setAttribute(ws.WebAttribute.PluginsEnabled,False)

        qwebchannel_js=QFile(':/qtwebchannel/qwebchannel.js')
        if not qwebchannel_js.open(QIODeviceBase.OpenModeFlag.ReadOnly):
            raise SystemExit(
                'Failed to load qwebchannel.js with error: %s' %
                qwebchannel_js.errorString())
        self.qwebchannel_js=bytes(qwebchannel_js.readAll()).decode('utf-8')
        self.channel=QWebChannel()
        self.handler=CallHandler()
        self.handler.set_parent(self)
        self.channel.registerObject('backend',self.handler)
        self.webEngineView.page().setWebChannel(self.channel)

        self.grid=QGridLayout()
        self.grid.setContentsMargins(0,0,0,0)
        self.grid.setVerticalSpacing(0)
        self.grid.setHorizontalSpacing(0)
        self.hbox=QHBoxLayout()
        self.hbox.setSpacing(0)
        self.reload_button=QPushButton('Обновить страницу')
        self.get_data_button=QPushButton('Получить данные')
        self.get_all_data_button=QPushButton('Скачать данные проекта')
        self.hbox.addWidget(self.reload_button,1)
        self.hbox.addWidget(self.get_data_button,1)
        self.hbox.addWidget(self.get_all_data_button,1)
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
        self.parts_list=[]
        self.div_list=[]
        self.links=[]
        self.lock=False
        self.url=''
        self.basepath='out'
        try: mkdir(self.basepath)
        except: pass
        self.selectors=['ProjectDocuments','RIIDocuments','SmetaDocuments','IrdDocuments']

        self.reload_button.clicked.connect(self.reload)
        self.get_data_button.clicked.connect(self.getfilelist)
        self.get_all_data_button.clicked.connect(self.getallfileslist)

    def goto_projects(self):
        self.webEngineView.loadFinished.disconnect()
        self.webEngineView.load(QUrl('https://lk.spbexp.ru/SF/Zayava/'))

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
        self.webEngineView.page().runJavaScript("""
            function find_login_form(){
                var v=document.querySelector('input[id=Login]');
                if(v!=null){
                    v.value=`%s`;
                    v=document.querySelector('input[id=Password]');
                    if(v!=null){
                        v.value=`%s`;
                        v=document.querySelector('button[type=submit]');
                        if(v!=null){
                            v.click();
                            return 'ok';
                        };
                    };
                };
                return '';
            };
            find_login_form();"""%(l,p),self.login_callback)

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
