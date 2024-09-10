#!/bin/bash

# ssh-agentの起動と鍵の登録 これによって、開発用コンテナでもホストOSで設定されたSSH通信を利用できる
# まずclinet, socket, agentの役割
# clinetはSSH接続を試みserverから要求された認証チャレンジに応える
# socketはssh-clinetとssh-agent間の署名リクエストと署名レスポンスの橋渡しをする
# agentは鍵を読み込み、鍵を使って署名し、clientに返す
# 開発用コンテナがssh通信をこころみたときの流れ
# clinetがローカルの鍵の確認と無ければ、ssh-agentへの認証リクエストをソケットを介して送る
# リクエストを受けたagentは事前にメモリに読み込んだ鍵で署名を行い、署名レスポンスをソケットを介して開発用コンテナのSSHクライアントに返す
# socketが名前付きボリュームでコンテナ間共有されているため、開発用コンテナや他のコンテナでもagentコンテナのssh-agentを利用してSSH通信できる

# 停止シグナルのハンドル
stop_handler() {
    echo "Terminating process with PID: ${MAIN_PID}..."
    kill -s TERM $MAIN_PID
    wait $MAIN_PID
    echo "Process with PID: ${MAIN_PID} has been terminated."
}

# シグナルハンドリング
trap stop_handler SIGTERM SIGINT

# ソケットファイルが存在する場合、削除してから、
if [ -S "${SSH_AUTH_SOCK}" ]; then
    rm -f "${SSH_AUTH_SOCK}"
fi

# ssh agentを生成&利用するソケットファイルの場所を指定して起動する # ssh-agentコマンドはプロセスを起動し、環境変数設定値とPIDの出力を行う。evalに出力を解釈させて、設定を行い、シェルとの連携が行えるようにする。なお、設定した変数はこのシェルのみ有効。
eval "$(ssh-agent -a "${SSH_AUTH_SOCK}")"

# 鍵をエージェントに登録
ssh-add

# メインプロセス
sleep infinity &
# メインプロセスのPIDを取得
MAIN_PID=$!
echo "\$MAIN_PID: ${MAIN_PID}"

# 子プロセスの終了を待つ
wait $MAIN_PID
