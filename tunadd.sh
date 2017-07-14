#!/bin/bash
modprobe ipip
tun=${TUN:-tun}
net=${NET:-172.16}
mode="n"
sname=""
dname=""
while getopts 's:d:t:n:xhS:D:' opt ;do
        case $opt in
        x)
        mode="x";;
        s)
        sip="$OPTARG";;
        d)
        dip="$OPTARG";;
        t)
        tun="$OPTARG";;
        n)
        net="$OPTARG";;
        S)
        sname="$OPTARG";;
        D)
        dname="$OPTARG";;
        h)
        echo -e "Useage: $0 -s sourceip -d destionation ip -t tunnel name -n net pre"
        echo -e "Useage: or you can use $0 -n net pre -s sourceip -d destionation ip -S local Mantissa  -D remote Mantissa";;
        *)
        echo "error";;
esac
done
if [ $mode = x ];then
        tmpip=$sip;sip=$dip;dip=$tmpip
        tmpdp=$sname;sname=$dname;dname=$tmpdp
fi
s=$(echo $sip|awk -F "." '{print $4}')
d=$(echo $dip|awk -F "." '{print $4}')
if [ $sname ]&&[ $dname ];then
        s=$sname;d=$dname
fi
[ $s -eq $d ]&&exit 1

ip t add ${tun}_${s}_$d mode ipip remote $dip local $sip
ip l set ${tun}_${s}_$d up
ip a add $net.$s.$d/32 peer $net.$d.$s dev ${tun}_${s}_$d
