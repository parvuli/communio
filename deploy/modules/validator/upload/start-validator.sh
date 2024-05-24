#!/usr/bin/env bash

set -e # exit on failure
# set -x # echo commands

NODE_INDEX=$1

if [[ "${NODE_INDEX}" = "0" ]]; then
    MONIKER="red"
elif [[ "${NODE_INDEX}" = "1" ]]; then
    MONIKER="blue"
else
    MONIKER="green"
fi

if [[ "${NODE_INDEX}" != "0" ]]; then
    echo "sleeping for 5 seconds to give primary validator time to start up"
    sleep 5
fi

# nohup ignite chain serve --verbose >communio.out 2>&1 </dev/null &
sleep 1
echo "about to start validator node ${MONIKER} with NODE_INDEX ${NODE_INDEX} and id $(~/upload/communiod tendermint show-node-id)"
pkill communiod || :
sleep 1
~/upload/communiod start
sleep 1
