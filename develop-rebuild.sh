#!/bin/bash

# 最初の起動や更新の反映に使う
# 既存のイメージやキャッシュを破棄してビルド&起動し直す

# 破棄処理
bash ./balus.sh

# キャッシュなしでビルド
DOCKER_BUILDKIT=1 docker compose -f compose.yml -f compose.develop.yml build --no-cache

# 起動
DOCKER_BUILDKIT=1 docker compose -f compose.yml -f compose.develop.yml up -d
