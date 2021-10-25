## Короткие полезности.
---  
### Работа с сетью.  
---  
#### Запуск простого ("одноразового") web-сервера для текущей директории.  
_Требования (зависимости):_ [python](https://www.python.org/)  
- python 2.x: ```python -m SimpleHTTPServer 9000```  
- python 3.x: ```python -m http.server 9000``` или ```python -m http.server --bind <локальный IP адрес привязки> 9000```  

_<p align="justify">Примечание: в качестве параметра указывается номер открываемого порта; полезно, когда требуется передать файлы по сети без дополнительных настроек и сервисов.</p>_  
#### Перенаправление IPv4 TCP портов в Windows 10.  
- перенаправление: ```netsh interface portproxy add v4tov4 listenaddress=localaddress listenport=localport connectaddress=destaddress connectport=destport```  
_- где localaddress - локальный IP адрес, localport - локальный порт, destaddress - удалённый (целевой) IP адрес, destport - удалённый (целевой) порт;_  
- просмотр правил перенаправления: ```netsh interface portproxy show all```  
- сброс всех правил перенаправления: ```netsh interface portproxy reset```  
- выборочное удаление правил перенаправления: ```netsh interface portproxy delete v4tov4 listenport=localport listenaddress=localaddress```  
_- где localaddress - локальный IP адрес, localport - локальный порт;_  

_<p align="justify">Примечания: все команды должны выполняться с правами администратора; брандмауэр Windows должен быть выключен или в него должны быть добавлены соответствующие разрешающие правила; хотя правила перенаправления и сохраняются после перезагрузки, но для их работы после перезагрузки иногда требуется перезапуск службы iphlpsvc ("Вспомогательная служба IP") или выполнение сценария со сбросом и повторным внесением правил (к примеру, это можно сделать через штатный планировщик заданий).</p>_  
#### Конфигурация bond-интерфейса без поддержки со стороны коммутатора (Linux) (пример).  
<details><summary>Конфигурация</summary><pre><code>
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
auto bond0
iface bond0 inet manual
    slaves eno1 eno2
    bond-mode balance-alb
    bond-miimon 100
    bond-downdelay 200
    bond-updelay 200
auto xenbr0
iface xenbr0 inet static
        address 192.168.1.8/24
        gateway 192.168.0.1
        dns-nameservers 192.168.0.1 8.8.8.8 8.8.4.4 77.88.8.8 77.88.8.1 1.1.1.1
        bridge_ports bond0
        bridge_stp off
        bridge_waitport 0
        bridge_fd 0
</code></pre></details>  

_Примечание: настройка для использования в режиме моста с гипервизором Xen; файл "/etc/network/interfaces"._  
#### Команды OpenVPN, которые стоит помнить (см. man) (Linux).  
- инициализация (генерация ключей)  
```
easyrsa init-pki
easyrsa gen-dh
easyrsa gen-req <имя_сервера> nopass
easyrsa sign-req server <имя_сервера>
openvpn --genkey --secret ta.key
```  
- генерация файла отозванных ключей (по умолчанию данную процедуру требуется повторять раз в 180 дней)  
```
easyrsa gen-crl
```  
- добавление пользователя  
```
easyrsa gen-req <имя_конфигурации_пользователя> nopass
easyrsa sign-req client <имя_конфигурации_пользователя>
```  
- отзыв сертификата пользователя  
```
easyrsa revoke <имя_конфигурации_пользователя>
easyrsa gen-crl
```  
- для временного игнорирования просроченных пользовательских сертификатов в среде Linux можно использовать связку из утилиты ```faketime``` и запуска openvpn через сценарий rc.local  
_Пример:_ ```/usr/bin/faketime '2020-12-12 12:12:12' /etc/init.d/openvpn start```
#### Пример (шаблон) конфигурации OpenVPN сервера (Linux).  
<details><summary>Конфигурация</summary><pre><code>
ignore-unknown-option ncp-ciphers
port 10788
proto tcp
#multihome
#local 192.168.1.1
dev tun
user nobody
group nogroup
ifconfig-pool-persist ipp-tcp.txt
server 10.8.3.0 255.255.255.0
#маршрутизация с другим VPN сервером на этом же хосте
push "route 10.8.2.0 255.255.255.0"
topology subnet
max-clients 2000
ping 10
ping-restart 80
push "ping 10"
push "ping-restart 60"
persist-tun
persist-key
cipher AES-128-CBC
ncp-ciphers AES-128-GCM:AES-128-CBC
auth SHA1
status-version 2
script-security 2
sndbuf 393216
rcvbuf 393216
reneg-sec 2592000
hash-size 1024 1024
max-routes-per-client 1000
verb 2
mute 3
client-to-client
replay-window 128
comp-lzo no
push "comp-lzo no"
status      /var/log/openvpn/openvpn-tcp-status.log
log         /var/log/openvpn/openvpn-tcp.log
log-append  /var/log/openvpn/openvpn-tcp.log
crl-verify /etc/openvpn/keys/crl.pem
&lt;ca&gt;
-----BEGIN CERTIFICATE-----
# ключ (ca)
-----END CERTIFICATE-----
&lt;/ca&gt;
key-direction 0
&lt;tls-auth&gt;
-----BEGIN OpenVPN Static key V1-----
# ключ (ta)
-----END OpenVPN Static key V1-----
&lt;/tls-auth&gt;
&lt;cert&gt;
-----BEGIN CERTIFICATE-----
# ключ (cert)
-----END CERTIFICATE-----
&lt;/cert&gt;
&lt;key&gt;
-----BEGIN PRIVATE KEY-----
# ключ (key)
-----END PRIVATE KEY-----
&lt;/key&gt;
&lt;dh&gt;
-----BEGIN DH PARAMETERS-----
# ключ (dh)
-----END DH PARAMETERS-----
&lt;/dh&gt;
</code></pre></details>  

#### Пример (шаблон) конфигурации OpenVPN клиента (conf/ovpn).  
<details><summary>Конфигурация</summary><pre><code>
client
dev tun
dev-type tun
remote 192.168.1.1 10788 tcp
nobind
persist-tun
cipher AES-128-CBC
auth SHA1
verb 2
mute 3
push-peer-info
ping 10
ping-restart 60
hand-window 70
server-poll-timeout 4
reneg-sec 2592000
sndbuf 393216
rcvbuf 393216
max-routes 1000
remote-cert-tls server
comp-lzo no
key-direction 1
&lt;ca&gt;
# ключ (ca)
&lt;/ca&gt;
&lt;tls-auth&gt;
# ключ (ta)
&lt;/tls-auth&gt;
&lt;cert&gt;
# ключ (cert)
&lt;/cert&gt;
&lt;key&gt;
# клиентский ключ (key)
&lt;/key&gt;
</code></pre></details>  
  
#### Пример (шаблон) конфигурации сервиса stunnel 4 для использования в связке с OpenVPN (Linux).  
<details><summary>Конфигурация</summary><pre><code>
chroot = /var/lib/stunnel4/
setuid = stunnel4
setgid = stunnel4
pid    = /stunnel4.pid
output = /stunnel.log
debug  = info
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[openvpn]
accept     = 443
connect    = 1194
CApath     = certs
CRLpath    = crls
cert       = /etc/stunnel/servercert.pem
key        = /etc/stunnel/serverkey.pem
verify     = 3
verifyPeer = yes
options    = NO_SSLv2
options    = NO_SSLv3
;перенаправление соединения в случае ошибки "рукопожатия"
redirect   = &lt;имя_сервера_для_перенаправления&gt;:80
</code></pre></details>  

#### Пример (шаблон) конфигурации клиентского сервиса stunnel 4 для использования в связке с OpenVPN (Linux).  
<details><summary>Конфигурация</summary><pre><code>
debug   = info
output  = /var/log/stunnel4/stunnel.log
pid     = /var/run/stunnel4.pid

[vpn]
client     = yes
accept     = 127.0.0.1:1194
connect    = &lt;имя_сервера_stunnel_openvpn&gt;:443
options    = -NO_SSLv3
cert       = /etc/stunnel/clientcert.pem
key        = /etc/stunnel/clientkey.pem
CAfile     = /etc/stunnel/servercert.pem
verify     = 3
verifyPeer = yes
</code></pre></details>  

#### Команды для использования совместно со stunnel 4, которые стоит помнить (см. man) (Linux). 
- генерация серверных ключей  
```openssl req -nodes -new -days 3650 -newkey rsa:1024 -x509 -keyout serverkey.pem -out servercert.pem```  
- генерация клиентских ключей (аналогично серверным)  
```openssl req -nodes -new -days 3650 -newkey rsa:1024 -x509 -keyout clientkey.pem -out clientcert.pem```  
- создание хэш-ссылок на клиентские ключи
  <details><summary>Код</summary><pre><code>
  #!/bin/sh
  #
  # usage: certlink.sh filename [filename ...]
  for CERTFILE in "$@"; do
    # Убедиться, что файл существует и это сертификат
    test -f "$CERTFILE" || continue
    HASH=$(openssl x509 -noout -hash -in "$CERTFILE")
    test -n "$HASH" || continue
    # использовать для ссылки наименьший итератор
    for ITER in 0 1 2 3 4 5 6 7 8 9; do
      test -f "${HASH}.${ITER}" && continue
      ln -s "$CERTFILE" "${HASH}.${ITER}"
      test -L "${HASH}.${ITER}" && break
    done
  done
  </code></pre></details>

#### Вариант сценария добавления пользователя Samba 3 (smbuseradd) (Linux).  
<details><summary>Код</summary><pre><code>
#!/bin/bash
if test $1
then
  useradd -M -s /sbin/nologin -p xxxxxxxx -g sambausers -d /mnt/storage/local.hive/exchange $1
  rm -f /opt/chroot.samba/etc/passwd ; ln /etc/passwd /opt/chroot.samba/etc/passwd
  rm -f /opt/chroot.samba/etc/shadow ; ln /etc/shadow /opt/chroot.samba/etc/shadow
  rm -f /opt/chroot.samba/etc/group ; ln /etc/group /opt/chroot.samba/etc/group
  rm -f /opt/chroot.samba/etc/gshadow ; ln /etc/gshadow /opt/chroot.samba/etc/gshadow
  echo $1:$2 | chpasswd
  chroot /opt/chroot.samba /usr/local/bin/smbuseradd $1 $2
  xfs_quota -x -c "limit -u bsoft=64G bhard=64G $1" /mnt/storage
fi
</code></pre></details>  

_Примечание: используется chroot и квоты xfs, аутентификация только по имени пользователя._  
#### Вариант сценария смены пароля пользователя Samba 3 (smbpass) (Linux).  
<details><summary>Код</summary><pre><code>
#!/bin/bash
if test $1
then
  echo $1:$2 | chpasswd
  chroot /opt/chroot.samba /usr/local/bin/smbpass $1 $2
fi
</code></pre></details>  

#### Вариант описания сервиса systemd для запуска Samba 3 из chroot окружения (Linux).  
<details><summary>Код</summary><pre><code>
[Unit]
  Description=chroot()ed Samba
[Service]
  Type=forking
  RootDirectory=/opt/chroot.samba
  ExecStart=/etc/init.d/samba start
  ExecReload=/etc/init.d/samba restart
  ExecStop=/etc/init.d/samba stop
[Install]
  WantedBy=multi-user.target
</code></pre></details>  

#### Вариант простой конфигурации Samba 4 (Linux).  
<details><summary>Конфигурация</summary><pre><code>
[global]
   workgroup = SPB
   netbios name = BackupSrv
   server string = BackupSrv
   dns proxy = no
   hosts allow = 192.168.10. 127.
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   ldap ssl = No
   security = user
   passdb backend = smbpasswd
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   invalid users = root
   guest account = nobody
   map to guest = bad user
   dos charset = 866
   unix charset = utf8
   unix extensions = no
   ntlm auth = yes
   username map = /etc/samba/user.map
[backup]
   comment = Backup
   path = /mnt/share/backup
   valid users = @smbusers
   force group = smbusers
   guest ok = no
   guest only = no
   read only = no
   browseable = yes
   fake oplocks = no
   create mask = 0666
   directory mask = 0777
</code></pre></details>  

#### Пример дополнительной блокировки потенциально опасного содержимого в почтовом сервисе Exim (Linux).  
_Требования (зависимости):_ python, ripole, 7z, unace, unrar, сценарий [checkx.py](https://github.com/asimba/uselets/tree/main/tools/checkx)  
_Инструкция: в конфигурацию Exim требуется внести изменения нижеследующего вида (предварительно разместив сценарий в директории "/usr/local/bin")_  
<details><summary>Конфигурация</summary><pre><code>
---------------------------------------------------------------------
#exim4.conf
---------------------------------------------------------------------
system_filter = /etc/exim4/exim.filter
...
acl_check_mime:
#  deny message = Potentially type mismatch. - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename bin \"$mime_filename\"}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .zip). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.zip$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename zip}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .gz). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.gz$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename gz}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .7z). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.7z$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename 7z}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .rar). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.rar$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename rar}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .ace). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.ace$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename ace}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .docx). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.docx$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename docx}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .doc). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.doc$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename doc}}}\
                             {\N(?i)stop\n\N}}
#  deny message = Potentially executable content (in .pdf). - blocked!
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.pdf$\N}}
       decode = default
       condition = ${if match{${run{/usr/local/bin/checkx.py \
                                    $mime_decoded_filename pdf}}}\
                             {\N(?i)stop\n\N}}
  warn message = X-SS-Suspicious-Flag: YES
       condition = ${if match{$mime_filename}{\N(?i)\.(bat|js|pif|cd|com|exe|lnk|reg|vbs|vbe|jse|msi|ocx|dll|sys|cab|hta|ace|gz|z|jar|xz|ps1|bz2|lzh|uue|001|zipx|arj|iso|appx|appxbundle|msix|msixbundle|ade|mde)$\N}}
