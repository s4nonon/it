#!/bin/bash
# Purpose: Vault Quick Setup

mkdir -p "${PWD}"/vault/{config,file,logs}

touch    "${PWD}"/vault/docker-compose.yml

cat << EOF > "${PWD}"/vault/config/vault.json
{
  "backend": {
    "file": {
      "path": "/vault/file"
    }
  },
  "listener": {
    "tcp":{
      "address": "0.0.0.0:8200",
      "tls_disable": 1
    }
  },
  "ui": true
}
EOF

cat << EOF > "${PWD}"/vault/docker-compose.yml
version: '3.7'
services:
  vault:
    image: vault:latest
    container_name: vault
    ports:
      - "8200:8200"
    restart: unless-stopped
    volumes:
      -  ./logs:/vault/logs
      -  ./file:/vault/file
      -  ./config:/vault/config
    cap_add:
      - IPC_LOCK
    entrypoint: vault server -config=/vault/config/vault.json
EOF

cd "${PWD}"/vault

docker-compose up -d



### Login
# docker exec -it vault sh
# ROOT_TOKEN=[ROOT_TOKEN_VALUE_HERE]
# ROOT_TOKEN=s.7fX9gEzMfwCMrO8hqtUa5AWF
# export ROOT_TOKEN
# export VAULT_ADDR=http://127.0.0.1:8200
# vault login -address=$VAULT_ADDR $ROOT_TOKEN