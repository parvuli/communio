#!/usr/bin/env bash

set -e # exit on failure
# set -x # echo commands

SCRIPT_DIR=$(dirname $(readlink -f $0))
NODE_TYPE=$1
NODE_INDEX=$2

IP=$(${SCRIPT_DIR}/show-ip.sh $NODE_TYPE $NODE_INDEX)

echo "http://${IP}:1317"
