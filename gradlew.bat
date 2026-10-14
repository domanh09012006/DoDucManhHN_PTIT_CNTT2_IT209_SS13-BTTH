@echo off
setlocal
cd /d "%~dp0backend"
call .\gradlew.bat %*
exit /b %ERRORLEVEL%
