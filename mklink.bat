@echo off

REM �x�����ϐ��̗L����
setlocal ENABLEDELAYEDEXPANSION

REM �X�N���v�g���u����Ă���ꏊ���J�����g�f�B���N�g���ɂ���
cd /d %~dp0

REM �Ǘ��Ҍ����Ŏ��s
for /f "tokens=3 delims=\ " %%i in ('%SYSTEMROOT%\System32\whoami.exe /groups^|%SYSTEMROOT%\System32\find "Mandatory"') do set LEVEL=%%i

if NOT "%LEVEL%"=="High" (
  @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process %~f0 -Verb runas"
  exit /b 0
)


cd dotfiles

REM �J�����g�f�B���N�g�����擾
for /f "usebackq tokens=*" %%i in (`cd`) do set WD=%%i

REM �r���̃f�B���N�g�������݂��Ȃ��Ƃ��쐬
for /f "usebackq tokens=*" %%i in (`dir /ad /b /s`) do (
  set LINE=%%i
  set DIR=!LINE:%WD%=%USERPROFILE%!

  if NOT EXIST "!DIR!" (
    REM �t�@�C���E�t�H���_�����݂��Ȃ�
    mkdir !DIR!
  ) else if NOT EXIST "!DIR!\" (
    REM �t�H���_�����݂��Ȃ�
    mshta vbscript:execute^("MsgBox(""Cannot create !DIR!""),16:close"^)
  )
)


for /f "usebackq tokens=*" %%i in (`dir /a-d /b /s`) do (
  set LINE=%%i
  set FILE=!LINE:%WD%=%USERPROFILE%!

  if NOT EXIST "!FILE!" (
    REM �t�@�C���̃p�X����J�����g�f�B���N�g����u�����ă����N�쐬
    mklink !LINE:%WD%=%USERPROFILE%! !LINE!
  )
)
