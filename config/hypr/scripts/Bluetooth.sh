#!/usr/bin/env bash
set -eu -o pipefail

# Ruta del script: $HOME/.config/hypr/scripts/Bluetooth.sh
# Requisitos: bluez + bluez-utils, yofi, kitty, notify-send
# Nota: se usa yofi y kitty explícitamente (sin detección automática).

# Helper: mostrar ayuda mínima
usage() {
  cat <<EOF
Bluetooth.sh [status|menu|toggle|power_on|power_off|openctl]
  status     -> imprime estado corto (para waybar)
  menu       -> abre un menú con acciones vía yofi
  toggle     -> alterna power on/off
  power_on   -> fuerza power on
  power_off  -> fuerza power off
  openctl    -> abre kitty -e bluetoothctl
EOF
}

# Notificaciones (según tu preferencia)
notify() {
  # notify-send -e -u low "Bluetooth" "mensaje"
  notify-send -e -u low "Bluetooth" "$1"
}

# Devuelve "yes" si Powered: yes
is_powered() {
  bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2}' | grep -q '^yes$'
}

# Cuenta dispositivos conectados
connected_count() {
  local cnt=0
  while IFS= read -r line; do
    mac=$(awk '{print $1}' <<<"$line")
    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
      cnt=$((cnt+1))
    fi
  done < <(bluetoothctl devices 2>/dev/null)
  echo "$cnt"
}

# Lista dispositivos "MAC Name..." (sin prefijo "Device ")
list_devices() {
  bluetoothctl devices 2>/dev/null | sed 's/^Device //'
}

# Imprime estado compacto para waybar
cmd_status() {
  if is_powered; then
    local c
    c=$(connected_count)
    if [ "$c" -gt 0 ]; then
      # icon + número de conexiones
      printf " %s" "$c"
    else
      # icon sin número (enchufado pero sin conexiones)
      printf ""
    fi
  else
    printf " off"
  fi
}

# Menú interactivo con yofi
cmd_menu() {
  # Opciones
  options=(
    "Abrir bluetoothctl"
    "Alternar energía"
    "Encender"
    "Apagar"
    "Conectar dispositivo"
    "Desconectar dispositivo"
    "Ver dispositivos"
  )

  selection=$(printf "%s\n" "${options[@]}" | yofi -i -p "Bluetooth" ) || exit 0

  case "$selection" in
    "Abrir bluetoothctl")
      kitty -e bluetoothctl &
      ;;
    "Alternar energía")
      "$0" toggle &
      ;;
    "Encender")
      bluetoothctl power on >/dev/null 2>&1 && notify "Encendido" || notify "Error al encender"
      ;;
    "Apagar")
      bluetoothctl power off >/dev/null 2>&1 && notify "Apagado" || notify "Error al apagar"
      ;;
    "Conectar dispositivo")
      devices=$(list_devices)
      if [ -z "$devices" ]; then
        notify "No hay dispositivos disponibles"
        exit 0
      fi
      sel=$(printf "%s\n" "$devices" | yofi -i -p "Conectar a:" ) || exit 0
      mac=$(awk '{print $1}' <<<"$sel")
      if [ -n "$mac" ]; then
        bluetoothctl connect "$mac" >/dev/null 2>&1 && notify "Conectado: ${sel#"$mac "}" || notify "Error al conectar $mac"
      fi
      ;;
    "Desconectar dispositivo")
      devices=$(list_devices)
      if [ -z "$devices" ]; then
        notify "No hay dispositivos disponibles"
        exit 0
      fi
      sel=$(printf "%s\n" "$devices" | yofi -i -p "Desconectar:" ) || exit 0
      mac=$(awk '{print $1}' <<<"$sel")
      if [ -n "$mac" ]; then
        bluetoothctl disconnect "$mac" >/dev/null 2>&1 && notify "Desconectado: ${sel#"$mac "}" || notify "Error al desconectar $mac"
      fi
      ;;
    "Ver dispositivos")
      devices=$(list_devices)
      if [ -z "$devices" ]; then
        notify "No hay dispositivos"
        exit 0
      fi
      # muestra la lista; si eliges uno, muestra info en notification
      sel=$(printf "%s\n" "$devices" | yofi -i -p "Dispositivos (escoge para ver info):" ) || exit 0
      mac=$(awk '{print $1}' <<<"$sel")
      if [ -n "$mac" ]; then
        info=$(bluetoothctl info "$mac" 2>/dev/null)
        # recortar salida larga si hace falta
        notify "${sel#"$mac "}" "$(printf '%s\n' "$info" | head -n 20)"
      fi
      ;;
    *)
      # cancel / nada
      ;;
  esac
}

# Alternar power
cmd_toggle() {
  if is_powered; then
    bluetoothctl power off >/dev/null 2>&1 && notify "Bluetooth apagado" || notify "Error al apagar"
  else
    bluetoothctl power on >/dev/null 2>&1 && notify "Bluetooth encendido" || notify "Error al encender"
  fi
}

# Forzar power on
cmd_power_on() {
  bluetoothctl power on >/dev/null 2>&1 && notify "Bluetooth encendido" || notify "Error al encender"
}

# Forzar power off
cmd_power_off() {
  bluetoothctl power off >/dev/null 2>&1 && notify "Bluetooth apagado" || notify "Error al apagar"
}

# Abrir bluetoothctl en kitty
cmd_openctl() {
  kitty -e bluetoothctl &
}

# Main dispatcher
case "${1-}" in
  ""|status) cmd_status ;;
  menu) cmd_menu ;;
  toggle) cmd_toggle ;;
  power_on) cmd_power_on ;;
  power_off) cmd_power_off ;;
  openctl) cmd_openctl ;;
  -h|--help) usage ;;
  *) usage ;;
esac

# "bluetooth": {
# 		"format-disabled": "<span> </span>",
# 		"format-connected": "<span> </span>{num_connections}",
# 		"tooltip-format": "<span> </span>{device_alias}",
# 		"tooltip-format-connected": "{device_enumerate}",
# 		"tooltip-format-enumerate-connected": "<span> </span>{device_alias}",
# 		"on-click": "kitty -e bluetoothctl",
# 		"on-click-right": "bluetoothctl power off",
# 		"on-click-middle": "bluetoothctl power on",
# 		"max-length": 20,
# 		"interval": 10
# 	},