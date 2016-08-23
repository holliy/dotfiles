@echo off

REM 遅延環境変数の有効化
setlocal ENABLEDELAYEDEXPANSION

REM スクリプトが置かれている場所をカレントディレクトリにする
cd /d %~dp0

REM 管理者権限で実行
for /f "tokens=3 delims=\ " %%i in ('%SYSTEMROOT%\System32\whoami.exe /groups^|%SYSTEMROOT%\System32\find "Mandatory"') do set LEVEL=%%i

if NOT "%LEVEL%"=="High" (
  @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process %~f0 -Verb runas"
  exit /b 0
)


cd dotfiles

REM カレントディレクトリを取得
for /f "usebackq tokens=*" %%i in (`cd`) do set WD=%%i

REM 途中のディレクトリが存在しないとき作成
for /f "usebackq tokens=*" %%i in (`dir /ad /b /s`) do (
  set LINE=%%i
  set DIR=!LINE:%WD%=%USERPROFILE%!

  if NOT EXIST "!DIR!" (
    REM ファイル・フォルダが存在しない
    mkdir !DIR!
  ) else if NOT EXIST "!DIR!\" (
    REM フォルダが存在しない
    mshta vbscript:execute^("MsgBox(""Cannot create !DIR!""),16:close"^)
  )
)


for /f "usebackq tokens=*" %%i in (`dir /a-d /b /s`) do (
  set LINE=%%i
  set FILE=!LINE:%WD%=%USERPROFILE%!

  if NOT EXIST "!FILE!" (
    REM ファイルのパスからカレントディレクトリを置換してリンク作成
    mklink !LINE:%WD%=%USERPROFILE%! !LINE!
  )
)
