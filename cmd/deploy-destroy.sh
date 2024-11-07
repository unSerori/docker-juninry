#!/bin/bash

# deployのみ破壊

# CDに移動&初期化
sh_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # 実行場所を相対パスで取得し、そこにサブシェルで移動、pwdで取得
cd "$sh_dir" || {
    echo "Failure CD command."
    exit 1
}
source ./init.sh

# deploy削除 既存のコンテナの停止とそのイメージの削除 --remove-orphans: Compose ファイルで定義していないサービス用のコンテナも削除
docker compose -p "${PROJECT_NAME}_deploy" down --rmi all --remove-orphans --volumes --timeout 15
