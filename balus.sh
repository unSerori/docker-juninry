#!/bin/bash

# 破壊

# deploy削除 既存のコンテナの停止とそのイメージの削除 --remove-orphans: Compose ファイルで定義していないサービス用のコンテナも削除
docker compose -f compose.yml -f compose.deploy.yml down --rmi all --remove-orphans --volumes --timeout 15

# develop破壊
docker compose -f compose.yml -f compose.develop.yml down --rmi all --remove-orphans --volumes --timeout 15
