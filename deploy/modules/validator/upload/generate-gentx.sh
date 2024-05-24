#!/usr/bin/env bash

set -e # exit on failure
# set -x # echo commands

ENV=$1
TOKEN_NAME=$2
VALIDATOR_KEY_NAME=$3
VALIDATOR_KEYS_PASSPHRASE=$4

rm -rf ~/.communio/config/gentx/*
echo ${VALIDATOR_KEYS_PASSPHRASE} | ~/upload/communiod genesis gentx --keyring-backend file --chain-id=communio-${ENV}-1 --moniker=${VALIDATOR_KEY_NAME} ${VALIDATOR_KEY_NAME} 100000000${TOKEN_NAME}
