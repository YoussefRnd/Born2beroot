#Architecture
arch=$(uname -a)

#CPU
cpu=$(lscpu | grep 'Socket(s):' | awk '{print $2}')

#vCPU
vcpu=$(nproc)

#Memory usage
total_memory=$(free --mega | awk 'NR==2{printf $2}')
used_memory=$(free --mega | awk 'NR==2{printf $3}')
memory_usage_percentage=$(free --mega | awk 'NR==2{printf "%.2f", $3*100/$2}')

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
sudo=$(grep -c 'COMMAND' /var/log/sudo/sudo.log)

echo -e "\tArchitecture: $arch
\tCPU physical: $cpu
\tvCPU: $vcpu
\tMemory Usage: $used_memory/${total_memory}MB ($memory_usage_percentage%)
\tDisk Usage: $used_disk/$total_disk ($disk_usage)
\tCPU Load: $cpu_load
\tLast boot: $last_boot
\tLVM use: $lvm
\tConnexions TCP: $tcp_connexions ESTABLISHED
\tUser log: $user_log
\tNetwork: IP $ip ($mac)
\tSudo: $sudo cmd"
