#!/bin/bash
#source ~/.zshrc  

bold=$(tput bold)
normal=$(tput sgr0)

if [ $# -ne 1 ]; then
    echo "Требуется указать путь к apk в качестве аргумента: $0 <путь к apk>"
    exit 1
fi

file_path=$1

# Получаем список пермишенов из apk с помощью aapt (путь до android-tools должен быть добавлен в список переменных сред)
permissions=$(aapt d permissions $file_path)
IFS=$'\n' read -rd '' -a permissions_array <<< "$permissions"

# Полный список запрещенных пермишенов
forbidden_permissions=("ru.evotor.permissions.KKM_DRIVER" "ru.evotor.permissions.ACCESS_KKM_SERVICE" "ru.evotor.permission.internal.SYSTEM" "android.permission.CLOUDPOS_PRINTER" "android.permission.CLOUDPOS_SERIAL" "com.pos.permission.ACCESSORY_DATETIME" "com.pos.permission.ACCESSORY_LED" "com.pos.permission.ACCESSORY_BEEP" "com.pos.permission.ACCESSORY_RFREGISTER" "com.pos.permission.CARD_READER_ICC" "com.pos.permission.CARD_READER_PICC" "com.pos.permission.CARD_READER_MAG" "com.pos.permission.COMMUNICATION" "com.pos.permission.PRINTER" "com.pos.permission.SECURITY" "com.pos.permission.EMVCORE" "ru.evotor.drivers.kkm.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION" "ru.evotor.permission.internal.USB_VOLUME_STATE_CHANGE" "android.software.device_admin" "android.permission.UPDATE_LOCK_TASK_PACKAGES" "android.permission.CHANGE_WIFI_STATE" "android.permission.REBOOT" "android.permission.BIND_DEVICE_ADMIN" "android.permission.MANAGE_PROFILE_AND_DEVICE_OWNERS" "android.permission.MOUNT_UNMOUNT_FILESYSTEMS" "android.permission.WRITE_SETTINGS" "android.permission.WRITE_SECURE_SETTINGS" "android.permission.SET_TIME" "android.permission.SET_TIME_ZONE" "ru.evotor.permission.receipt.printExtra.ZSET")

# Поиск запрещенных пермишенов
intersecting_permissions=()
for var in "${permissions_array[@]}"; do
    for forbidden_var in "${forbidden_permissions[@]}"; do
        if [[ "$var" == *"$forbidden_var"* ]]; then
            intersecting_permissions+=("$var")
        fi
    done
done

# Вывод списка имеющихся в приложении пермишенов
permissions=${permissions/package: /}
echo "Список пермишенов в приложении $permissions"
echo ""


# Вывод списка запрещенных пермишенов
if [ ${#intersecting_permissions[@]} -eq 0 ]; then
    echo "${bold}Нет запрещенных пермишенов.${normal}"
    echo ""
else
    echo "${bold}Обнаружены запрещенные пермишены:${normal}"
    for var in "${intersecting_permissions[@]}"; do
        echo "$var"
    done
    echo ""
fi
