#!/bin/bash

if [ !-d workspace/run/run.bash ]
then
    echo "ERROR: can not find run.bash on workspace/run"
    exit 1
fi

source workspace/run/run_utils.bash

NETWORK_INTERFACE=$(route | grep '^default' | grep -o '[^ ]*$' | tr -d '\n')
export PATH="/usr/local/bin/hakoniwa:${PATH}"
export LD_LIBRARY_PATH="/usr/local/lib/hakoniwa:${LD_LIBRARY_PATH}"
export DYLD_LIBRARY_PATH="/usr/local/lib/hakoniwa:${DYLD_LIBRARY_PATH}"
export DELTA_MSEC=20
export MAX_DELAY_MSEC=100
export CORE_IPADDR=$(ifconfig "${NETWORK_INTERFACE}" | grep netmask | awk '{print $2}')
export UDP_SRV_PORT=54001
export UDP_SND_PORT=54002
export GRPC_PORT=50051
export ASSET_DEF=`pwd`"/workspace/run/asset_def.txt"

kill_old_hako_conductor
trap signal_handler SIGINT

echo "INFO: ACTIVATING HAKONIWA-CONDUCTOR"
hako-master-rust ${DELTA_MSEC} ${MAX_DELAY_MSEC} ${CORE_IPADDR}:${GRPC_PORT} ${UDP_SRV_PORT} ${UDP_SND_PORT} &  
export HAKO_CONDUCTOR_PID=$!

sleep 1

activate_athrill

echo "START"
while true; do
    echo "Press ENTER to stop..."
    read input
    if [ -z "$input" ]; then
        kill_process
        break
    fi
done
