@echo off
setlocal

REM กำหนดตำแหน่งของโปรแกรมหลัก
set "install_dir=%~dp0"

REM ตั้งค่าตัวแปร
set "repo_url=https://github.com/ChayapholSmile/MultiUtilProg/archive/refs/heads/main.zip"
set "zip_file=%install_dir%update.zip"
set "extract_dir=%install_dir%repository-main"

REM ดาวน์โหลดไฟล์ ZIP จาก GitHub
echo Downloading update from %repo_url%...
powershell -Command "Invoke-WebRequest -Uri '%repo_url%' -OutFile '%zip_file%'"

REM ตรวจสอบว่าการดาวน์โหลดสำเร็จ
if %ERRORLEVEL% neq 0 (
    echo Failed to download update.
    exit /b 1
)

REM แตกไฟล์ ZIP
echo Extracting update...
powershell -Command "Expand-Archive -Path '%zip_file%' -DestinationPath '%extract_dir%' -Force"

REM ตรวจสอบว่าการแตกไฟล์สำเร็จ
if %ERRORLEVEL% neq 0 (
    echo Failed to extract update.
    exit /b 1
)

REM สำรองไฟล์เดิม
echo Backing up old version...
xcopy "%install_dir%" "%install_dir%backup" /s /e /y

REM คัดลอกไฟล์ใหม่ไปยังไดเรกทอรีการติดตั้ง
echo Installing new version...
xcopy "%extract_dir%\*" "%install_dir%" /s /e /y

REM ตรวจสอบว่าการติดตั้งสำเร็จ
if %ERRORLEVEL% neq 0 (
    echo Failed to install new version.
    exit /b 1
)

REM ทำความสะอาด
echo Cleaning up...
del "%zip_file%"
rmdir /s /q "%extract_dir%"

echo Update completed successfully!
pause
exit