---------------------------------------------------------------------
#exim.filter
---------------------------------------------------------------------
if $h_X-SS-Suspicious-Flag: contains "YES" then
  deliver suspicious@suspicious@&lt;имя_сервера&gt;
endif
</code></pre></details>  

#### Изменение профиля локальной сети (частная, общественная) (Windows 10).  
_Требования (зависимости):_ Windows PowerShell  
```Get-NetConnectionProfile``` изпользуется для перечисления текущих профилей  
```Set-NetConnectionProfile -Name "<Название Вашей сети>" -NetworkCategory <Private|Public>``` изпользуется для смены профиля  
#### Синхронизация времени с удалённым сервером из командной строки (Windows).  
```net time \\<сервер> /set /y```  
_Пример:_ ```net time \\192.168.0.1 /set /y```  
#### Блокирование доступа в интернет для всех программ, при сохранении доступа в локальную сеть (Windows).  
_Требования (зависимости):_ Windows Firewall, PowerShell  
```New-NetFirewallRule -DisplayName "block-internet" -Direction Outbound -RemoteAddress Internet -Action Block```  
#### Отправка почтового сообщения администратору системы при успешном входе в систему по протоколу SSH (Linux).  
_Инструкция: в директории "/etc/profile.d/" требуется разместить исполняемый файл сценария с инжеследующим содержанием:_  
<details><summary>Код</summary><pre><code>
if [ -n "$SSH_CLIENT" ]; then
    TEXT="$(date): ssh login to ${USER}@$(hostname -f)"
    TEXT="$TEXT from $(echo $SSH_CLIENT|awk '{print $1}')"
    echo $TEXT|mail -s "ssh login (hive)" root
