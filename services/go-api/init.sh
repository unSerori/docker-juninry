#!/bin/bash

# ホストボリュームで共有するディレクトリ内が空でないなら、最初のdockerビルドだと判断して自動clone

# 停止シグナルのハンドル
stop_handler() {
    echo "Terminating process with PID: ${MAIN_PID}..."
    kill -s TERM $MAIN_PID
    wait $MAIN_PID
    echo "Process with PID: ${MAIN_PID} has been terminated."
}

# シグナルハンドリング
trap stop_handler SIGTERM SIGINT

# change work dir
sh_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # 実行場所を相対パスで取得し、そこにサブシェルで移動、pwdで取得
cd "$sh_dir" || {
    echo "Failure CD command."
    exit 1
}

# log
echo "DATE: $(date)" 2>&1 | tee -a /root/log/execute.log # datetime
echo "PWD: $(pwd)" 2>&1 | tee -a /root/log/execute.log   # /root/copy
echo "Checking directories: /root/" 2>&1 | tee -a /root/log/execute.log
find /root/ -maxdepth 0 -exec ls -la {} + 2>&1 | tee -a /root/log/execute.log # ls -la /root/
echo "Checking directories: /root/share" 2>&1 | tee -a /root/log/execute.log
find /root/share -maxdepth 0 -exec ls -la {} + 2>&1 | tee -a /root/log/execute.log # ls -la /root/share/

# volumesされているはずのディレクトリが空(初回ビルド時)なら、
if [ -d "/root/share/" ] && [ -z "$(ls -A "/root/share/")" ]; then # -dでディレクトリかどうか確認し、かつ、-zでls -Aによるリスト化したフォルダ内のリストが空なら真
    # log
    echo Clone now... 2>&1 | tee -a /root/log/execute.log

    # ソースコードのリポジトリをクローン、
    git clone https://github.com/unSerori/juninry-api -b develop /root/share/./
    # copyされたファイルを適切な場所に移行
    mv .env /root/share/
else
    # log
    echo Do not clone. 2>&1 | tee -a /root/log/execute.log
fi

# log
echo End of clone process branch. 2>&1 | tee -a /root/log/execute.log
echo Start main process... 2>&1 | tee -a /root/log/execute.log
echo -e -n "\n" 2>&1 | tee -a /root/log/execute.log

# コンテナーを閉じないための軽量プロセス
sleep infinity &
# メインプロセスのPIDを取得
MAIN_PID=$!
echo "\$MAIN_PID: ${MAIN_PID}"

# 子プロセスの終了を待つ
wait $MAIN_PID

# コンテナを動かし続ける compose.commandにもこれ書きがちだけど、commandにプロセス書くならttyでいいかもしれない
# tail -f /dev/null

# これは終了シグナルtrap形式でも動く
# sleep infinity

# ただの一行無限ループ
# while true; do sleep 3 && echo hoge; done
