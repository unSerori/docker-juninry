#!/bin/bash

# stopで停止していたコンテナたちを開始

# 開始
docker compose -f compose.yml -f compose.deploy.yml start
