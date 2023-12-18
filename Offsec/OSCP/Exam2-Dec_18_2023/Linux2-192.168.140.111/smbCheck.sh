#/bin/bash

ip='192.168.140.111'
shares=('C$' 'D$' 'ADMIN$' 'IPC$' 'PRINT$' 'FAX$' 'SYSVOL' 'NETLOGON' 'AnneAuto')

for share in ${shares[*]}; do
#Null mode
#    output=$(smbclient -U '%' -N \\\\$ip\\$share -c '') 
    output=$(smbclient //$ip//$share -c '')
#Guest mode
#    output=$(smbclient -U guest -N \\\\$ip\\$share -c '')

    if [[ -z $output ]]; then 
        echo "[+] creating a null session is possible for $share" # no output if command goes through, thus assuming that a session was created
    else
        echo $output # echo error message (e.g. NT_STATUS_ACCESS_DENIED or NT_STATUS_BAD_NETWORK_NAME)
    fi
done
