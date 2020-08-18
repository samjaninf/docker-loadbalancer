#!/bin/sh
set -e 

log() {
    echo "[INFO] $1"
}

log "Updating user ID, GID and name..."
sudo usermod -u $USER_ID $USER_NAME
sudo groupmod -g $USER_GID $USER_NAME

log "Updating file permissions..."
sudo chown -R $USER_NAME:$USER_NAME /opt/sitepilot

log "Done!"

exec "$@"