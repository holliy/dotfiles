#!/bin/bash

# スクリプトが置かれている場所をカレントディレクトリにする
cd "$(dirname "$0")"

# terminfoファイルのコンパイル
ls -1 terminfo/* | xargs -n1 tic -x

# homebrewをインストール
if ! { which brew >/dev/null 2>&1; }; then
  echo "Installing homebrew..."
  if ! { which curl >/dev/null 2>&1; }; then
    echo "curl is required to install homebrew"
    exit 1
  fi

  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ $? -ne 0 ]; then
    exit 1
  fi

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

DOTTER=dotter

if ! { which $DOTTER >/dev/null 2>&1; }; then
  echo "Installing dotter..."
  brew install dotter
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

