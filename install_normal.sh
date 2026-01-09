#!/bin/bash

# Manejo de errores
set -euo pipefail

USER_NAME="fuis18"
USER_HOME="/home/${USER_NAME}"

systemctl --user enable mpd

systemctl --user enable syncthing.service
systemctl --user start syncthing.service

# Scripts
cd "${USER_HOME}/Scripts"

git clone https://github.com/fuis18/rclone.git