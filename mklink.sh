#!/bin/bash

# スクリプトが置かれている場所をカレントディレクトリにする
CURDIR=$(dirname "$0")
cd "$CURDIR"

# terminfoファイルのコンパイル
ls -1 terminfo/* | xargs -n1 tic -x

DOTTER=dotter

if ! { which "$DOTTER" >/dev/null 2>&1; }; then
  if ! { which mise >/dev/null 2>&1; }; then
    echo "dotter and mise commands not found"
    exit 1
  fi

  echo "Installing dotter..."
  export MISE_GLOBAL_CONFIG_FILE="$(realpath $CURDIR)/dotfiles/config/mise/config.toml"
  mise install dotter
  DOTTER="mise exec dotter -- dotter"
fi

# 既存のファイルを退避
if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
  mv ~/.bashrc ~/.bashrc.bak
fi

cd dotfiles/

# TODO: 引数を取る
FORCE=0

if [ "$FORCE" = "1" ]; then
  $DOTTER --force --local-config .dotter/linux.toml --cache-file .dotter/$(hostname).toml deploy
else
  $DOTTER --local-config .dotter/linux.toml --cache-file .dotter/$(hostname).toml deploy
fi

