#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install ufw build-essential jq -y

sleep 1
wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash -s -- --version 1.18
sleep 1
source ~/.profile

sleep 1
ufw allow ssh && ufw allow 26657 && ufw allow 34657
ufw enable

sleep 1
git clone https://github.com/munblockchain/mun
cd mun

sleep 1
sudo rm -rf ~/.mun
go mod tidy

sleep 1
make install

sleep 1
mkdir -p ~/.mun/upgrade_manager/upgrades
mkdir -p ~/.mun/upgrade_manager/genesis/bin

sleep 1
cp $(which mund) ~/.mun/upgrade_manager/genesis/bin
sudo cp $(which mund-manager) /usr/bin

echo "input monkier name (word1-word2-word3):"
read monkier_mun
mund init $monkier_mun --chain-id testmun

sleep 1
mund keys add dw --keyring-backend test

sleep 20

curl --tlsv1 https://node1.mun.money/genesis? | jq ".result.genesis" > ~/.mun/config/genesis.json

sleep 1


word1='seeds = ""'
word2='seeds = "b4eeaf7ca17e5186b181885714cedc6a78d20c9b@167.99.6.48:26656,6a08f2f76baed249d3e3c666aaef5884e4b1005c@167.71.0.38:26656,9240277fca3bfa0c3b94efa60215ca10cf54f249@45.76.68.116:26656"'
sed "s/$word1/$word2/g" ~/.mun/config/config.toml

word3='laddr = "tcp://127.0.0.1:34657"'
word4='laddr = "tcp://0.0.0.0:34657"'
sed "s/$word3/$word4/g" ~/.mun/config/config.toml