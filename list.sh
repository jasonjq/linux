#!/bin/bash
rm ~/IP
rm ~/NAME
for m in `seq 67 113`
do
   echo "45.255.124.$m" >>~/IP
done

for n in `seq 1 47`
do
   echo "em1:$n" >>~/NAME
done

ip=(`cat ~/IP`)
name=(`cat ~/NAME`)

for ((i=0,j=0;i<${#ip[@]},j<${#name[@]};i++,j++))
  do
echo -e "auto ${name[$j]}"
echo -e "iface ${name[$j]} inet static"
echo -e "address ${ip[$i]}"
echo -e "netmask 255.255.255.192"
done
