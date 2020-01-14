@echo off

where docker 2> nul > nul
if errorlevel 1 echo Requires docker >&2 & exit /b 1

setlocal
cd /d %~dp0
for /f "usebackq tokens=*" %%i in (`docker images -q easy-rsa-shell`) do set iid=%%i
if "%iid%" == "" echo Building easy-rsa-shell docker image. Wait a minute...
docker build -q -t easy-rsa-shell ./ > NUL
endlocal

setlocal enabledelayedexpansion

set arg=%1
if !arg! == !! goto HELP
set arg=%arg:~0,1%
if !arg! == - goto HELP

set args=%*
set args=!args:*%1=!

set arg=%2
if !arg! == !! goto SHELL
set arg=%arg:~0,1%
if !arg! == - goto SHELL

if exist %1.lock (set /p cid=<%1.lock) ELSE set cid=
if "%cid%" == "" echo Data file is not open. >&2 & exit /b 1

set arg=%2
if !arg! == password goto PASSWORD
goto COMMAND

:HELP
  docker run easy-rsa-shell easy-rsa-shell %*
  exit /b

:SHELL
  if not exist %1 copy NUL %1 >NUL
  if exist %1.lock (
    echo File '%1' already opened. If it is not opened by >&2
    echo another process really, delete '%1.lock' manually. >&2
    exit /b 1
  )
  set opts=-e EASY_RSA_SHELL_ALLOW_WEAK_PASSWORD -e EASY_RSA_SHELL_PASSWORD
  set opts=-it --privileged -v /data %opts% easy-rsa-shell easy-rsa-shell
  for /f "usebackq tokens=*" %%i in (`docker create %opts% %args%`) do set cid=%%i
  echo %cid% > %1.lock
  docker cp %1 %cid%:/data/%cid:~0,12%
  docker start -ai %cid%
  set error=%ERRORLEVEL%
  if not exist %1.lock GOTO ABORT
  if %error% neq 0 GOTO ABORT
  docker cp %cid%:/data/%cid:~0,12% %1.tmp
  del %1
  ren %1.tmp %~n1
:ABORT
  del %1.lock 2> NUL
  docker rm -v %cid% > NUL
  exit /b

:PASSWORD
  set opts=-e EASY_RSA_SHELL_ALLOW_WEAK_PASSWORD
  docker exec -it %opts% %cid% easy-rsa-shell %args%
  exit /b

:COMMAND
  docker exec -i %cid% easy-rsa-shell %args%
  exit /b
