#!/bin/bash
workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"&&pwd )"
exec 1> $workdir/task4_1.out

echo "--- Harware ---"

cat /proc/cpuinfo | grep 'model name' -m 1 | awk -F: '{print "CPU:" $2}'
cat /proc/meminfo | grep 'MemTotal' | awk '{print "RAM: " $2 "KB"}'

matherbman=$( dmidecode -t 1 | grep 'Manufacturer' | awk -F: '{print $2}' )
matherbpro=$( dmidecode -t 1 | grep 'Product Name' | awk -F: '{print $2}' )
serialnumber=$( dmidecode -s system-serial-number )

echo "Matherboard:" $matherbpro ${matherbman:-Unknown}
echo "System Serial Number:" ${serialnumber:-Unknown}

echo "--- System ---"
echo "OS Distribution:" $( lsb_release -ds )
echo "Kernel version:" $( uname -r )
cat /var/log/dpkg.log | awk 'NR==1{print "Installation date: " $1}'
echo "Hostname:" $( hostname -f ) 
echo "Uptime:" $( uptime -p | awk -F "up |" '{print $2}' )
echo "Processes running:" $( ps -A | wc -l )
echo "User logged in:" $( who | wc -l )

echo "--- Network ---" 
for iface in $(ifconfig | cut -d ' ' -f1| tr "\n" ' ') 
do
  addr=$(ip -o -4 addr list $iface | awk '{print $4}')
  echo "$iface:" ${addr:--}
done

exit 0
