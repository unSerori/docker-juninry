#!/bin/bash

# コンテナの再起動を行うが、イメージの再構築や更新された設定は反映させない

# 再起動(stop + start)
docker compose -f compose.yml -f compose.develop.yml restart
