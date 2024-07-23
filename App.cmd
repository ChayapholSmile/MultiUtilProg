@echo off
chcp 65001
setlocal
cls

REM ตรวจสอบว่า Python ติดตั้งอยู่หรือไม่
python --version >nul 2>&1
if %errorlevel% neq 0 (
goto install_python

:install_python
    echo Python isn't installed, Downloading Python
    
    REM ตั้งค่าตำแหน่งสำหรับดาวน์โหลดและติดตั้ง Python
    set "PYTHON_INSTALLER=python-3.9.7-amd64.exe"
    set "PYTHON_URL=https://www.python.org/ftp/python/3.9.7/%PYTHON_INSTALLER%"

    REM ดาวน์โหลด Python
    powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile %PYTHON_INSTALLER%"

    REM ติดตั้ง Python
echo Python downloaded, Installing...
    start /wait %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1

    REM ลบไฟล์ติดตั้ง
echo Installed, Removing Installer
    del %PYTHON_INSTALLER%
)

goto app2

:removed
REM ติดตั้งไลบรารีที่จำเป็น
echo Installing library to check license
pip install gspread pandas

REM รันสคริปต์ Python
python assets\fetch_license.py

endlocal
goto app1

:app1
REM โหลดตัวแปรจาก license_vars.bat
if exist license_vars.bat (
    call license_vars.bat
    del license_vars.bat
) else (
cls
echo PLEASE BUY LICENSE.
pause>nul
exit
)


goto app2

:app2
cls
title โปรแกรมสารพัดอย่าง by ChayapholSmile
set select=""
echo ======ABOUT PROGRAM======
echo A1. About Program
echo A2. Update Program
echo A3. Exit
echo ======USB DRIVE======
echo U1. Change Drive Letter
echo U2. Remove Read-Only
echo ======DISK MANAGEMENT======
echo D1. Create Virtual Partition
echo D2. Remove Virtual Partition
echo ======GENERAL======
echo G1. Create Directory
echo G2. Remove Directory
echo G3. Remove File
echo G4. View IP Configuration
set /p select=Select (e.g. A0):
goto check

:check
goto %select%
echo Please select again (Not Found)
ping localhost
goto app2


:A1
cls
title โปรแกรมสารพัดอย่าง by ChayapholSmile - เกี่ยวกับโปรแกรม
echo Issuer: %ISSUER%
echo Issued to: %ISSUED_TO%
echo Package: %PACKAGE%
pause>nul
goto app2

:A2
call update.cmd
goto app2

:A3
exit


:U1
title โปรแกรมสารพัดอย่าง by ChayapholSmile - เปลี่ยนตัวอักษรไดร์ฟ
	fsutil dirty query %systemdrive% >nul
	if %errorlevel% == 0 goto :IsRun
	( echo Set UAC = CreateObject^("Shell.Application"^)
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1
	)> "%temp%\RunAdmin.vbs"
	"%temp%\RunAdmin.vbs"
	del "%temp%\RunAdmin.vbs"
goto :eof
:IsRun
			
:: ปิดการใช้งาน UAC ชั่วคราว
setlocal

set /p driveLetterOld=Old Drive Letter:
set /p driveLetterNew=New Drive Letter:

echo Drive letter change script
echo Current drive letter: %driveLetterOld%
echo New drive letter: %driveLetterNew%
echo.

:: ถามผู้ใช้ว่าต้องการดำเนินการต่อหรือไม่
set /p userInput=Do you want to proceed with changing the drive letter? (Y/N): 

if /I "%userInput%" NEQ "Y" (
    echo Operation cancelled.
    goto app2
)

echo Changing drive letter from %driveLetterOld% to %driveLetterNew%

:: ใช้ PowerShell เพื่อเปลี่ยนตัวอักษรไดรฟ์
powershell -Command "Get-Partition -DriveLetter '%driveLetterOld:~0,1%' | Set-Partition -NewDriveLetter '%driveLetterNew:~0,1%'"

echo Drive letter change complete.
pause

goto app2

:U2
setlocal

:: Specify the drive letter here
set DRIVE=C

:: Remove Read-Only attribute from specified drive
attrib -r "%DRIVE%:\*.*" /s /d

echo Removed Read-Only attribute from %DRIVE%:\
pause
goto app2

:D1
title โปรแกรมสารพัดอย่าง by ChayapholSmile - สร้างไดร์ฟเสมือน
set path=""
set drivelet=""
set /p path=Path to folder to create new volume:
set /p drivelet=Drive Letter:
echo Wait a second...
subst %drivelet%: %path%
echo Success
goto app2

:D2
title โปรแกรมสารพัดอย่าง by ChayapholSmile - ลบไดร์ฟเสมือน
set drivelet=""
set /p drivelet=Drive Letter:
echo Wait a second...
subst %drivelet%: /d
echo Success
goto app2

:G1
title โปรแกรมสารพัดอย่าง by ChayapholSmile - สร้างโฟลเดอร์
set dirname=""
set/p dirname=Directory Name:
mkdir %dirname%
goto app2

:G2
title โปรแกรมสารพัดอย่าง by ChayapholSmile - ลบโฟลเดอร์
set dirname=""
set/p dirname=Directory Name:
rmdir %dirname%
goto app2

:G3
title โปรแกรมสารพัดอย่าง by ChayapholSmile - ลบไฟล์
set filename=""
set /p filename=File Name:
del %filename%
goto app2

:G4
title โปรแกรมสารพัดอย่าง by ChayapholSmile - ดูสถานะอินเทอร์เน็ตโปรโตคอล
ipconfig
pause>nul
goto app2

:G5
title โปรแกรมสารพัดอย่าง by ChayapholSmile - ดูว่าเครื่องกำลังทำอะไรอยู่
tasklist
pause>nul
goto app2