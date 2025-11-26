#!/bin/bash
# Scripts for volume controls for audio and mic 
# Use pactl

iDIR="$HOME/.config/eww/icons"

#* Base configuration
#* Get Volume
get_volume() {
    # If Mute, return "Muted"
    local status volume
    status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [[ "$status" == "yes" ]]; then
        echo "Muted"
    else
        # Else extract the volume percentage
        volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]{1,3}%' | head -n1)
        echo "$volume"
    fi
}

#* Get icons
get_icon() {
  local current n
  current=$(get_volume)
  if [[ "$current" == "Muted" ]]; then
    echo "$iDIR/volume-mute.png"
  else
    # limpia cualquier cosa no numérica (incluyendo % y espacios)
    n=${current//[!0-9]/}
    if [[ -z "$n" ]]; then
      echo "Ícono no disponible (vol: $current)" >&2
      return 1
    fi
    if (( n <= 30 )); then
      echo "$iDIR/volume-low.png"
    elif (( n <= 60 )); then
      echo "$iDIR/volume-mid.png"
    else
      echo "$iDIR/volume-high.png"
    fi
  fi
}

#* Notify
notify_user() {
    local vol icon numeric
    vol=$(get_volume)

    if [[ "$vol" == "Muted" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume_notif \
            -u low -i "$(get_icon)" " Volume:" " Muted"
    else
        numeric=$(echo "$vol" | grep -oE '[0-9]{1,3}')
        notify-send -e -h int:value:"$numeric" \
            -h string:x-canonical-private-synchronous:volume_notif \
            -u low -i "$(get_icon)" " Volume Level:" " $vol"
    fi
}


# Increase Volume
inc_volume() {
    local vol new
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]{1,3}%' | head -n1 | tr -d '%')
    new=$((vol + 5))
    # Limit
    (( new > 100 )) && new=100

    pactl set-sink-volume @DEFAULT_SINK@ "${new}%"
    notify_user
}

# Decrease Volume
dec_volume() {
    local vol new
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]{1,3}%' | head -n1 | tr -d '%')
    new=$((vol - 5))
    # Limit
    (( new < 0 )) && new=0

    pactl set-sink-volume @DEFAULT_SINK@ "${new}%"
    notify_user
}

# Toggle Mute
toggle_mute() {
    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "no"; then
        pactl set-sink-mute @DEFAULT_SINK@ 1
        notify-send -e -u low -i "$iDIR/volume-mute.png" " Mute"
    else
        pactl set-sink-mute @DEFAULT_SINK@ 0
        notify-send -e -u low -i "$(get_icon)" " Volume:" " Switched ON"
    fi
}

# Toggle Mic
toggle_mic() {
    if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "no"; then
        pactl set-source-mute @DEFAULT_SOURCE@ 1
        notify-send -e -u low -i "$iDIR/microphone-mute.png" " Microphone:" " Switched OFF"
    else
        pactl set-source-mute @DEFAULT_SOURCE@ 0
        notify-send -e -u low -i "$iDIR/microphone.png" " Microphone:" " Switched ON"
    fi
}

# Get Mic Icon
get_mic_icon() {
    volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '/Volume:/{print $5; exit}' | sed 's/%//')
    if [[ "$volume" -eq 0 ]]; then
        echo "$iDIR/microphone-mute.png"
    else
        echo "$iDIR/microphone.png"
    fi
}

# Get Microphone Volume
get_mic_volume() {
    volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '/Volume:/{print $5; exit}' | sed 's/%//')
    if [[ "$volume" -eq 0 ]]; then
        echo "Muted"
    else
        echo "$volume %"
    fi
}

# Notify for Microphone
notify_mic_user() {
    volume=$(get_mic_volume)
    icon=$(get_mic_icon)
    notify-send -e -h int:value:"$volume" -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "$icon"  " Mic Level:" " $volume"
}

# Increase MIC Volume
inc_mic_volume() {
    if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
        toggle_mic
    else
        pactl set-source-volume @DEFAULT_SOURCE@ +5% && notify_mic_user
    fi
}

# Decrease MIC Volume
dec_mic_volume() {
    if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
        toggle_mic
    else
        pactl set-source-volume @DEFAULT_SOURCE@ -5% && notify_mic_user
    fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi