# 開発用やビルド用の共通ステージ

# Stage0: goの入ったイメージ
FROM golang:1.22.2-bullseye AS base

# aptでパッケージリストの更新とgitインストール
RUN apt-get update && \
    apt-get install -y git

# 開発用のステージ

# Stage1: 開発環境に必要なツールとソースを入れるベースイメージ
FROM base AS develop

# 作業ディレクトリ
WORKDIR /root/copy

# 必要なものインストール
RUN \
    # ssh通信のためのクライアント
    apt-get install -y git openssh-client && \
    # デバッガインストール
    go install github.com/go-delve/delve/cmd/dlv@latest

# 必要なファイルのコピー
COPY .env.go-api .env

# httpポートの公開 ここにクライアントがAPIを投げる
EXPOSE 4561

# 実行用のスクリプトをコピー
COPY ./init.sh .
RUN chmod +x ./init.sh

# スクリプトで起動
ENTRYPOINT [ "./init.sh" ]

# デプロイ用のステージ

# Stage1: ビルドのためのgoが入ったイメージ
FROM base AS deploy-builder

# 作業ディレクトリ
WORKDIR /root/

# ソースコードのクローン
RUN git clone https://github.com/unSerori/juninry-api.git -b main
# 必要なリソースを渡す
COPY ./share/images/ ./juninry-api/view/views/assets/images/
# ビルド処理
RUN \
    # 移動
    cd ./juninry-api && \
    # ビルド なお、deploy-builderイメージにgo実行環境が入ってるのでビルドツールのDLは不要
    go build -o juninry-go-api

# Stage2: 公開用のための軽量debian
FROM debian:bullseye-slim AS deploy-final

# 作業ディレクトリ
WORKDIR /usr/local/bin/

# 成果物のコピー
COPY --from=deploy-builder /root/juninry-api/juninry-go-api juninry-go-api
# 実行に必要なファイルのコピー
COPY .env.go-api .env

# httpポートの公開 ここにクライアントがAPIを投げる
EXPOSE 4561

# ビルド済みの実行ファイルを本番環境でCMD起動
ENTRYPOINT [ "juninry-go-api" ]
