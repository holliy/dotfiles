@echo off

REM �x�����ϐ��̗L����
setlocal ENABLEDELAYEDEXPANSION

REM ���s�t�@�C�����J�����g�f�B���N�g������T���Ȃ�
set NODEFAULTCURRENTDIRECTORYINEXEPATH=1

REM �X�N���v�g���u����Ă���ꏊ���J�����g�f�B���N�g���ɂ���
cd /d %~dp0

REM �Ǘ��Ҍ����Ŏ��s
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
  REM where�R�}���h�̓J�����g�f�B���N�g��������̂Œǉ��ŕ��򂷂�
  echo %DOTTER%: not found in %%PATH%%
  echo Download from https://github.com/SuperCuber/dotter/releases
  exit /b 1
)

cd dotfiles

%DOTTER% deploy --local-config .dotter/windows.toml
pause

