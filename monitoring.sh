#!/bin/bash
arc=$(uname -a)
#!pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lb=$(who -b | awk '$1 == "sistem" {print $3 " " $4}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo hayır; else echo evet; fi)
ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "	#Mimari ve Kernel Versiyonu: $arc
	#Fiziksel İşlemci Sayısı: $pcpu
	#Sanal İşlemci Sayısı: $vcpu
	#RAM Miktar ve Kullanımı: $uram/${fram}MB ($pram%)
	#Disk Miktarı ve Kullanımı: $udisk/${fdisk}Gb ($pdisk%)
	#CPU Kullanım Oranı: $cpul
	#Son Yeniden Başlama Tarihi: $lb
	#LVM Kullanım Durumu: $lvmu
	#Aktif Bağlantı Sayısı: $ctcp ESTABLISHED
	#Sunucuyu Kullanan K. Sayısı: $ulog
	#IP ve MAC Adresi: IP $ip ($mac)
	#Kullanılmış Sudo Sayısı: $cmds cmd"
