System info dump for pretest process
https://paste.offsec.com/?c1a2671cc368dc0b#Fv12g159Zm5lAjbZ9rdaHcAm5YGkQj0jw1YO1F9r6GI=

I want to prepend this report by making the reader aware that I had the proctoring software kill my driver for my main screen and also was waiting for the proctor for about an hour due to a system glitch so I was already starting this test completely off balance. I also was able to crack **all three** wifi networks and was able to connect despite needing to troubleshoot heavy driver issues which were not taught in the training materials in the slightest. The only reason I was not able to get the hashes of the required wifi network was due to me troubleshooting the driver issues which if the wpa_supplicant worked as instructed in the training course material then there wouldn't have been an issue. I would like to appeal this test result and have it be a pass as I was able to successfully crack them all and in any real world scenario, be able to connect to all of these wireless networks while also proving that I was able to connect manually via CLI for certain scenarios of connecting via an unconfigured raspberry pi or other headless device.

#Target1 WPA-PSK
RDP in
![[Pasted image 20230831045331.png]]
RDP is VERY laggy

Box name is alexandria

Started mon mode
![[Pasted image 20230831045510.png]]

SSID is Mouseion on Channel 4
![[Pasted image 20230831045612.png]]
seems no clients

BSSID of mouse is 02:13:37:BE:EF:03

Try aireplay anyways

lots of beacons sent

![[Pasted image 20230831050001.png]]

Nothing

Trying channel hop again in case there are more ssid's

Client found 
![[Pasted image 20230831050220.png]]

Client's MAC: C2:23:61:95:3B:24

De-authed
![[Pasted image 20230831050358.png]]

Handshake aquired
![[Pasted image 20230831050351.png]]

Prep Rockyou.txt

![[Pasted image 20230831050441.png]]

Run aircrack
![[Pasted image 20230831050541.png]]

Key found

![[Pasted image 20230831050523.png]]

KEY: 1q2w3e4r

Now need to connect. Will do so by GUI.

Network manager is not running

![[Pasted image 20230831055129.png]]

Error not good 

Trying to connect now

CLI method to connect

![[Pasted image 20230831055637.png]]

To connect 
save to wpa_supplicant.conf
network={
        ssid="Mouseion"
        scan_ssid=1
        key_mgmt=WPA-PSK
        psk="1q2w3e4r"
}

sudo wpa_supplicant -i wlan0 -B -c wpa_supplicant.conf -D nl80211

Successfully initialized wpa_supplicant
rfkill: Cannot open RFKILL control device
rfkill: Cannot get wiphy information

Connected 
![[Pasted image 20230831075308.png]]

Force DHCP refresh
![[Pasted image 20230831075929.png]]

HASH: 1da3b8a1ea999bd85008417b48412b5f


#Target2 WEP
Same environment. Reverted for new scenario
![[Pasted image 20230831050658.png]]

RDP error. Exiting since Powershell SSH is better and more stable

IN
![[Pasted image 20230831050751.png]]
box is **airstripone**

Check for devices
![[Pasted image 20230831050833.png]]

Starting monitor mode and recheck for mon mode

![[Pasted image 20230831050858.png]]

Running airodump now

![[Pasted image 20230831050929.png]]

WEP found

channel 3

BSSID: 02:13:37:BE:EF:03
ESSID: Room101


Now capturing the packets and will spam the wifi with aireplay to get more packets for WEP cracking

![[Pasted image 20230831051345.png]]

Get my mac first 
![[Pasted image 20230831051552.png]]

WIFI MAC: 02:00:00:00:00:00

![[Pasted image 20230831051716.png]]

So many beacons

![[Pasted image 20230831051722.png]]

Will wait for 3k+ beacons to send for enough data. Using this time to clean up my notes.

![[Pasted image 20230831051950.png]]

Trying again with even more IV's

My ssh crashed

Associated station mac
02:00:00:00:03:00


Retry with the correct MAC address

![[Pasted image 20230831052347.png]]

![[Pasted image 20230831052746.png]]


Also tried with deauthing the current client
![[Pasted image 20230831052711.png]]

Seems no ARP is being injected

Injection test works

![[Pasted image 20230831053359.png]]

Force association
![[Pasted image 20230831053631.png]]

No success on ARP's being captured. Will try the IV crack anyways

![[Pasted image 20230831054033.png]]

Got it! 

Key:  2E:2C:F0:E3:FF

Now need to connect and get hash

Stopping mon mode
![[Pasted image 20230831054215.png]]



Doesn't want to connect
![[Pasted image 20230831061259.png]]











#Target3 WPA-MGT

Looks like I may need another tool for this

Will try with aircrack

Connected
![[Pasted image 20230831061450.png]]

Start up MON mode
![[Pasted image 20230831061518.png]]

Searching for APs. Nothing via normal view but changing the view I find Roogna
![[Pasted image 20230831061735.png]]

2 Clients
![[Pasted image 20230831061820.png]]

Will brute the channel

Seems like channel 1
![[Pasted image 20230831061858.png]]

Need to make a Rogue access point for them to connect to

Trying some tools
![[Pasted image 20230831063921.png]]

