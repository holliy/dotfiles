#!/bin/bash

IFS_BAK=$IFS
IFS=$'\n'

# スクリプトが置かれている場所をカレントディレクトリにする
cd $(dirname $0)

WD=`pwd`
DIR=($(find dotfiles/ -mindepth 1 -type d))
FILE=($(find dotfiles/ -type f))

IFS=$IFS_BAK

# 途中のディレクトリが存在しないとき作成
for d in "${DIR[@]}"; do
  dd=${d/dotfiles/$HOME}
  if [ ! -e "${dd}" ]; then
    # ファイル・フォルダが存在しない
    mkdir "${dd}"
  elif [ ! -d "${dd}" ]; then
    # フォルダが存在しない
    echo "Cannot create ${dd}"
  fi
done

for f in "${FILE[@]}"; do
  df=${f/dotfiles/$HOME}
  if [ ! -f "${df}" ]; then
    ln -s ${WD}/${f} ${df}
  fi
done
