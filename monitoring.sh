#!/bin/bash

#Architecture
arch=$(uname -a)

#CPU
cpu=$(lscpu | grep 'Socket(s):' | awk '{print $2}')

#vCPU
vcpu=$(nproc)

#Memory usage
total_memory=$(free --mega | awk 'NR==2{printf $2}')
used_memory=$(free --mega | awk 'NR==2{printf $3}')
memory_usage_percentage=$(awk "BEGIN {printf \"%.2f\", ${used_memory}*100/${total_memory}}")

#Disk usage
total_disk=$(df -h --total | awk 'END{print $2}')
used_disk=$(df -h --total | awk 'END{print $3}')
disk_usage=$(df -h --total | awk 'END{print $5}')

#CPU Load
cpu_load=$(mpstat 1 1 | tail -n 1 | awk '{print 100-$12}')

#Last boot
last_boot=$(who -b | awk '{print $3" "$4}')

#LVM use
lvm=$(lsblk | grep -q "lvm" && echo yes || echo no)

#TCP Connexions
tcp_connexions=$(ss -s | awk 'NR==2{print $4}' | tr -d ',')

#User log
user_log=$(who -u | awk '{print $1}' | sort | uniq | wc -l)

#Network
ip=$(hostname -I)
mac=$(ip link show | awk 'NR==2{print $2}')

#Sudo
sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "
	Architecture: $arch
	CPU physical: $cpu
	vCPU: $vcpu
	Memory Usage: $used_memory/${total_memory}MB (${memory_usage_percentage}%)
	Disk Usage: $used_disk/$total_disk ($disk_usage)
	CPU Load: $cpu_load
	Last boot: $last_boot	
	LVM use: $lvm
	Connexions TCP: $tcp_connexions ESTABLISHED
	User log: $user_log
	Network: IP $ip ($mac)
	Sudo: $sudo cmd"