#!/bin/bash

# 最初の起動や更新の反映に使う
# 既存のイメージやキャッシュを破棄してビルド&起動し直す

# CDに移動&初期化
sh_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # 実行場所を相対パスで取得し、そこにサブシェルで移動、pwdで取得
cd "$sh_dir" || {
    echo "Failure CD command."
    exit 1
}
source ./init.sh

# 破棄処理
docker compose -p "${PROJECT_NAME}_deploy" down --rmi all --remove-orphans --volumes --timeout 15

# キャッシュなしでビルド
DOCKER_BUILDKIT=1 docker compose -p "${PROJECT_NAME}_deploy" -f compose.yml -f compose.deploy.yml build --no-cache

# 起動
DOCKER_BUILDKIT=1 docker compose -p "${PROJECT_NAME}_deploy" -f compose.yml -f compose.deploy.yml up -d
