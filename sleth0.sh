#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
hostname=`ip add |grep inet |grep eth0 |awk '{print $2}' |awk -F / '{print $1}'`
#Date=`date +%Y%m%d%H%M%S`
tcpdumps()
{
/usr/sbin/tcpdump -i eth0 -c 5000 -w /tmp/$date.cap;
}
for ((i=0;i<58;i++));
do
        date=`date +%Y%m%d%H%M%S`
        R1=`cat /sys/class/net/eth0/statistics/rx_bytes`
        T1=`cat /sys/class/net/eth0/statistics/tx_bytes`
        sleep 1
        R2=`cat /sys/class/net/eth0/statistics/rx_bytes`
        T2=`cat /sys/class/net/eth0/statistics/tx_bytes`
        TBPS=`echo "scale=2;$T2-$T1"|bc`
        RBPS=`echo "scale=2;$R2-$R1"|bc`
        TMbps=`echo "scale=2;$TBPS/1024/1024*8"|bc`
        RMbps=`echo "scale=2;$RBPS/1024/1024*8"|bc`
        echo "[$date]TX eth0:$TMbps Mb/s  RX eth0:$RMbps Mb/s"  >> /tmp/ssseth0.log
        eval  TX$[i]=`echo $TMbps`
        eval  RX$[i]=`echo $RMbps`
        T=$(eval echo \$TX$[i])
        R=$(eval echo \$RX$[i])
        t=$(eval echo \$TX$[i-1])
        r=$(eval echo \$RX$[i-1])
        m=$(eval echo \$TX$[i-2])
        n=$(eval echo \$RX$[i-2])
if [ $i -ge 2 -a  `echo $T $t | awk '{ printf "%d\n" ,$1-$2}'` -gt 50 -a `echo $m $t | awk '{ printf "%d\n" ,$1-$2}'` -gt 50 -o $i -ge 2 -a  `echo $R $r | awk '{ printf "%d\n" ,$1-$2}'` -gt 50 -a `echo $n $r | awk '{ printf "%d\n" ,$1-$2}'` -gt 50  ]
    then
    tcpdumps;
    tail /tmp/ssseth0.log >/tmp/mail.log
   /usr/bin/mail -s "$hostname 有异常流量" 88541438@qq.com,eli0309@qq.com < /tmp/mail.log
    break
fi
done
