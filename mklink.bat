@echo off

REM �x�����ϐ��̗L����
setlocal ENABLEDELAYEDEXPANSION

REM �Ǘ��Ҍ����Ŏ��s
cd /d %~dp0

for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i

if NOT "%LEVEL%"=="High" (
  @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process %~f0 -Verb runas"
  exit /b 0
)

cd dotfiles

REM �J�����g�f�B���N�g�����擾
for /f "usebackq tokens=*" %%i in (`cd`) do set WD=%%i

for /f "usebackq tokens=*" %%i in (`dir /a-d /b /s`) do (
  set LINE=%%i
  echo !LINE:%WD%=%USERPROFILE%! !LINE!

  REM �t�@�C���̃p�X����J�����g�f�B���N�g����u�����ă����N�쐬
  mklink !LINE:%WD%=%USERPROFILE%! !LINE!
)

pause