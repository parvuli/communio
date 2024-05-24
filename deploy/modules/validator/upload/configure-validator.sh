#!/usr/bin/env bash

set -x
set -e

ENV=$1
NODE_INDEX=$2
if [[ "${NODE_INDEX}" = "0" ]]; then
    MONIKER="red"
elif [[ "${NODE_INDEX}" = "1" ]]; then
    MONIKER="blue"
else
    MONIKER="green"
fi

VALIDATOR_IPS_STR=$3
VALIDATOR_IPS=(${VALIDATOR_IPS_STR//,/ })
VALIDATOR_P2P_KEYS=(7b23bfaa390d84699812fb709957a9222a7eb519 547217a2c7449d7c6f779e07b011aa27e61673fc 7aaf162f245915711940148fe5d0206e2b456457)

P2P_EXTERNAL_ADDRESS="tcp://${VALIDATOR_IPS[$NODE_INDEX]}:26656"

TOKEN_NAME=$4
VALIDATOR_KEYS_PASSPHRASE=$5

P2P_PERSISTENT_PEERS=""
N=${#VALIDATOR_IPS[@]}
N_MINUS_1=$(($N - 1))
for i in $(seq 0 $N_MINUS_1); do
    if [[ "${i}" != "${NODE_INDEX}" ]]; then
        P2P_PERSISTENT_PEERS="${P2P_PERSISTENT_PEERS}${VALIDATOR_P2P_KEYS[$i]}@${VALIDATOR_IPS[$i]}:26656,"
    fi
done

rm -rf ~/.communio
~/upload/communiod init $MONIKER --chain-id communio-${ENV}-1 --default-denom ${TOKEN_NAME}
cp upload/node_key_validator_${NODE_INDEX}.json ~/.communio/config/node_key.json

cat >/tmp/communio.service <<-EOF
[Unit]
Description=start communio blockchain client running as a validator node
Wants=network.target
After=syslog.target network-online.target

[Service]
Type=simple
ExecStart=sudo -u ubuntu /home/ubuntu/upload/start-validator.sh ${NODE_INDEX}
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target

EOF
sudo cp /tmp/communio.service /etc/systemd/system/communio.service
sudo chmod 664 /etc/systemd/system/communio.service
sudo systemctl daemon-reload

dasel put -f ~/.communio/config/config.toml -v "${P2P_EXTERNAL_ADDRESS}" ".p2p.external_address"
dasel put -f ~/.communio/config/config.toml -v "${P2P_PERSISTENT_PEERS}" ".p2p.persistent_peers"
dasel put -f ~/.communio/config/config.toml -v "/home/ubuntu/cert/fullchain.pem" ".rpc.tls_cert_file"
dasel put -f ~/.communio/config/config.toml -v "/home/ubuntu/cert/privkey.pem" ".rpc.tls_key_file"
dasel put -t bool -f ~/.communio/config/app.toml -v true ".api.enable"
dasel put -f ~/.communio/config/app.toml -v "tcp://localhost:1317" ".api.address"
dasel put -f ~/.communio/config/app.toml -v "1${TOKEN_NAME}" ".minimum-gas-prices"

# generate validator address and store address and mnemonic in ~/.communio/config/keys-backup
MNEMONIC=$(~/upload/communiod keys mnemonic --keyring-backend file)
(echo $MNEMONIC; echo ${VALIDATOR_KEYS_PASSPHRASE}; echo ${VALIDATOR_KEYS_PASSPHRASE}) | ~/upload/communiod keys add ${MONIKER} --keyring-backend file --recover
ADDRESS=$(echo ${VALIDATOR_KEYS_PASSPHRASE} | ~/upload/communiod keys show ${MONIKER} -a --keyring-backend file)
mkdir -p ~/.communio/config/keys-backup
echo ${MONIKER}-${ADDRESS} > ~/.communio/config/keys-backup/validator-address-${MONIKER}.txt
echo ${MNEMONIC} > ~/.communio/config/keys-backup/validator-mnemonic-${MONIKER}.txt
