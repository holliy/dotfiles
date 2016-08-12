@echo off

REM 遅延環境変数(!i!)の有効化
setlocal ENABLEDELAYEDEXPANSION

REM 添え字をつけて変数を定義
set DOTFILE[0]="\.vimrc"
set DOTFILE[1]="\.gvimrc"
set DOTFILE[2]="\.vim\dein.vim"
set DOTFILE_N=2

REM set DOTDIR[0]=""
set DOTDIR_N=-1

REM foreachループ処理
for /L %%i in (0, 1, !DOTFILE_N!) do (
    mklink %USERPROFILE%!DOTFILE[%%i]! %USERPROFILE%"\dotfiles"!DOTFILE[%%i]!
)

for /L %%i in (0, 1, !DOTDIR_N!) do (
    mklink /D %USERPROFILE%!DOTDIR[%%i]! %USERPROFILE%"\dotfiles"!DOTDIR[%%i]!
)
