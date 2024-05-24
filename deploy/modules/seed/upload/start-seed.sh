#!/usr/bin/env bash

set -e # exit on failure
# set -x # echo commands

NODE_INDEX=$1

if [[ "${NODE_INDEX}" = "0" ]]; then
    MONIKER="black"
elif [[ "${NODE_INDEX}" = "1" ]]; then
    MONIKER="white"
else
    MONIKER="gray"
fi

# nohup ignite chain serve --verbose >communio.out 2>&1 </dev/null &
echo "About to start seed node ${MONIKER} with NODE_INDEX ${NODE_INDEX} and id $(~/upload/communiod tendermint show-node-id)"
pkill communiod || :
sleep 1
~/upload/communiod start
sleep 1
