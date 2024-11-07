# ベースイメージ
FROM debian:bullseye-slim AS builder

# 作業ディレクトリ
WORKDIR /root/ssh-agent

# ssh接続用のライブラリをインストール
RUN apt-get update && \
    # ssh-agentはopenssh-clientに含まれてて、ssh-agentを使ってSSH接続したいコンテナのための鍵管理を行う
    apt-get install -y openssh-client

# 起動用スクリプトをコピー
COPY ./init.sh ./
RUN chmod +x ./init.sh

# スクリプトで起動
ENTRYPOINT ["./init.sh"]
