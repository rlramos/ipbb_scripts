#!/bin/bash
# ./loop <ciena_hostname>:<port>

#Setting variables
device=$( echo "$1" | awk -F":" '{print $1}')
interface=$( echo "$1" | awk -F":" '{print $2}')
read -p " Enter option (RX | TX | NORMALIZE) " looper
lowercase_looper="${looper,,}"

#commands
rx_loop="
port disable port $interface
port set port $interface loopback $lowercase_looper
port show port $interface
"
normalize_loop="
port set port $interface loopback disable
port enable port $interface
"
if [ "$looper" == "normalize" ]; then
    fcr --no-regex_search_skynet --device=$device --commands="$normalize_loop"
else
    fcr --no-regex_search_skynet --device=$device --commands="$rx_loop"
fi
echo "$looper loop has been place on  $device $interface"
