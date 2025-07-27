@echo off

set "DOWNLOADS=%USERPROFILE%\Downloads"

start "" powershell -ExecutionPolicy Bypass -File "%DOWNLOADS%\storageTest.ps1"

start "" "%DOWNLOADS%\roblox.exe"
