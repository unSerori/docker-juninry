#!/bin/bash

# コンテナの再起動を行うが、イメージの再構築や更新された設定は反映させない

# CDに移動
sh_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # 実行場所を相対パスで取得し、そこにサブシェルで移動、pwdで取得
cd "$sh_dir" || {
    echo "Failure CD command."
    exit 1
}

# 再起動(stop + start) restartでは-fオプションのヘルスチェックと順序を守ってくれなかった
bash ./deploy-pause.sh
bash ./deploy-resume.sh
