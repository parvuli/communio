#!/usr/bin/env bash

set -e # exit on failure
# set -x # echo commands

SCRIPT_DIR=$(dirname $(readlink -f $0))
cd ${SCRIPT_DIR}/..

ENV=$1
if [[ ! $ENV =~ ^mainnet|testnet$  ]]; then
  echo "Usage: destroy-all <mainnet|testnet>"
  exit 1
fi
if [[ ! "$(terraform workspace list)" =~ "${ENV}" ]]; then
  echo "terraform workspace ${ENV} does not exist - run create-zone.sh before running this script."
  exit 1
fi

terraform workspace select ${ENV}
terraform -chdir=deploy destroy  -var="env=${ENV}" -var="num_validator_instances=0" -var="num_seed_instances=0" -var="create_explorer=false" -var-file="persistent.tfvars"
terraform workspace select default
terraform workspace delete ${ENV}
