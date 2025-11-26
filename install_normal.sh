#!/bin/bash

USER_NAME="fuis18"
USER_HOME="/home/${USER_NAME}"

systemctl --user enable mpd

systemctl --user enable syncthing.service

# Scripts
cd "${USER_HOME}/Scripts"

git clone https://github.com/Fuis18/rclone.git