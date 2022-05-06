const { contextBridge, ipcRenderer } = require('electron')
contextBridge.exposeInMainWorld('electron', {
    sendMessage: (body) => ipcRenderer.send('message', body),
    onResponse: (listener) => ipcRenderer.on('response', (event, resp) => listener(resp)
  )}
);
