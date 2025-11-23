# $HOME/.config/hypr/scripts/Bluetooth.sh
#!/bin/bash
set -eu -o pipefail

# Verifica si Bluetooth está encendido
is_powered() {
    bluetoothctl show 2>/dev/null | grep -q "Powered: yes"
}

# Cuenta dispositivos conectados
connected_count() {
    cnt=0
    devices=$(bluetoothctl devices 2>/dev/null)
    [ -z "$devices" ] && echo 0 && return
    while IFS= read -r line; do
        mac=$(awk '{print $1}' <<<"$line")
        if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
            cnt=$((cnt+1))
        fi
    done <<< "$devices"
    echo "$cnt"
}

# Estado principal para la barra
cmd_status() {
    if is_powered; then
        c=$(connected_count)
        echo "{\"text\":\" $c\",\"class\":\"on\"}"
    else
        echo "{\"text\":\"\",\"class\":\"off\"}"
    fi
}

# Alternar bluetui (o abrirlo)
cmd_menu() {
    kitty -e bluetui
}

# Dispatcher
case "${1-}" in
    ""|status) cmd_status ;;
    menu) cmd_menu ;;
    *) cmd_status ;;
esac
