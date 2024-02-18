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

echo -e "\tArchitecture : $arch
\tCPU physical : $cpu
\tvCPU : $vcpu
\tMemory Usage : $used_memory/${total_memory}MB ($memory_usage_percentage%)"
