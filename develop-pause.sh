#!/bin/bash

# サービス(コンテナ)たちを停止

# 停止
docker compose -f compose.yml -f compose.develop.yml stop
