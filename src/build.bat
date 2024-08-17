@echo off

REM Change directory to the location of the script
cd /d %~dp0

REM Invoke the PowerShell script (build.ps1) in the same directory
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1"
