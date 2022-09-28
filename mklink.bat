@echo off

REM 遅延環境変数の有効化
setlocal ENABLEDELAYEDEXPANSION

REM 実行ファイルをカレントディレクトリから探さない
set NODEFAULTCURRENTDIRECTORYINEXEPATH=1

REM スクリプトが置かれている場所をカレントディレクトリにする
cd /d %~dp0

REM 管理者権限で実行
for /f "tokens=3 delims=\ " %%i in ('%SYSTEMROOT%\System32\whoami.exe /groups^|%SYSTEMROOT%\System32\find "Mandatory"') do set LEVEL=%%i

if NOT "%LEVEL%"=="High" (
  @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process %~f0 -Verb runas"
  exit /b 0
)

set DOTTER=dotter.exe

where /q %DOTTER%
if not %ERRORLEVEL% == 0 (
  echo %DOTTER%: not found in %%PATH%%
  echo Download from https://github.com/SuperCuber/dotter/releases
  exit /b 1
) else if exist %DOTTER% (
  REM whereコマンドはカレントディレクトリも見るので追加で分岐する
  echo %DOTTER%: not found in %%PATH%%
  echo Download from https://github.com/SuperCuber/dotter/releases
  exit /b 1
)

cd dotfiles

%DOTTER% deploy --local-config .dotter/windows.toml
pause

