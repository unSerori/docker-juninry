#!/bin/bash

# stopで停止していたコンテナたちを開始

# CDに移動&初期化
sh_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # 実行場所を相対パスで取得し、そこにサブシェルで移動、pwdで取得
cd "$sh_dir" || {
    echo "Failure CD command."
    exit 1
}
source ./init.sh

# 開始
DOCKER_BUILDKIT=1 docker compose -p "${PROJECT_NAME}_deploy" start