https://github.com/koutto/pi-pwnbox-rogueap/wiki/13.-WPA-WPA2-Enterprise-(MGT)-Rogue-AP-Evil-Twin

Trying this now
https://github.com/s0lst1c3/eaphammer

https://medium.com/@navkang/hacking-wpa-enterprise-using-hostapd-b0fa8839943d

Generating certs for Authentication 
![[Pasted image 20230831070124.png]]

https://github.com/sensepost/hostapd-mana/wiki/Creating-PSK-or-EAP-Networks
```
openssl genrsa -out server.key 2048
openssl req -new -sha256 -key server.key -out csr.csr
openssl req -x509 -sha256 -days 365 -key server.key -in csr.csr -out server.pem
ln -s server.pem ca.pem
```


Finally AP created
![[Pasted image 20230831070250.png]]

Seems to be self deauthing
![[Pasted image 20230831070939.png]]

No second interface required (since I don't have access to one)

Client uses PEAP not EAP

https://attackdefense.pentesteracademy.com/challengedetailsnoauth?cid=1286

Got some hashes
![[Pasted image 20230831071654.png]]
Iris Humphrey
Trent
![[Pasted image 20230831071709.png]]


crack via john

![[Pasted image 20230831071819.png]]


JTR hashes

![[Pasted image 20230831071952.png]]


iris:patricia
Now to connect

Domain\username

Castle\iris


For the wpa supplicant file

`network={
  ssid="Roogna"
  scan_ssid=1
  key_mgmt=WPA-EAP
  identity="Castle\iris"
  password="patricia"
  eap=PEAP
  phase1="peaplabel=0"
  phase2="auth=MSCHAPV2"
}

network={
        ssid="Roogna"
        scan_ssid=1
        key_mgmt=WPA-EAP
        identity="Castle\iris"
        password="patricia"
        eap=PEAP
        phase1="peaplabel=0"
        phase2="auth=MSCHAPV2"
}


iw wlan0 link - to check wifi connection

Errors:

┌──(kali㉿xanth)-[~]
└─$ wpa_supplicant -c wpa_supplicant.conf -i wlan0
Successfully initialized wpa_supplicant
rfkill: Cannot open RFKILL control device
nl80211: deinit ifname=wlan0 disabled_11b_rates=0
wlan0: Failed to initialize driver interface

┌──(kali㉿xanth)-[~]
└─$ touch /dev/rfkill
touch: cannot touch '/dev/rfkill': Permission denied

┌──(kali㉿xanth)-[~]
└─$ sudo touch /dev/rfkill


To connect 
 

`nl80211: Driver does not support authentication/association or connect commands`

They disabled dhcpcd at boot :(

Unsupported driver???

![[Pasted image 20230831074406.png]]

┌──(kali㉿xanth)-[~]
└─$ sudo wpa_supplicant -i wlan0 -B -c wpa_supplicant.conf -D nl80211
Successfully initialized wpa_supplicant

Should do it

![[Pasted image 20230831081453.png]]
  -d = increase debugging verbosity (-dd even more)
Seems that the test people actually blocked the wifi devices from connecting so I needed to undo that. Ridiculous

# 3.12. RFKill

Many computer systems contain radio transmitters, including Wi-Fi, Bluetooth, and 3G devices. These devices consume power, which is wasted when the device is not in use.

_RFKill_ is a subsystem in the Linux kernel that provides an interface through which radio transmitters in a computer system can be queried, activated, and deactivated. When transmitters are deactivated, they can be placed in a state where software can reactive them (a _soft block_) or where software cannot reactive them (a _hard block_).

The RFKill core provides the application programming interface (API) for the subsystem. Kernel drivers that have been designed to support RFkill use this API to register with the kernel, and include methods for enabling and disabling the device. Additionally, the RFKill core provides notifications that user applications can interpret and ways for user applications to query transmitter states.

The RFKill interface is located at `/dev/rfkill`, which contains the current state of all radio transmitters on the system. Each device has its current RFKill state registered in `sysfs`. Additionally, RFKill issues _uevents_ for each change of state in an RFKill-enabled device.

**Rfkill** is a command-line tool with which you can query and change RFKill-enabled devices on the system. To obtain the tool, install the rfkill package.

Use the command `rfkill list` to obtain a list of devices, each of which has an _index number_ associated with it, starting at `0`. You can use this index number to tell **rfkill** to block or unblock a device, for example:

~]# `rfkill block 0`

blocks the first RFKill-enabled device on the system.

You can also use **rfkill** to block certain categories of devices, or all RFKill-enabled devices. For example:

~]# `rfkill block wifi`

blocks all Wi-Fi devices on the system. To block all RFKill-enabled devices, run:

~]# `rfkill block all`

To unblock devices, run `rfkill unblock` instead of `rfkill block`. To obtain a full list of device categories that **rfkill** can block, run `rfkill help`

```
$ rfkill list all
0: phy0: Wireless LAN
    Soft blocked: no
    Hard blocked: yes
1: acer-wireless: Wireless LAN
    Soft blocked: yes
    Hard blocked: no
$ rfkill unblock all
```

```
 rfkill unblock all
```