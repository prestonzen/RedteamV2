---
tags:
  - windows
  - tryhackme
---
ovpn
set up DNS
Run password list against user directory (hunter.io) via python password sprayer (OpenBullet / Hydra)
Found Defaults
Logged in via ssh
Hosted Rogue 0-Enryption LDAP Server 
Redirected Printer to Rogue LDAP
Ran Responder for network challenges
PXE Boot Images (Insider Info)
x64{3A56132E-AB61-4CDD-B69E-9C0C71531984}.bcd

SSH into jump box
ssh thm@THMJMP1.za.tryhackme.com -P Password1@ (Right click to paste in Powershell)

powershell -ep bypass  # Priv Esc PS

THMJMP1 - 10.200.26.248
THMDC - 10.200.26.101
pxeboot - 10.200.26.201
MDT - 10.200.26.202

http://pxeboot.za.tryhackme.com/x64%7B3A56132E-AB61-4CDD-B69E-9C0C71531984%7D.bcd

[x64{3A56132E-AB61-4CDD-B69E-9C0C71531984}.bcd](http://pxeboot.za.tryhackme.com/x64%7B3A56132E-AB61-4CDD-B69E-9C0C71531984%7D.bcd)

tftp -i 10.200.26.202 GET "\Tmp\x64{3A56132E-AB61-4CDD-B69E-9C0C71531984}.bcd" conf.bcd

tftp -i (Resolve-DnsName thmmdt.za.tryhackme.com).IPAddress GET "\Tmp\x64{3A56132E-AB61-4CDD-B69E-9C0C71531984}.bcd" conf.bcd

DOWNLOAD NOT WORKING