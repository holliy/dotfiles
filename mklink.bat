@echo off

REM 遅延環境変数の有効化
setlocal ENABLEDELAYEDEXPANSION

REM 管理者権限で実行
cd /d %~dp0

for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i

if NOT "%LEVEL%"=="High" (
  @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process %~f0 -Verb runas"
  exit /b 0
)

cd dotfiles

REM カレントディレクトリを取得
for /f "usebackq tokens=*" %%i in (`cd`) do set WD=%%i

for /f "usebackq tokens=*" %%i in (`dir /a-d /b /s`) do (
  set LINE=%%i
  echo !LINE:%WD%=%USERPROFILE%! !LINE!

  REM ファイルのパスからカレントディレクトリを置換してリンク作成
  mklink !LINE:%WD%=%USERPROFILE%! !LINE!
)

pause