fi
</code></pre></details>  

#### Синхронизация содержимого локальной директории с директорией расположенной на удалённом сервере по протоколу SSH (Linux) (пример).  
_Требования (зависимости):_ rsync, предварительная генерация ключа "id_rsa" на принимающей стороне, обновление файла "authorized_keys" на отдающей стороне и файла "known_hosts" на принимающей стороне.  
<details><summary>Код</summary><pre><code>
#!/bin/bash
if [ -f /var/tmp/remote-dump ]; then
    echo "Still running..."
    exit 0
fi
touch /var/tmp/remote-dump
bpath=/etc/backup.keys
spath=/mnt/backup/system.images/
sshcm='ssh -Tx24 -i '$bpath'/id_rsa'
rsopt='-aHEAXxz4W --del --numeric-ids --stats -e '
rscmd='rsync '$rsopt"'"$sshcm"'"
bserv=root@10.8.0.42
eval $rscmd $bserv:$spath /mnt/backups/server.pool/
rm -f /var/tmp/remote-dump
</code></pre></details>  
  
_<p align="justify">Примечание: "bpath" - параметр указывает на путь к директории, в которой хранятся ключ и исполняемый скрипт; "spath" - параметр указывает на путь к исходной директории на удалённом сервере; "bserv" - IP-адрес удалённого сервера; "/mnt/backups/server.pool/" - локальная директория ("принимающая").</p>_  
#### Разрешение доступа в сеть (NAT) в CentOS 7.  
```firewall-cmd --zone=public --add-masquerade --permanent```  
#### Разрешение доступа в сеть (NAT) с использованием iptables (Debian Linux).  
<details><summary>Команды</summary><pre><code>
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
#ens33 - интерфейс локальной сети
iptables -A INPUT -i ens33 -j ACCEPT
iptables -A OUTPUT -o ens33 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
#ens32 - интерфейс внешней сети
iptables -A INPUT -i ens32 -j ACCEPT
iptables -A OUTPUT -o ens32 -j ACCEPT
iptables -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A FORWARD -i ens33 -o ens32 -j ACCEPT
iptables -A FORWARD -i ens32 -o ens33 -j REJECT
iptables -t nat -A POSTROUTING -o ens32 -j MASQUERADE
</code></pre></details>  

