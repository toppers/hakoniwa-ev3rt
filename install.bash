#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 {prepare|hakoniwa|conductor|athrill|athrill_device}"
    exit 1
fi

OPT=${1}
CURR_DIR=`pwd`

function install_prepare()
{
    sudo apt-get install -y cargo
    sudo apt-get install -y protobuf-compiler
    sudo apt-get install -y build-essential
    sudo apt-get install -y libc++-dev libc++abi-dev

    if [ ! -d /usr/local/lib/hakoniwa ]
    then
        sudo mkdir /usr/local/lib/hakoniwa
    fi
    if [ ! -d /usr/local/bin/hakoniwa ]
    then
        sudo mkdir /usr/local/bin/hakoniwa
    fi
}

function install_hakoniwa()
{
    echo "INFO: install hakoniwa core cpp client"
    cd hakoniwa-core-cpp-client
    bash build.bash
    bash install.bash
    cd ${CURR_DIR}
}
function install_conductor()
{
    echo "INFO: install hakoniwa conductor"
    cd hakoniwa-conductor/main
    #bash build.bash
    sudo bash install.bash
    cd ${CURR_DIR}
}
function install_athrill()
{
    echo "INFO: install athrill"
    cd athrill-target-v850e2m/build_linux
    bash build.bash
    sudo cp ../athrill/bin/linux/athrill2 /usr/local/bin/hakoniwa/
    cd ${CURR_DIR}
}

function install_athrill_device()
{
    echo "INFO: install athrill device"
    ln -s athrill-target-v850e2m/athrill athrill
    cd athrill-device/device/hakotime
    bash build.bash
    cd ${CURR_DIR}
    cd athrill-device/device/hakopdu
    bash build.bash
    cd ${CURR_DIR}
    rm athrill

    sudo cp athrill-device/device/hakotime/cmake-build/libhakotime.* /usr/local/lib/hakoniwa/
    sudo cp athrill-device/device/hakopdu/cmake-build/libhakopdu.* /usr/local/lib/hakoniwa/
}

if [ ${OPT} = "prepare" ]
then
    install_prepare
fi

if [ ${OPT} = "hakoniwa" ]
then
    install_hakoniwa
fi

if [ ${OPT} = "conductor" ]
then
    install_conductor
fi

if [ ${OPT} = "athrill" ]
then
    install_athrill
fi

if [ ${OPT} = "athrill_device" ]
then
    install_athrill_device
fi
