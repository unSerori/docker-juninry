# 開発用やビルド用の共通ステージ

# Stage0: goの入ったイメージ
FROM golang:1.22.2-bullseye AS base

# aptでパッケージリストの更新とgitインストール
RUN apt update && \
    apt install -y git

# 開発用のステージ

# Stage1: 開発環境に必要なツールとソースを入れるベースイメージ
FROM base AS develop

# 作業ディレクトリ
WORKDIR /root/

# デバッガインストール
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# httpポートの公開 ここにクライアントがAPIを投げる
EXPOSE 4561

# デプロイ用のステージ

# Stage1: ビルドのためのgoが入ったイメージ
FROM base AS deploy-builder

# 作業ディレクトリ
WORKDIR /root/

# ビルド処理
RUN \
    # ソースコードのクローン
    git clone https://github.com/unSerori/juninry-api.git -b develop && \
    # ビルド なお、deploy-builderイメージにgo実行環境が入ってるのでビルドツールのDLは不要
    cd ./juninry-api && \
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

#ワンファイル化後のディレクトリ操作ハンドルミスのためのリカバリ ++++
RUN \
    # ディレクトリ存在確認
    mkdir -p ./common/logging && \
    touch ./common/logging/server.log && \
    # ファイル埋め込み
    mkdir -p ./view/views/scripts/ && \
    mkdir -p ./view/views/styles/ && \
    echo "// ヘッダー部の高さ分だけコンテンツを下げる\n// ヘッダー部分を取得\nconst header = document.querySelector('header');\nconst headerHeight = header.clientHeight;  // 高さをもらう\n\n// bodyの上marginに設定\ndocument.querySelector('main').style.paddingTop = headerHeight + 10 + 'px';" > ./view/views/scripts/common.js && \
    echo "body{\n    background-color: #0000ff;\n  }\n  * {\n      box-sizing: border-box;\n      margin: 0;\n      padding: 0;\n    }\n    \n    html,\n    body {\n      width: 100%;\n      height: 100%;\n    }\n    \n    html {\n      scroll-behavior: smooth;\n    }\n    \n    body {\n      font-family: 'Roboto', sans-serif;\n      font-size: 62.5%;\n      color: #111;\n      background-color: #fff;\n    }\n    \n    img {\n      box-sizing: content-box;\n      vertical-align: bottom;\n    }\n    \n    ul,\n    ol {\n      list-style: none;\n    }\n    \n    #wrapper-body {\n      padding-top: 70px;\n    }\n    \n    header {\n      box-sizing: border-box;\n      position: fixed;\n      top: 0;\n      left: 0;\n      z-index: 1;\n      width: 100%;\n      height: 70px;\n      background-color: rgba(255, 255, 255, 0.75);\n      padding: 25px;\n      border-bottom: 2px solid #000;\n    }\n    \n    #logo {\n      font-size: 2em;\n    }\n    \n    main {\n      width: 100%;\n      min-height: 100%;  \n      /* mainの最小サイズを親の100%に */\n      padding: 50px 12px;\n    }\n    \n    footer {\n      height: 140px;\n      background-color: #222;\n    }\n    \n    #copyright {\n      color: #fff;\n      font-size: 1.3em;\n      text-align: center;\n      padding-right: 25px;\n      margin-top: 23px;\n    }\n    \n    #topArea a {\n      display: block;\n      transition: ease-in-out 0.4s;\n      width: 100%;\n      background-color: #efefef;\n      color: #111;\n      font-weight: bold;\n      text-align: center;\n    }\n    \n    #topArea a:hover {\n      opacity: 0.95;\n    }\n    \n    #topArea .material-icons {\n      font-size: 4em;\n    }\n    \n    /* その他 */\n    /* font */\n    .font-weight-n {\n      font-weight: normal;\n    }\n    \n    .font-weight-b {\n      font-weight: bold;\n    }\n    \n    /* clearfix */\n    .clearfix:after {\n      content: \"\";\n      display: block;\n      clear: both;\n    }\n    " > ./view/views/styles/common.css && \
    echo "<!DOCTYPE html>\n<html lang=\"ja\">\n\n<head>\n	<meta charset=\"UTF-8\">\n	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n	<link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/icon?family=Material+Icons\">\n	<link rel=\"stylesheet\" href=\"styles/common.css\">\n	<title>Document</title>\n</head>\n\n<body>\n	<div id=\"wrapper-body\">\n		<header>\n			<h1 id=\"logo\">{{.topTitle}}/</h1>\n		</header>\n		<main>\n			<h2 style=\"font-weight: bold;\">{{.mainTitle}}</h2>\n			<label>time: </label>\n			<span>{{.time}}</span>\n			<div>{{.message}}</div>\n		</main>\n		<footer>\n			<div id=\"topArea\"><a href=\"#wrapper-body\"><i class=\"material-icons\">keyboard_arrow_up</i></a></div>\n			<p id=\"copyright\" class=\"font-weight-b\">\n				<small> &copy; <span id=\"year\">2024</span> unSerori </small>\n			</p>\n		</footer>\n		<script src=\"scripts/common.js\"></script>\n	</div>\n</body>\n\n</html>" > ./view/views/index.html
# ----

# ビルド済みの実行ファイルを本番環境でCMD起動
CMD [ "juninry-go-api" ]
