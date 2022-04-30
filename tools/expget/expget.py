#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

from PyQt6.QtCore import QUrl,QFile,qInstallMessageHandler,QObject,pyqtSlot,QIODeviceBase,QVariant
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

    @pyqtSlot(QVariant,result=QVariant,name="backrun_error")
    def backrun_error(self,error):
        self.parent.getfilelist_error_callback()

    @pyqtSlot(QVariant,result=QVariant,name="backrun_success")
    def backrun_success(self,links):
        self.parent.getfilelist_success_callback(links)

    @pyqtSlot(QVariant,result=QVariant,name="backrun_progress")
    def backrun_progress(self,counter):
        self.parent.progress_callback(counter)

    @pyqtSlot(name="backrun_cancel")
    def backrun_cancel(self):
        self.parent.canceled_callback()

class MainWindow(QWidget):
    def reload(self):
        if len(self.file_list): return
        self.webEngineView.reload()

    def on_downloadRequestState(self,event):
        if not len(self.file_list):
            self.alllock=False
            self.label.setText('Статус:...')
            self.reload()
            try:
                for b in self.buttons: b.setEnabled(True)
            except: pass
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
                    else:
                        print('Error. ("%s") - %i'%(self.file_list[-1][-1],event.value))
                        self.label.setText('Статус: ошибка скачивания файла ("'+tmp[0]+'")')
                self.file_list.pop()
                self.download_files()
            else:
                print('Error. ("%s") - %i'%(self.file_list[-1][-1],event.value))
                self.label.setText('Статус: ошибка скачивания файла ("%s", код ошибки: %i)!'%(self.file_list[-1][-1],event.value))
                self.alllock=False
                self.reload()
                try:
                    for b in self.buttons: b.setEnabled(True)
                except: pass

    def check_canceled(self,event):
        if event: self.canceled_callback()

    def on_downloadRequested(self,event):
        self.webEngineView.page().runJavaScript(\
            """
            function check_canceled(){
                if(window.process_canceled) return 1;
                else return 0;
            };
            check_canceled();
            """,self.check_canceled)
        if event.state().value==0:
            event.stateChanged.connect(lambda event: self.on_downloadRequestState(event))
            event.accept()

    def download_files(self):
        if len(self.file_list):
            if not self.file_number: self.file_number=len(self.file_list)
            tmp=self.file_list[-1]
            if exists(tmp[-1]):
                try: remove(tmp[-1])
                except: pass
            self.webEngineView.page().profile().downloadRequested.connect(lambda event:\
                self.on_downloadRequested(event))
            self.label.setText('Статус: скачивание файла "%s" ( %i из %i )'%\
                               (tmp[0],self.file_number-len(self.file_list)-1,self.file_number))
            if len(tmp)>3: self.webEngineView.page().download(QUrl(tmp[4]),tmp[-1])
            else: self.webEngineView.page().download(QUrl(tmp[1]),tmp[-1])
        else:
            self.webEngineView.page().profile().downloadRequested.disconnect()
            self.label.setText('Статус:...')
            self.alllock=False
            self.reload()
            try:
                for b in self.buttons: b.setEnabled(True)
            except: pass

    def canceled_callback(self):
        self.label.setText('Статус: операция отменена!')
        self.alllock=False
        self.file_list=[]
        self.file_number=0
        self.reload()
        try:
            for b in self.buttons: b.setEnabled(True)
        except: pass

    def getfilelist_error_callback(self):
        self.label.setText('Статус: ошибка при получении списка файлов для скачивания!')
        self.alllock=False
        self.file_list=[]
        self.file_number=0
        self.reload()
        try:
            for b in self.buttons: b.setEnabled(True)
        except: pass

    def getfilelist_success_callback(self,links):
        for link in links:
            if link[0]=='ProjectDocuments': link[0]='ПД'
            elif link[0]=='RIIDocuments': link[0]='РИИ'
            elif link[0]=='SmetaDocuments': link[0]='СД'
            elif link[0]=='IrdDocuments': link[0]='ИРД'
            link[1]=link[1].strip().rstrip().replace('"','_')[:64]
            path=join(self.basepath,link[0],link[1])
            try: makedirs(path,exist_ok=True)
            except: return
            if len(link)>4:
                self.file_list.append([link[2],link[6],link[4],link[5],link[3],realpath(join(path,link[2]))])
            else: self.file_list.append([link[2],link[3],realpath(join(path,link[2]))])
        if len(self.file_list):
            self.alllock=False
            self.download_files()

    def progress_callback(self,counter):
        self.label.setText('Статус: получение списка файлов для скачивания (получено %d ссылок)...'%counter)

    def getfileslist(self):
        if self.alllock or len(self.file_list): return
        self.url=self.webEngineView.url().toString()
        if not('Files/prt0' in self.url): return
        self.file_list=[]
        self.file_number=0
        try:
            for b in self.buttons: b.setEnabled(False)
        except: pass
        self.label.setText('Статус: получение списка файлов для скачивания...')
        self.webEngineView.page().runJavaScript(\
            self.qwebchannel_js+self.busy+"""
            function get_sig_links_details_parse(file_links,details_links,partitions,partition,section,data){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                var parser=new DOMParser();
                var doc=parser.parseFromString(data,'text/html');
                var req=doc.querySelectorAll('a[href*=\"GetFile\"]');
                for(const e of req){
                    if(e.text.includes('.sig')){
                        file_links.push([partition,section,e.text,e.href]);
                        progress(file_links);
                    };
                };
                if(details_links.length) get_sig_links_details(file_links,details_links,partitions);
                else success(file_links);
            };
            function start_parser(){
                var file_links=[];
                var details_links=[];
                var url=window.location.href.toString();
                var path='';
                if(url.includes('ProjectDocuments')) path='ProjectDocuments';
                else if(url.includes('RIIDocuments')) path='RIIDocuments';
                    else if(url.includes('SmetaDocuments')) path='SmetaDocuments';
                        else if(url.includes('IrdDocuments')) path='IrdDocuments';
                var href=''.concat('https://lk.spbexp.ru/Grid/',path,'FilesRead/own',
                    window.location.href.toString().split('\/').pop());
                var v=document.querySelector('span[style=\"font-weight:600; color:darkblue\"]');\
                if(v==null) return;
                var section=v.textContent;
                var links=[[path,section,href]];
                new QWebChannel(qt.webChannelTransport,(channel)=>{
                    window.qtwebchannel=channel.objects.backend;
                });
                get_pd_links_details(links,file_links,details_links,[]);
            };
            start_parser();
            """,lambda x: None)

    def getallfileslist(self):
        if self.alllock or len(self.file_list): return
        self.url=self.webEngineView.url().toString()
        if not('lk.spbexp.ru/Zeg/Zegmain' in self.url or\
               ('lk.spbexp.ru/SF/' in self.url and '/prt0/' in self.url)): return
        self.file_list=[]
        self.file_number=0
        try:
            for b in self.buttons: b.setEnabled(False)
        except: pass
        self.label.setText('Статус: получение списка файлов для скачивания...')
        self.webEngineView.page().runJavaScript(\
            self.qwebchannel_js+self.busy+"""
            function get_sig_links_details_parse(file_links,details_links,partitions,partition,section,data){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                var parser=new DOMParser();
                var doc=parser.parseFromString(data,'text/html');
                var req=doc.querySelectorAll('a[href*=\"GetFile\"]');
                for(const e of req){
                    if(e.text.includes('.sig')){
                        file_links.push([partition,section,e.text,e.href]);
                        progress(file_links);
                    };
                };
                if(details_links.length) get_sig_links_details(file_links,details_links,partitions);
                else get_file_links(file_links,details_links,partitions);
            };
            function get_pd_links_parse(path,file_links,details_links,partitions,data){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                var links=[];
                for(const d of data.Data){
                    if(d['NumberOfFiles']){
                        var href=''.concat('https://lk.spbexp.ru/Grid/',path,'FilesRead/own',d['IDRow']);
                        if(path.includes('IrdDocuments')) links.push([path,d['Content'],href]);
                        else links.push([path,d['Nazvanie'],href]);
                    };
                };
                if(links.length) get_pd_links_details(links,file_links,details_links,partitions);
            };
            async function get_pd_links(path,file_links,details_links,partitions){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                var req=document.querySelector('a[href*="/Zeg/Zegmain1"]');
                if(req){
                    var href=''.concat('https://lk.spbexp.ru/Grid/',path,'Read/own',req.pathname.split('\/').pop());
                    return await fetch(href)
                                .then(async (response) => {
                                const j=await response.json();
                                get_pd_links_parse(path,file_links,details_links,partitions,j);
                                }).catch((error) => { errlog(error); });
                };
            };
            function get_file_links(file_links,details_links,partitions){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                if(partitions.length) get_pd_links(partitions.pop(),file_links,details_links,partitions);
                else success(file_links);
            };
            function start_parser(){
                var file_links=[];
                var details_links=[];
                var partitions=['ProjectDocuments','RIIDocuments','SmetaDocuments','IrdDocuments'];
                new QWebChannel(qt.webChannelTransport,(channel)=>{
                    window.qtwebchannel=channel.objects.backend;
                });
                get_file_links(file_links,details_links,partitions);
            };
            start_parser();
            """,lambda x: None)

    def __init__(self):
        super().__init__()
        self.setWindowTitle('ExpGet')
        self.busy="""
            window.process_canceled=false;
            function errlog(error){
                window.qtwebchannel.backrun_error(error);
            };
            function success(file_links){
                window.qtwebchannel.backrun_success(file_links);
            };
            function progress(file_links){
                window.qtwebchannel.backrun_progress(file_links.length);
            };
            async function cancel(){
                window.qtwebchannel.backrun_cancel();
            };
            async function get_sig_links_details(file_links,details_links,partitions){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                if(details_links.length){
                    var d=details_links.pop();
                    return await fetch(d[2])
                                .then(async (response) => {
                                    const j=await response.text();
                                    get_sig_links_details_parse(file_links,details_links,partitions,d[0],d[1],j);
                                }).catch((error) => { errlog(error); });
                };
            };
            function get_pd_links_details_parse(links,file_links,details_links,partitions,partition,section,data){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                for(const d of data.Data){
                    file_links.push([partition,section,d['Nazvanie'],''.concat('https://lk.spbexp.ru/File/GetFile/',
                        d['IDRow']),d['sDateTo'],d['sMD5'],d['Number']]);
                    progress(file_links);
                    details_links.push([partition,section,''.concat('https://lk.spbexp.ru/SF/FileCspViewer/',d['IDRow'])]);
                };
                if(links.length) get_pd_links_details(links,file_links,details_links,partitions);
                else get_sig_links_details(file_links,details_links,partitions);
            };
            async function get_pd_links_details(links,file_links,details_links,partitions){
                if(window.process_canceled){
                    cancel();
                    return;
                };
                if(links.length){
                    var d=links.pop();
                    return await fetch(d[2])
                                .then(async (response) => {
                                    const j=await response.json();
                                    get_pd_links_details_parse(links,file_links,details_links,partitions,d[0],d[1],j);
                                }).catch((error) => { errlog(error); });
                };
            };
            function button_click(){
                window.process_canceled=true;
            };
            class ProgressRing extends HTMLElement{
                constructor(){
                    super();
                    const stroke=this.getAttribute('stroke');
                    const radius=this.getAttribute('radius');
                    const normalizedRadius=radius-stroke*2;
                    this._circumference=normalizedRadius*2*Math.PI;
                    this._root=this.attachShadow({mode:'open'});
                    this._root.innerHTML=`
                        <svg height="${radius*2}" width="${radius*2}">
                            <circle
                                class="ring"
                                stroke="#3c3b3a"
                                stroke-width="${stroke*2}"
                                stroke-opacity="0.5"
                                fill="transparent"
                                r="${normalizedRadius}"
                                cx="${radius}"
                                cy="${radius}"
                                shape-rendering="geometricPrecision"
                            />
                            <circle
                                class="ring"
                                stroke="#c8c5c3"
                                stroke-dasharray="${this._circumference} ${this._circumference}"
                                style="stroke-dashoffset:${this._circumference}"
                                stroke-width="${stroke}"
                                fill="transparent"
                                r="${normalizedRadius-2}"
                                cx="${radius}"
                                cy="${radius}"
                                shape-rendering="geometricPrecision"
                            />
                            <circle
                                class="button"
                                stroke="#191919"
                                stroke-width="4"
                                stroke-opacity="0.5"
                                fill="#f44336"
                                r="${normalizedRadius-stroke-2}"
                                cx="${radius}"
                                cy="${radius}"
                                shape-rendering="geometricPrecision"
                                onclick="button_click()"
                            />
                            <text class="txt" x="50%" y="52%" text-rendering="geometricPrecision">STOP</text>
                        </svg>
                        <style>
                            .ring {
                                transition: stroke-dashoffset 0.35s;
                                transform: rotate(-90deg);
                                transform-origin: 50% 50%;
                            }
                            .button:hover {
                                fill: #ce000f;
                                opacity: 1;
                            }
                            .txt {
                                font: bold 40px sans-serif;
                                fill: #323232;
                                stroke: #4c4c4c;
                                stroke-width: 1px;
                                text-anchor: middle;
                                dominant-baseline: middle;
                                pointer-events: none;
                            }
                        </style>
                    `;
                }
                setProgress(percent){
                    const offset=this._circumference-(percent/100*this._circumference);
                    const circle=this._root.querySelectorAll('circle')[1];
                    circle.style.strokeDashoffset=offset;
                }
                setTransition(value){
                    const circle=this._root.querySelectorAll('circle')[1];
                    circle.style.transition='stroke-dashoffset '+value+'s';
                }
                static get observedAttributes(){ return ['progress','transition']; }
                attributeChangedCallback(name,oldValue,newValue){
                    if(name==='progress') this.setProgress(newValue);
                    if(name==='transition') this.setTransition(newValue);
                }
            }
            function overlay() {
                [].forEach.call(document.querySelectorAll('nav'), function (el) {
                    el.style.visibility = 'hidden';
                });
                [].forEach.call(document.querySelectorAll('*[class*=popover]'), function (el) {
                    el.style.visibility = 'hidden';
                });
                var overlay=document.createElement("div");
                overlay.style.opacity=0.9;
                overlay.style.width='100%';
                overlay.style.height='100%';
                overlay.style.top='0px';
                overlay.style.left='0px';
                overlay.style.backgroundColor='#666666';
                overlay.style.zIndex='1000';
                overlay.style.position = 'absolute';
                document.getElementsByTagName('body')[0].appendChild(overlay);
                window.customElements.define('progress-ring',ProgressRing);
                const circle=document.createElement("div");
                circle.innerHTML=`<progress-ring stroke="8" radius="88" progress="0"></progress-ring>`
                circle.style.top='50%';
                circle.style.left='50%';
                circle.style.marginTop='-88px'
                circle.style.marginLeft='-88px'
                circle.style.zIndex='2000';
                circle.style.position='absolute';
                window.cprogress=0;
                document.body.appendChild(circle);
                document.body.style.overflow='hidden';
            };
            overlay();
            const interval=setInterval(()=>{
                const el=document.querySelector('progress-ring');
                if(window.cprogress==200){
                    el.setAttribute('transition','0');
                    window.cprogress=0;
                    el.setAttribute('progress',window.cprogress);
                }
                else{
                    if(window.cprogress==0) el.setAttribute('transition','0.35');
                    window.cprogress+=2;
                    el.setAttribute('progress',window.cprogress);
                };
            },100);
        """

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
        self.buttons=[self.reload_button,self.get_data_button,self.get_all_data_button]
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
        self.file_number=0
        self.lock=False
        self.alllock=False
        self.basepath=realpath('out')
        try: makedirs(self.basepath,exist_ok=True)
        except: pass

        self.reload_button.clicked.connect(self.reload)
        self.get_data_button.clicked.connect(self.getfileslist)
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

if __name__ == '__main__':
    app=QApplication(sys.argv)
    mainWin=MainWindow()
    availableGeometry=mainWin.screen().availableGeometry()
    mainWin.resize(int(availableGeometry.width()*2/3),int(availableGeometry.height()*2/3))
    mainWin.show()
    sys.exit(app.exec())
