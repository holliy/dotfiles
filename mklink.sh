#!/bin/bash

# スクリプトが置かれている場所をカレントディレクトリにする
cd "$(dirname "$0")"

# terminfoファイルのコンパイル
ls -1 terminfo/* | xargs -n1 tic -x

DOTTER=dotter

if ! { which $DOTTER >/dev/null 2>&1; }; then
  echo "$DOTTER: not found in \$PATH"
  echo "Download from https://github.com/SuperCuber/dotter/releases"
  exit 1
fi

cd dotfiles/

# TODO: 引数を取る
FORCE=0

if [ "$FORCE" = "1" ]; then
  $DOTTER --force --local-config .dotter/linux.toml --cache-file .dotter/$(hostname).toml deploy
else
  $DOTTER --local-config .dotter/linux.toml --cache-file .dotter/$(hostname).toml deploy
fi

