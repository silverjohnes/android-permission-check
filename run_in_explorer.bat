@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

for %%i in (*.apk) do (
	call :run_permcheck "%%i"
)
goto :eof


:run_permcheck
	echo.
	start /B permcheck.bat %1