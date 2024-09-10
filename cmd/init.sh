#!/bin/bash

# 初期化処理
# 変数の読み込みとディレクトリ移動

# ディレクトリ調整

# 変数を読み込み
source ./env

# composeディレクトリに移動
cd ../compose || {
    echo "Failure CD command."
    exit 1
}
