# ベースイメージ
FROM golang:1.22.2-bullseye

# aptでパッケージリストの更新とgitインストール
RUN apt update && apt install -y git

# デバッガインストール
RUN go install github.com/go-delve/delve/cmd/dlv@latest
