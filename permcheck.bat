@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul

rem Укажите путь к aapt.exe
set aapt_path="aapt.exe"

if "%~1"=="" (
    echo Требуется указать путь к apk в качестве аргумента: %0 ^<путь к apk^>
    exit /b 1
)

set "file_path=%~1"

rem Получаем список пермишенов из apk с помощью aapt
for /f "delims=" %%i in ('%aapt_path% d permissions %file_path%') do (
    set "line=%%i"
    if "!line:uses-permission=!" neq "!line!" (
        rem Ничего не делаем
    )
    set "permissions=!permissions!!line!"
)

rem Полный список запрещенных пермишенов
set "forbidden_permissions=ru.evotor.permissions.KKM_DRIVER ru.evotor.permissions.ACCESS_KKM_SERVICE ru.evotor.permission.internal.SYSTEM android.permission.CLOUDPOS_PRINTER android.permission.CLOUDPOS_SERIAL com.pos.permission.ACCESSORY_DATETIME com.pos.permission.ACCESSORY_LED com.pos.permission.ACCESSORY_BEEP com.pos.permission.ACCESSORY_RFREGISTER com.pos.permission.CARD_READER_ICC com.pos.permission.CARD_READER_PICC com.pos.permission.CARD_READER_MAG com.pos.permission.COMMUNICATION com.pos.permission.PRINTER com.pos.permission.SECURITY com.pos.permission.EMVCORE ru.evotor.drivers.kkm.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION ru.evotor.permission.internal.USB_VOLUME_STATE_CHANGE android.software.device_admin android.permission.UPDATE_LOCK_TASK_PACKAGES android.permission.CHANGE_WIFI_STATE android.permission.REBOOT android.permission.BIND_DEVICE_ADMIN android.permission.MANAGE_PROFILE_AND_DEVICE_OWNERS android.permission.MOUNT_UNMOUNT_FILESYSTEMS android.permission.WRITE_SETTINGS android.permission.WRITE_SECURE_SETTINGS android.permission.SET_TIME android.permission.SET_TIME_ZONE ru.evotor.permission.receipt.printExtra.ZSET"

rem Поиск запрещенных пермишенов
for %%i in (%forbidden_permissions%) do (
    echo !permissions! | findstr /C:"%%i" >nul
    if !errorlevel! equ 0 (
        set "intersecting_permissions=!intersecting_permissions!%%i "
    )
)

rem Вывод списка имеющихся в приложении пермишенов
for /f "delims=" %%i in ('%aapt_path% d permissions %file_path%') do (
    set "line=%%i"
    if "!line:package=!" neq "!line!" (
        set "package_line=!line:package=приложении!"
        echo Список пермишенов в  !package_line::=!:
    ) else (
        echo !line!
    )
)

echo.

rem Вывод списка запрещенных пермишенов
if "!intersecting_permissions!"=="" (
    echo Нет запрещенных пермишенов.
    echo.
) else (
    echo Обнаружены запрещенные пермишены:
    for %%i in (!intersecting_permissions!) do (
        echo %%i
    )
)
