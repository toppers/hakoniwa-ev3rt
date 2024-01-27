#!/bin/bash

HAKO_CONDUCTOR_PID=
HAKO_ASSET_PROG_PID=
IS_OCCURED_SIGEVENT="FALSE"
function signal_handler()
{
    IS_OCCURED_SIGEVENT="TRUE"
    echo "trapped"
}
function kill_process()
{
    echo "trapped"
    if [ -z "$HAKO_CONDUCTOR_PID" ]
    then
        exit 0
    fi
    
    # HAKO_ASSET_PROG_PID に保存されている各PIDをkill
    for pid in $HAKO_ASSET_PROG_PID; do
        echo "KILLING: ASSET PROG $pid"
        kill -s TERM $pid || echo "Failed to kill ASSET PROG $pid"
    done
    
    echo "KILLING: hakoniwa-conductor $HAKO_CONDUCTOR_PID"
    kill -9 "$HAKO_CONDUCTOR_PID" || echo "Failed to kill hakoniwa-conductor"

    while [ 1 ]
    do
        NUM=$(ps aux | grep hako-master | grep -v grep | wc -l)
        if [ $NUM -eq 0 ]
        then
            break
        fi
        sleep 1
    done

    exit 0
}

function activate_athrill()
{
    CURR_DIR=`pwd`
    HAKO_ASSET_PROG_PID=
    for info in `cat ${ASSET_DEF}`
    do
        TYPE_NAME=`echo $info | awk -F: '{print $1}'`
        LOG=`echo $info | awk -F: '{print $2}'`
        ASSET_NAME=${TYPE_NAME}
        echo "INFO: START ${ASSET_NAME}"
        if [ -d workspace/dev/src/${ASSET_NAME} ]
        then
            cd workspace/dev/src/${ASSET_NAME}
            if [ "${LOG}" = "" ]
            then
                hako-proxy ./proxy_config.json &
            else
                hako-proxy ./proxy_config.json > ${LOG} &
            fi
            HAKO_ASSET_PROG_PID="$! ${HAKO_ASSET_PROG_PID}"
            sleep 1
            cd ${CURR_DIR}
        else
            echo "ERROR: can not find workspace/dev/src/${ASSET_NAME}"
        fi
    done
    cd ${CURR_DIR}
}

function kill_old_hako_conductor()
{
    OLD_PID=`ps aux | grep hako-master | grep -v grep | awk '{print $2}'`
    if [ -z $OLD_PID ] 
    then
        :
    else
        echo "KILLING old pid: ${OLD_PID}"
        kill -s TERM $OLD_PID
    fi
}

