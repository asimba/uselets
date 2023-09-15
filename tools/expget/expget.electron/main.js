const { app, BrowserWindow, BrowserView, ipcMain } = require('electron')
const path = require('path')
const fs = require('fs')
const crypto = require('crypto');

function getChecksum(path) {
  return new Promise((resolve, reject) => {
    const hash = crypto.createHash('md5');
    const input = fs.createReadStream(path);
    input.on('error', reject);
    input.on('data', (chunk) => {
        hash.update(chunk);
    });
    input.on('close', () => {
        resolve(hash.digest('hex'));
    });
  });
}

function set_status(status){
  app.status.executeJavaScript(
    `document.getElementById('status-bar').textContent='Статус: ${status}...';`
  )
}
const createWindow = () => {
  app.file_list=[]
  app.file_number=0
  app.lastfile=''
  const win = new BrowserWindow({
    width: 1024,
    height: 880,
    minWidth: 1024,
    minHeight: 880,
    webPreferences: {
      nodeIntegration: true,
      preload: path.join(__dirname, 'preload.js')
    }
  })
  app.window=win
  app.window.removeMenu()
  app.window.loadFile('index.html')
  app.status=app.window.webContents
  const page = new BrowserView({
    webPreferences: {
      nodeIntegration: false,
      preload: path.join(__dirname, 'preload.js')
    }
  })
  page.setBounds({ x: 0, y: 57, width: 1024, height: 823 })
  page.setAutoResize({ vertical: true, horizontal: true })
  app.pageview=page
  app.window.addBrowserView(app.pageview)
  app.window.on('resize',() => {
    setTimeout(() => {
      var rect=page.getBounds()
      if(rect.y!=57){
        rect.y=57
        page.setBounds(rect)
      }
    }, 0)
  })
  app.web=page.webContents
  ipcMain.on('message', (event, { message }) => {
    var url=app.web.getURL()
    switch(message[0]){
      case 'reload-page':
        if(app.file_list.length!=0) break
        if(app.file_list.length==0) app.web.reload()
        break
      case 'getfileslist':
        if(app.file_list.length!=0) break
        if(!(url.includes('/prt0/'))) break
        app.file_list=[]
        app.file_number=0
        getfileslist()
        break
      case 'getallfileslist':
        if(app.file_list.length!=0) break
        if(!(url.includes('lk.spbexp.ru/Zeg/Zegmain')||(url.includes('lk.spbexp.ru/SF/')&&url.includes('/prt0/')))) break
        app.file_list=[]
        app.file_number=0
        getallfileslist()
        break
      case 'progress':
        set_status(`получение списка файлов для скачивания (получено ${message[1]} ссылок)`)
        break
      case 'cancel':
        app.file_list=[]
        app.file_number=0
        app.web.reload()
        set_status("операция отменена!")
        break
      case 'error':
        app.file_list=[]
        app.file_number=0
        app.web.reload()
        set_status("ошибка при получении списка файлов для скачивания!")
        break
      case 'success':
        try{
          if(message[1].length){
            var flist=message[1]
            for(let i=0;i<flist.length;i++){
              var p=path.join(app.basepath,flist[i][0],flist[i][1])
              fs.mkdir(p, { recursive: true }, (err) => { });
              flist[i].push(path.join(p,flist[i][2]))
              app.file_list.push(flist[i])
            }
          }
        }catch{
          app.file_list=[]
          app.file_number=0
          app.web.reload()
          set_status("ошибка при получении списка файлов для скачивания!")
        }
        download_files()
        break
      }
  })
  app.basepath=path.join(app.getAppPath(),'out')
  fs.mkdir(app.basepath, { recursive: true }, (err) => { });
  //app.web.openDevTools()
  app.web.once('did-finish-load',() => {
    find_login_form()
  });
  app.busy=`
    window.process_canceled=false;
    function errlog(error){
      window.electron.sendMessage({ message: ['error',error] })
    };
    function success(file_links){
      window.electron.sendMessage({ message: ['success',file_links] })
    };
    function progress(file_links){
      window.electron.sendMessage({ message: ['progress',file_links.length] })
    };
    async function cancel(){
      window.electron.sendMessage({ message: ['cancel',''] })
    };
    function pd_replace(partition){
      switch(partition){
        case 'ProjectDocuments': return 'ПД';
        case 'RIIDocuments': return 'РИИ';
        case 'SmetaDocuments': return 'СД';
        case 'IrdDocuments': return 'ИРД';
      };
    };
    function sec_replace(section){
      return section.trim().replaceAll('"','_').trim().replaceAll(':','_').slice(0,64).trim();
    };
    async function get_sig_links_details(file_links,details_links,partitions){
      if(window.process_canceled) return;
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
      if(window.process_canceled) return;
      for(const d of data.Data){
        file_links.push([pd_replace(partition),sec_replace(section),d['Nazvanie'],
          ''.concat('https://lk.spbexp.ru/File/GetFile/',d['IDRow']),d['sDateTo'],d['Number'],d['sMD5']]);
        progress(file_links);
        details_links.push([partition,section,''.concat('https://lk.spbexp.ru/SF/FileCspViewer/',d['IDRow'])]);
      };
      if(links.length) get_pd_links_details(links,file_links,details_links,partitions);
      else get_sig_links_details(file_links,details_links,partitions);
    };
    async function get_pd_links_details(links,file_links,details_links,partitions){
      if(window.process_canceled) return;
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
      cancel()
    };
    class ProgressRing extends HTMLElement{
      constructor(){
        super();
        const stroke=this.getAttribute('stroke');
        const radius=this.getAttribute('radius');
        const normalizedRadius=radius-stroke*2;
        this._circumference=normalizedRadius*2*Math.PI;
        this._root=this.attachShadow({mode:'open'});
        this._root.innerHTML=\`
          <svg height="\${radius*2}" width="\${radius*2}">
            <circle
              class="ring"
              stroke="#3c3b3a"
              stroke-width="\${stroke*2}"
              stroke-opacity="0.5"
              fill="transparent"
              r="\${normalizedRadius}"
              cx="\${radius}"
              cy="\${radius}"
              shape-rendering="geometricPrecision"
            />
            <circle
              class="ring"
              stroke="#c8c5c3"
              stroke-dasharray="\${this._circumference} \${this._circumference}"
              style="stroke-dashoffset:\${this._circumference}"
              stroke-width="\${stroke}"
              fill="transparent"
              r="\${normalizedRadius}"
              cx="\${radius}"
              cy="\${radius}"
              shape-rendering="geometricPrecision"
            />
            <circle
              class="button"
              stroke="#191919"
              stroke-width="1"
              fill="#f44336"
              r="\${normalizedRadius-stroke}"
              cx="\${radius}"
              cy="\${radius}"
              shape-rendering="geometricPrecision"
              onclick=button_click()
            />
            <text class="txt" x="50%" y="52%" text-rendering="geometricPrecision">STOP</text>
            <circle
              class="ring"
              stroke="#000000"
              stroke-width="1"
              stroke-opacity="0.5"
              fill="transparent"
              r="\${normalizedRadius+8}"
              cx="\${radius}"
              cy="\${radius}"
              shape-rendering="geometricPrecision"
            />
          </svg>
          <style>
            .ring {
              transition: stroke-dashoffset 0.35s;
              transform: rotate(-90deg);
              transform-origin: 50% 50%;
              pointer-events: none;
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
        \`;
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
      window.scrollTo(0,0);
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
      circle.innerHTML=\`<progress-ring stroke="8" radius="88" progress="0"></progress-ring>\`
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
  `
  function download_error(filename){
    app.file_list=[]
    app.file_number=0
    app.web.reload()
    filename=filename[2]
    set_status(`ошибка скачивания файла ("${filename}")!`)
  }
  app.web.session.on('will-download', (event, item, webContents) => {
    if(app.file_list.length==0){
      item.cancel()
      return;
    }
    var tmp=app.file_list[app.file_list.length-1]
    item.setSavePath(tmp[tmp.length-1])
    item.on('updated', (event, state) => {
      if (state === 'interrupted') {
        download_error(tmp)
      } else if (state === 'progressing') {
        if (item.isPaused()) {
          download_error(tmp)
        }
      }
    })
    item.once('done', (event, state) => {
      if (state === 'completed') {
        if(tmp.length>5){
          try{
            getChecksum(tmp[tmp.length-1])
              .then(checksum => {
                if(checksum.toUpperCase()!=tmp[6].trim()){
                  download_error(tmp)
                }
              })
              .catch(err => download_error(tmp));
            let t=tmp[4].trim().split(/[\.:\ ]+/)
            for(let i=0;i<t.length;i++){
              t[i]=parseInt(t[i],10)
            }
            t.push(parseInt(tmp[5],10)%60)
            let ctime=new Date(t[2],t[1],t[0],t[3],t[4],t[5])
            fs.utimesSync(tmp[tmp.length-1],ctime,ctime)
          }catch{}
        }
        app.file_list.pop()
        if(app.file_list.length){
          download_files()
        }
        else{
          set_status("")
          app.web.reload()
        }
      } else {
        download_error(tmp)
      }
    })
  })

  app.web.loadURL('https://lk.spbexp.ru')
}
function download_files(){
  if(app.file_list.length==0) return;
  if(app.file_number==0) app.file_number=app.file_list.length
  var tmp=app.file_list[app.file_list.length-1]
  if(fs.existsSync(tmp[tmp.length-1])){
    try{
      fs.rmSync(tmp[tmp.length-1])
    }catch{}
  }
  set_status(`скачивание файла \"${tmp[2]}\" (${app.file_number-app.file_list.length+1} из ${app.file_number})`)
  app.web.downloadURL(tmp[3])
}
function read_login_data(){
  let username=''
  let password=''
  try{
    fs.readFileSync(path.join(app.getAppPath(),'login')).toString().split(/\r?\n/).forEach( (line) => {
      if(username==='') username=line.trim()
      else if(password==='') password=line.trim()
    })
  }
  catch{}
  return [username,password]
}
function find_login_form(){
  var [username,password] = read_login_data()
  var code=`
    function find_login_form(){
      var v=document.querySelector('input[id=Login]');
      if(v!=null){
        v.value="${username}";
        v=document.querySelector('input[id=Password]');
        if(v!=null){
          v.value="${password}";
          v=document.querySelector('button[type=submit]');
          if(v!=null){
            v.click();
            return 'ok';
          };
        };
      };
      return '';
    };
    find_login_form();
  `
  app.web.executeJavaScript(code).then(() => {
    app.web.once('did-finish-load',() => {
      app.web.loadURL('https://lk.spbexp.ru/SF/Zayava/')
    });
  })
}
app.whenReady().then(() => {
  createWindow()
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
function getfileslist(){
  var code=app.busy+`
    function get_sig_links_details_parse(file_links,details_links,partitions,partition,section,data){
      if(window.process_canceled) return;
      var parser=new DOMParser();
      var doc=parser.parseFromString(data,'text/html');
      var req=doc.querySelectorAll('a[href*=\"GetFile\"]');
      for(const e of req){
        if(e.text.includes('.sig')){
          file_links.push([pd_replace(partition),sec_replace(section),e.text,e.href]);
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
      get_pd_links_details(links,file_links,details_links,[]);
    };
    start_parser();
  `
  app.web.executeJavaScript(code)
}
function getallfileslist(){
  var code=app.busy+`
    function get_sig_links_details_parse(file_links,details_links,partitions,partition,section,data){
      if(window.process_canceled) return;
      var parser=new DOMParser();
      var doc=parser.parseFromString(data,'text/html');
      var req=doc.querySelectorAll('a[href*=\"GetFile\"]');
      for(const e of req){
        if(e.text.includes('.sig')){
          file_links.push([pd_replace(partition),sec_replace(section),e.text,e.href]);
          progress(file_links);
        };
      };
      if(details_links.length) get_sig_links_details(file_links,details_links,partitions);
      else get_file_links(file_links,details_links,partitions);
    };
    function get_pd_links_parse(path,file_links,details_links,partitions,data){
      if(window.process_canceled) return;
      var links=[];
      if(data.Total===0){
        if(partitions.length) get_pd_links(partitions.pop(),file_links,details_links,partitions);
        else success(file_links);
        return;
      };
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
      if(window.process_canceled) return;
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
      if(window.process_canceled) return;
      if(partitions.length) get_pd_links(partitions.pop(),file_links,details_links,partitions);
      else success(file_links);
    };
    function start_parser(){
      var file_links=[];
      var details_links=[];
      var partitions=['ProjectDocuments','RIIDocuments','SmetaDocuments','IrdDocuments'];
      get_file_links(file_links,details_links,partitions);
    };
    start_parser();
  `
  app.web.executeJavaScript(code)
}