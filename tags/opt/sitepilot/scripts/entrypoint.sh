#!/bin/sh
set -e 

log() {
    echo "[INFO] $1"
}

log "Updating user ID, GID and name..."
usermod -u $USER_ID $USER_NAME
groupmod -g $USER_GID $USER_NAME

log "Done!"

exec "$@"