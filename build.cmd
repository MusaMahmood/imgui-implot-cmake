@echo off
setlocal enabledelayedexpansion

REM ==============================
REM Validate arguments
REM ==============================
if "%~1"=="" (
    echo Usage: build.cmd [Debug^|Release]
    exit /b 1
)

set CONFIG=%~1

if /I "%CONFIG%"=="Debug" (
    set CFLAGS=/MDd /Od /Z7 /DDEBUG
    set LIB_PATH=build\Debug
) else if /I "%CONFIG%"=="Release" (
    set CFLAGS=/MD /O2 /DNDEBUG
    set LIB_PATH=build\Release
) else (
    echo Invalid configuration: %CONFIG%
    echo Usage: build.cmd [Debug^|Release]
    exit /b 1
)

set OBJDIR=obj

if not exist "%LIB_PATH%" mkdir "%LIB_PATH%"
if not exist "%OBJDIR%" mkdir "%OBJDIR%"

REM ==============================
REM Settings
REM ==============================
set LIB_NAME=imgui

set SRC_FILES=^
  imgui_unity.cpp

set INCLUDE_DIRS=^
  /Iimgui ^
  /Iimplot ^
  /Iimgui\backends

REM ==============================
REM Build static library
REM ==============================
echo Building static library %LIB_NAME% (%CONFIG%)

REM Compile each source file into an object
for %%f in (%SRC_FILES%) do (
    cl /nologo /EHsc /DWIN32 /wd4530 %CFLAGS% %INCLUDE_DIRS% /c %%f /Fo%OBJDIR%\%%~nf.obj
)

REM Create static library
lib /OUT:%LIB_PATH%\%LIB_NAME%.lib %OBJDIR%\*.obj

REM Cleanup object files
rd /s /q "%OBJDIR%"
