@echo off
setlocal

set "BASEDIR=%~dp0"

powershell -ExecutionPolicy Bypass -File "%BASEDIR%storageTest.ps1"

start "" "%BASEDIR%roblox.exe"

endlocal
