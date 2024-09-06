# 開発用のステージ

# Stage1: 開発環境に必要なツールとソースを入れるベースイメージ
FROM golang:1.22.2-bullseye AS develop

# 作業ディレクトリ
WORKDIR /root/

# aptでパッケージリストの更新とgitインストール
RUN apt update && \
    apt install -y git

# デバッガインストール
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# httpポートの公開 ここにクライアントがAPIを投げる
EXPOSE 4561