---  
### Работа с дисками/разделами/файловыми системами.  
---  
#### Команды LVM, которые стоит помнить (см. man) (Linux).  
- pvs , pvcreate , pvremove  
- vgs , vgcreate , vgremove  
- lvs , lvcreate , lvremove, lvextend  
- vgcfgbackup -f ./lvm-structure-%s.txt
- vgcfgrestore -f ... {VG}
#### Создание архивированного образа файловой системы EXT3/EXT4, расположенной на томе LVM (Linux).  
_Требования (зависимости):_ xz-utils, dump  
<details><summary>Код</summary><pre><code>
#!/bin/bash
backup_path=./
vg_group=/dev/system
lvm_volume=host-root
lvremove -f $vg_group/$lvm_volume-snap
lvcreate -L4G -s -n $lvm_volume-snap $vg_group/$lvm_volume
fsck -yvf $vg_group/$lvm_volume-snap
dump -0uf $backup_path/$lvm_volume.dump $vg_group/$lvm_volume-snap
lvremove -f $vg_group/$lvm_volume-snap
xz -9 $backup_path/$lvm_volume.dump
</code></pre></details>  

_<p align="justify">Примечание: "backup_path" - директория для хранения архива, "vg_group" - группа томов, "lvm_volume" - наименование архивируемого тома. Восстановление осуществляется аналогичным образом при помощи комады "restore".</p>_  
#### Создание архивированного образа тома LVM для последующего дифференциального резервирования (Linux).  
_Требования (зависимости):_ rdiff, lz4  
<details><summary>Код</summary><pre><code>
#!/bin/bash
backup_path=./system.images
vg_group=/dev/system
lvm_volume=srv1c-disk
if [ -f $backup_path/$lvm_volume ]; then
   cat  $backup_path/$lvm_volume | lz4 -z -1 -BD > $backup_path/$lvm_volume.before-`date +%Y-%m-%d`.lz4
   rm -f $backup_path/$lvm_volume
fi
if [ -f $backup_path/$lvm_volume.signature ]; then
   cat  $backup_path/$lvm_volume.signature | lz4 -z -1 -BD > $backup_path/$lvm_volume.before-`date +%Y-%m-%d`.signature.lz4
   rm -f $backup_path/$lvm_volume.signature
fi
lvremove -f $vg_group/$lvm_volume-snap
lvcreate -L16G -s -n $lvm_volume-snap $vg_group/$lvm_volume
dd if=$vg_group/$lvm_volume-snap of=$backup_path/$lvm_volume bs=64M
rdiff -b 262144 -I 67108864 -O 67108864 -- signature $backup_path/$lvm_volume $backup_path/$lvm_volume.signature
lvremove -f $vg_group/$lvm_volume-snap
</code></pre></details>  

_<p align="justify">Примечание: "backup_path" - директория для хранения архива, "vg_group" - группа томов, "lvm_volume" - наименование архивируемого тома. Способ подходит для разделов фиртуальных машин (параметры блоков "rdiff" подобраны для тома размером 256 GiB).</p>_  
#### Создание дифференциальной резервной копии для архивированного образа тома LVM (см.выше) (Linux).  
_Требования (зависимости):_ rdiff, lz4  
<details><summary>Код</summary><pre><code>
#!/bin/bash
backup_path=./system.images
vg_group=/dev/system
lvm_volume=srv1c-disk
# удаление дельта файлов старше 60 дней
# find $backup_path -name "*.delta.*" -type f -mtime +60 -exec rm -f {} \;
lvremove -f $vg_group/$lvm_volume-snap
lvcreate -L16G -s -n $lvm_volume-snap $vg_group/$lvm_volume
rdiff -b 262144 -I 67108864 -O 67108864 -- delta $backup_path/$lvm_volume.signature $vg_group/$lvm_volume-snap - | lz4 -z -1 -BD > $backup_path/$lvm_volume.`date +%Y-%m-%d-%H:%M:%S`.delta.lz4
lvremove -f $vg_group/$lvm_volume-snap
</code></pre></details>  

_<p align="justify">Примечание: "backup_path" - директория для хранения архива, "vg_group" - группа томов, "lvm_volume" - наименование архивируемого тома. Способ подходит для разделов фиртуальных машин (параметры блоков "rdiff" подобраны для тома размером 256 GiB).</p>_  
#### Восстановление дифференциальной резервной копии архивированного образа тома LVM (см.выше) (Linux).  
_Требования (зависимости):_ rdiff, lz4  
<details><summary>Код</summary><pre><code>
#!/bin/bash
backup_path=./system.images
lvm_volume=srv1c-disk
time_stamp=2019-10-02-14:50:18
lz4cat $backup_path/$lvm_volume.$time_stamp.delta.lz4 | rdiff -b 262144 -I 67108864 -O 67108864 -- patch $backup_path/$lvm_volume - $backup_path/$lvm_volume.new
dd of=$vg_group/$lvm_volume if=$backup_path/$lvm_volume.new bs=64M
</code></pre></details>  

_Примечание: "backup_path" - директория хранения архива, "lvm_volume" - наименование тома, "time_stamp" - метка времени восстанавливаемой копии._  
#### Пример конфигурации iSCSI-цели (служба tgt) (Linux).  
<details><summary>/etc/tgt/conf.d/iscsi-base.conf</summary><pre><code>
&lt;target iqn.2020-12.local:lun1&gt;
backing-store /dev/xvda3
initiator-address 192.168.10.1
incominguser iscsi-user q7n8TNnzLsv7
outgoinguser iscsi-target vUD6YXvz7Klb
&lt;/target&gt;
</code></pre></details>  

#### Пример (шаблон) сценария резервного копирования файлов с использованием службы Volume Shadow Copy (Windows 10).  
_Требования (зависимости):_ [7-Zip Extra](https://www.7-zip.org/a/7z1900-extra.7z)  
<details><summary>backupcycle.cmd</summary><pre><code>
@echo off

cd /d "%~dp0"

set drv=C:\
set src=\Windows\System32\config
set pfx=registry

set tdr=%drv%temp
set mnt=%tdr%\mount
set bak=%tdr%\backup
set log=%~dp0backup.log

rem echo %drv%
rem echo %src%
rem echo %tdr%
rem echo %mnt%
rem echo %bak%
rem echo %log%

rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
mkdir %bak%
rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

echo ================================================================================>>%log%
echo %date% %time% : Starting backup task.>>%log%
echo ================================================================================>>%log%
echo %date% %time% : Removing the old mount point.>>%log%
echo -------------------------------------------------------------------------------->>%log%
rmdir %mnt% >nul 2>&1
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Creating the temporary backup directory.>>%log%
echo -------------------------------------------------------------------------------->>%log%
for /f "tokens=*" %%c in ('date /t') do (set dt=%%c)
for /f "tokens=*" %%c in ('time /t') do (set tm=%%c)
set tmp=%dt%%tm%
set datestr=%tmp:/=-%
set datestr=%datestr: =-%
set datestr=%datestr::=-%
set datestr=%datestr:.=-%
set bakname=%pfx%-backup-%datestr%
mkdir %bak%\%bakname% >>%log% 2>&1
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Deleting all of the specified volume's shadow copies.>>%log%
echo -------------------------------------------------------------------------------->>%log%
vssadmin.exe delete shadows /for=%drv% /all /quiet >>%log% 2>&1
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Creating new shadow copy.>>%log%
echo -------------------------------------------------------------------------------->>%log%
wmic shadowcopy call create Volume='^"%drv%\^"' >>%log% 2>&1
setlocal enabledelayedexpansion
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Searching the name of the new shadow copy.>>%log%
echo -------------------------------------------------------------------------------->>%log%
vssadmin.exe list shadows /for=%drv% >>%log% 2>&1
for /F "delims=" %%c in ('vssadmin.exe list shadows /for^=%drv% ^| findstr /c:GLOBALROOT') do set sw=%%c
set "find=* \\?\"
call set sw=%%sw:!find!=\\?\%%
mklink /D %mnt% %sw%\ >>%log% 2>&1
endlocal
set src=%src:"=%
set mnt=%mnt:"=%
set src=%mnt%%src%
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Copying requested source files.>>%log%
echo -------------------------------------------------------------------------------->>%log%
robocopy %src% %bak%\%bakname% /e /copyall /xj /xjd /xjf /ns /nc /nfl /ndl /np >>%log% 2>&1
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Packing the temporary backup directory.>>%log%
echo -------------------------------------------------------------------------------->>%log%
7za a -t7z -ms=on -m0=LZMA2 -mx9 -mmt=4 -scsUTF-8 -ssc "%bak%\%bakname%.7z" "%bak%\%bakname%"
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Removing the mount point.>>%log%
echo -------------------------------------------------------------------------------->>%log%
rmdir %mnt% >>%log% 2>&1
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Removing the temporary backup directory.>>%log%
echo -------------------------------------------------------------------------------->>%log%
takeown /r /skipsl /f %bak%\%bakname% /d y >nul 2>&1
rd /q /s %bak%\%bakname% >>%log% 2>&1
echo -------------------------------------------------------------------------------->>%log%
echo %date% %time% : Deleting all of the specified volume's shadow copies.>>%log%
echo -------------------------------------------------------------------------------->>%log%
vssadmin.exe delete shadows /for=%drv% /all /quiet >>%log% 2>&1
echo ================================================================================>>%log%
echo %date% %time% : Finished.>>%log%
echo ================================================================================>>%log%

rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
move "%bak%\%bakname%.7z" "%~dp0\%bakname%.7z"
rd /q /s %tdr%
rem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
</code></pre></details>  

#### Очистка журнала USN NTFS из командной строки (Windows).  
```fsutil usn deletejournal /n c:```  
#### Стандартная очистка дисков из командной строки (Windows).  
_Требования (зависимости):_ PowerShell, [cleandisk.ps1](https://github.com/asimba/uselets/tree/main/tools/cleandisk)  
```powershell -ExecutionPolicy Bypass -command "cleandisk.ps1"```  
#### Удаление временных файлов для всех пользователей из командной строки (Windows).  
_Требования (зависимости):_ PowerShell, [cleartemp.ps1](https://github.com/asimba/uselets/tree/main/tools/cleartemp)  
```powershell -ExecutionPolicy Bypass -command "cleartemp.ps1"```  
#### Удаление файлов созданных ранее текущей даты на заданное количество дней из командной строки (Windows).  
```forfiles /P <"Путь к директории для поиска файлов"> /S /M *.<Расширение имён файлов> /D -<Количество дней> /C "cmd /c del /q @path"```  

---  
### Системные операции.  
---  
#### Пример генерации пароля (Linux).  
```cat /dev/urandom|head -c9|base64```  
_Примечание: длину пароля можно менять, задавая параметр \"-с\"._  
#### Очистка кэшей файловых систем и очистка файла/раздела подкачки (Linux).  
<details><summary>Код</summary><pre><code>
#! /bin/sh
sync; echo 1 > /proc/sys/vm/drop_caches
swapoff -a; sudo swapon -a
</code></pre></details>  

#### Команды systemd, которые стоит помнить (см. man) (Linux).  
```
systemctl list-units
systemctl status <имя_службы>
systemctl restart <имя_службы>
systemctl start <имя_службы>
systemctl stop <имя_службы>
systemctl enable <имя_службы>
systemctl disable <имя_службы>
systemctl daemon-reload
journalctl
#journalctl --list-boots равнозначно who -b
```  

_Примечание: см. также файл \"\/etc\/sysctl.d\/\*-sysctl.conf\" (переменные \"vm.swappiness=5\" и \"vm.vfs_cache_pressure=2000\")._  
#### Команды Xen (xl), которые стоит помнить (см. man) (Linux) (примеры).  
- xl create \<config_file\>  
- xl destroy \<Domain\>  
- xl list  
- xl usbctrl-attach master-host version=3 ports=8  
- xl usb-list master-host  
- xl usbdev-attach master-host hostbus=1 hostaddr=3 controller=1 port=1  
- xen-create-image --hostname=example-host --memory=1024mb --vcpus=1 --scsi --size=16G --swap=512mb --lvm=system --ip=192.168.0.2 --gateway=192.168.0.1 --netmask=255.255.255.0 --nameserver="192.168.0.1 8.8.8.8"--nodhcp --pygrub --dist=stretch  
#### Команды Virsh, которые стоит помнить (см. man) (Linux) (примеры).  
- virsh domxml-from-native xen-xl master-host.cfg > master-host.xml
- virsh create master-host.xml  
- virsh define master-host  
- virsh autostart master-host  
- virsh autostart master-host --disable  
- virsh undefine master-host  
- virsh list  
- virsh list --all  
- virsh list --autostart  
- virsh create master-host  
- virsh start master-host  
- virsh shutdown master-host  
#### Генерация случайного MAC-адреса для сетевого интерфейса Xen DomU (Linux).  
_Требования (зависимости):_ [random_mac.py](https://github.com/asimba/uselets/blob/main/tools/xen/random_mac.py)  
```python ./random_mac.py```  
#### Пример конфигурации Xen для паравиртуальной гостевой системы Linux (Linux).  
<details><summary>Конфигурация</summary><pre><code>
name        = 'i-host'
#для генерации uuid можно использовать  dbus-uuidgen
#uuid="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
bootloader = 'pygrub'
vcpus       = '1'
memory      = '1024'
root        = '/dev/xvda2 ro'
disk        = [
                  'phy:/dev/system/i-host-disk,xvda2,w',
                  'phy:/dev/system/i-host-swap,xvda1,w',
                  'phy:/dev/storage/i-base,xvda3,w',
              ]
vif         = [ 'mac=00:16:3e:0a:ab:53,bridge=xenbr0' ]
on_poweroff = 'destroy'
on_reboot   = 'restart'
on_crash    = 'restart'
</code></pre></details>  

#### Пример конфигурации Xen для гостевой системы Windows Server 2008 (Linux).  
<details><summary>Конфигурация</summary><pre><code>
type = 'hvm'
name = 'master-host'
#для генерации uuid можно использовать  dbus-uuidgen
#uuid="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
xen_platform_pci = 1
viridian = 1
memory = 16384
vcpus = 4
maxvcpus = 4
pae=1
nx=1
hap=1
hpet=1
acpi = 1
apic = 1
vif = [ 'mac=00:16:3e:ef:8e:65,ip=192.168.1.1,type=vif,rate=10Gb/s,bridge=xenbr0' ]
disk = ['phy:/dev/system/master-disk,sda,rw']
device_model_version = 'qemu-xen'
boot='c'
hdtype='ahci'
localtime=1
sdl=0
serial='pty'
usbdevice='tablet'
stdvga=1
vga='stdvga'
videoram=32
gfx_passthru=0
vkb=[ 'backend-type=qemu' ]
vnc=1
# IP адрес Dom-0 (host система)
vnclisten='192.168.1.8'
vncdisplay=1
vncpasswd='XXXXXXX'
on_poweroff = 'destroy'
on_reboot = 'restart'
on_crash = 'restart'
</code></pre></details>  

#### Пример конфигурации Xen для гостевой системы Windows Server 2012 R2 (Linux).  
<details><summary>Конфигурация</summary><pre><code>
type = 'hvm'
name = 'srv1c-host'
#для генерации uuid можно использовать  dbus-uuidgen
#uuid="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
xen_platform_pci = 1
viridian = 1
memory = 32768
vcpus = 8
maxvcpus = 8
pae=1
nx=1
hap=1
hpet=1
acpi = 1
apic = 1
vif = [ 'mac=00:16:3e:f0:f5:b8,ip=192.168.1.2,type=vif,rate=10Gb/s,bridge=xenbr1' ]
disk = ['phy:/dev/system/srv1c-disk,hda,rw']
device_model_version = 'qemu-xen'
boot='dc'
hdtype='ide'
localtime=1
sdl=0
serial='pty'
usb=1
usbctrl=['type=devicemodel,version=3,ports=8']
usbdev=['hostbus=1,hostaddr=3,controller=0,port=1',]
usbdevice='tablet'
stdvga=1
vga='stdvga'
videoram=32
gfx_passthru=0
vkb=[ 'backend-type=qemu' ]
vnc=1
# IP адрес Dom-0 (host система)
vnclisten='192.168.1.8'
vncdisplay=2
on_poweroff = 'destroy'
on_reboot = 'restart'
on_crash = 'restart'
</code></pre></details>  

#### Очистка всех журналов событий из командной строки (Windows).  
_Требования (зависимости):_ PowerShell  
```wevtutil el | Foreach-Object {wevtutil cl "$_"}```  
#### Получение информации о материнской плате из командной строки (Windows).  
```wmic baseboard get product,Manufacturer,version,serialnumber```  
#### Комплексное решение: отключение (снижение активности) Windows Defender (Windows 10/11), удаление bloatware, отключение телеметрии и автообновлений Windows 10.  
_Требования (зависимости):_ PowerShell, [w10fixes-binary](https://github.com/asimba/uselets/raw/main/tools/w10fixes.sfx/bin/w10fixes.zip)  
<p align="justify">Потребуется выполнить <b>на свой страх и риск</b> <i>w10fixes.exe</i> из прилагающегося архива, предварительно отключив антивирусную проверку всех типов в "Защитнике Windows" и подтвердив выполнение в открывшемся окне защиты SmartScreen ("Подробнее"->"Выполнить в любом случае"). После утвердительного ответа на запрос об очистке будет выдан запрос "Контроля учётных записей", требуется также ответить утвердительно. После этого система будет трижды перезагружена (причём первый раз в безопасном режиме). Между перезагрузками следует воздержаться от совершения каких-либо действий с компьютером. Рекомендуется после завершения работы программы проверить настройки конфиденциальности.</p>  

_Примечание: сценарий тестировался на Windows 10 21H1 (версии 10.0.19043.1288) и Windows 11 21H2 (версии 10.0.22000.258)._  

#### Обход требований наличия модуля TPM 2.0 и включенного режима SecureBoot во время установки Windows 11.  
На установочном носителе  Windows 10 заменить файл ```install.esd``` на соответствующий ему файл с установочного носителя Windows 11. Затем следует отключить компьютер от сети и запускать установку с модифицированного на предыдущем шаге носителя.  
#### Обход требования подключения к сети во время установки Windows 11.  
При появлении запроса на подключение к сети Интернет следует нажать комбинацию клавиш ```Shift F10```, а затем в открывшемся окне командной строки выполнить следующее: ```taskkill /F /IM oobenetworkconnectionflow.exe```  

---  
### Работа с файлами.  
---  
#### Архивация всех директорий в текущей директории из командной строки (Windows).  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
_Архив 7z:_ ```for /d %f in (*) do 7z a -t7z -ms=on -m0=LZMA2 -mx9 -mmt=4 -scsUTF-8 -ssc "%~pnf.7z" "%~pnxf"```  
_Архив zip:_ ```for /d %f in (*) do 7z a -tzip -m0=Deflate -mx9 "%~pnxf.zip" "%~pnxf"```  
#### Проверка целостности архива (7z) из командной строки (Linux).  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
```for filename in *.7z; do if 7z t "$filename" 2>&1 > /dev/null; then echo $filename passed; else echo $filename failed; fi; done```  
#### Создание/проверка(/восстановление исходных данных) файлов с информацией для восстановления (parchive/par2) из командной строки (Linux).  
_Требования (зависимости):_ par2  
_Создание:_ ```par2 c -n1 -u -r100 <имя_исходного_файла>.par2 <имя_исходного_файла>```  
_Пример:_ ```par2 c -n1 -u -r100 source.tar.gz.par2 source.tar.gz```  
_Примечание: значение параметра "r" - количество (в процентах) информации для восстановления, при 100% можно полностью восстановить отсутствующий исходный файл._  
_Проверка:_ ```par2 v <имя_исходного_файла>.par2```  
_Пример:_ ```par2 v source.tar.gz.par2```  
_Восстановление исходных данных:_ ```par2 r <имя_исходного_файла>.par2```  
_Пример:_ ```par2 r source.tar.gz.par2```  

---  
### Работа с документами.  
---  
#### Разбиение PDF-файла на отдельные страницы (Windows).  
_Требования (зависимости):_ [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (PDFtk free)  
```pdftk <имя_файла> burst```  
_Пример:_```pdftk source.pdf burst```  
_Требования (зависимости):_ [qpdf](https://github.com/qpdf/qpdf/releases)  
```qpdf --split-pages=1-z <имя_файла> <префикс_имён_файлов_результата>.pdf```  
_Пример:_```qpdf --split-pages=1-z source.pdf page.pdf```  
#### Склеивание PDF-файла из отдельных файлов страниц в текущей директории (Windows).  
_Требования (зависимости):_ [qpdf](https://github.com/qpdf/qpdf/releases)  
```qpdf --empty <имя_файла_результата> --pages *.pdf 1-z --```  
_Пример:_```qpdf --empty destination.pdf --pages *.pdf 1-z --```  
#### Пакетное преобразование (сжатие) PDF-файлов (отдельных файлов страниц!) в текущей директории в чёрно-белые с установкой разрешения 200DPI (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/)  
```for %f in (*.pdf) do convert.exe -density 200 -colorspace Gray -normalize -compress group4 "%~nxf" "%~nf.tif"```  
```for %f in (*.tif) do img2pdf.py -d 200 -o "%~pnf.pdf" "%~pnxf"```  
#### Пакетное преобразование (сжатие) PDF-файлов (отдельных файлов страниц!) в текущей директории с установкой разрешения 200DPI (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.pdf) do convert -density 200 -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 75 -outfile "%~pnf.jpg"```  
```for %f in (*.jpg) do img2pdf.py -d 200 -o "%~pnf.pdf" "%~pnxf"```  
_<p align="justify">Примечание: значение параметра "quality" ("качество") стоит варьировать в диапазоне от 70 до 90; хорошо подходит для больших сканированных изображений (размер файлов может быть уменьшен в несколько раз, но с векторными файлами ситуация обратная).</p>_  
#### Пакетное преобразование DOCX-файлов в текущей директории в формат PDF (Windows).  
_Требования (зависимости):_ [Microsoft Office 2013 или новее](https://www.office.com/), [docx2pdf.js](https://github.com/asimba/uselets/tree/main/tools/docx2pdf)  
```for %f in (*.docx) do cscript //nologo "docx2pdf.js" "%~pnxf"``` или ```docx2pdf.cmd```  
#### Пакетное преобразование RTF-файлов в текущей директории в формат PDF (Windows).  
_Требования (зависимости):_ [Microsoft Office 2013 или новее](https://www.office.com/), [rtf2pdf.js](https://github.com/asimba/uselets/tree/main/tools/rtf2pdf)  
```for %f in (*.rtf) do cscript //nologo "rtf2pdf.js" "%~nxf"``` или ```rtf2pdf.cmd```  
#### Пакетное удаление фона в PDF-файлах (отдельных файлах страниц!) в текущей директории с установкой разрешения 300DPI (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.pdf) do convert -density 300 -fuzz 10%% -fill white -opaque white -units pixelsperinch -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf.jpg"```  
```for %f in (*.jpg) do img2pdf.py -d 300 -o "%~pnf.pdf" "%~pnxf"```  
_Примечание: для аналогичной операции с переводом всех страниц в градации серого следует использовать:_  
```for %f in (*.pdf) do convert -density 300 -fuzz 10% -fill white -opaque white +dither -fx "(r+g+b)/3" -colorspace Gray -separate -average -strip +profile "*" "%~nxf" ppm:- | cjpeg-static -dct int -optimize -grayscale -quality 65 -outfile "%~pnf.jpg"```  
_Примечание: значение параметра "fuzz" соответствует уровню "фонового шума"._  
#### Удаление аннотаций из PDF-файлов (Linux).  
_Требования (зависимости):_ pdftk
```pdftk <имя_исходного_файла> output - uncompress | sed '/^\/Annots/d' | pdftk - output <имя_результирующего_файла> compress```  
_Пример:_```pdftk in.pdf output - uncompress | sed '/^\/Annots/d' | pdftk - output out.pdf compress```  
_Примечание: обычно используется для удаления комментариев "AutoCAD SHX"._  
#### Удаление аннотаций из PDF-файлов (Windows).  
_Требования (зависимости):_ [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (PDFtk free), [sed](http://gnuwin32.sourceforge.net/packages/sed.htm), [stripannot](https://github.com/asimba/uselets/tree/main/tools/stripannot)  
```stripannot.cmd <имя_исходного_файла> <имя_результирующего_файла>```  
_Пример:_```stripannot.cmd in.pdf out.pdf```  
_Примечание: обычно используется для удаления комментариев "AutoCAD SHX"._  
#### Удаление всего текста из PDF-файлов (Linux/Windows).  
_Требования (зависимости):_ [ghostscript](https://www.ghostscript.com/download.html)  
Linux: ```gs -o <имя_результирующего_файла> -sDEVICE=pdfwrite -dFILTERTEXT <имя_исходного_файла>```  
Windows: ```gswin64c.exe -o <имя_результирующего_файла> -sDEVICE=pdfwrite -dFILTERTEXT <имя_исходного_файла>```  
_Пример:_```gswin64c.exe -o output.pdf -sDEVICE=pdfwrite -dFILTERTEXT input.pdf```  
#### Пакетное изменение размеров файлов изображений в текущей директории (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.jpg) do convert -strip -colorspace RGB -filter LanczosRadius -distort Resize "<ширина>>" -distort Resize ">x<высота>" -colorspace sRGB -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf-1.jpg"```  
_Пример:_```for %f in (*.jpg) do convert -strip -colorspace RGB -filter LanczosRadius -distort Resize "1280>" -distort Resize ">x960" -colorspace sRGB -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf-1.jpg"```  
_Примечание: значение параметра "quality" ("качество") стоит варьировать в диапазоне от 70 до 90._  
#### Создание страниц с миниатюрами файлов изображений для всех поддиректорий в текущей директории (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php)  
```for /d %d in (*) do montage -limit thread 6 -limit file 64 -limit memory 8192Mib -limit map 16384MiB -define registry:temporary-path=..\temp -pointsize 10 -label "%wx%h\n%t" -tile 10x10 -geometry 164x162+1+0 -density 200 -units pixelsperinch "%~npxd\*.png" "..\thumbs\%~nxd.png"```  
_<p align="justify">Примечание: параметр "temporary-path" - путь к директории для хранения временных файлов, параметр "tile" - количество миниатюр по горизонтали и вертикали, страницы в данном примере генерируются для "png" файлов, результат размещается в директории "..\thumbs\%~nxd.png"</p>_  
#### Пакетная генерация файлов скринлистов для всех "mp4" файлов в текущей директории (Windows) (пример).  
_Требования (зависимости):_ [movie thumbnailer (mtn)](http://moviethumbnail.sourceforge.net/index.en.html)  
```for %f in (*.mp4) do mtn -c 4 -r 4 -j 100 -o .jpg -P -w 1200 -Z -D6 "%~pnxf"```  
#### Пакетное преобразование видео файлов (Windows) (пример).  
_Требования (зависимости):_ [ffmpeg](https://ffmpeg.org/), [GPAC MP4Box](https://www.videohelp.com/software/MP4Box), [movie thumbnailer (mtn)](http://moviethumbnail.sourceforge.net/index.en.html)  
<details><summary>Код</summary><pre><code>
@echo off
for %%f in (in\*.wmv,in\*.avi,in\*.mp4,in\*.mkv,in\*.flv) do (
echo "%%~dpnxf"
ffmpeg -i "%%~dpnxf" -hide_banner -an -filter_complex "scale=1280:720:flags=lanczos,setdar=16/9,setsar=1/1,unsharp,hqdn3d=2:1:2" -c:v libx264 -b:v 2000k -x264opts frameref=15:fast_pskip=0 -pass 1 -passlogfile tmp\mp4 -preset slow -threads 4 -f rawvideo -y -r film NUL
ffmpeg -i "%%~dpnxf" -hide_banner -c:a aac -b:a 128k -ar 44100 -filter_complex "scale=1280:720:flags=lanczos,setdar=16/9,setsar=1/1,unsharp,hqdn3d=2:1:2" -c:v libx264 -b:v 2000k -x264opts frameref=15:fast_pskip=0 -pass 2 -passlogfile tmp\mp4 -preset slow -threads 4 -y -r film "tmp\out.mp4"
mp4box -isma -inter 500 -add "tmp\out.mp4" -new "out\%%~nf.mp4"
mtn -c 4 -r 4 -j 100 -o .jpg -O out -P -w 1200 -Z -D6 "out\%%~nf.mp4"
del /q tmp\tmp.h264 tmp\mp4-0.log tmp\mp4-0.log.mbtree tmp\out.mp4
)
</code></pre></details>  
