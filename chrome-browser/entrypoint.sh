#!/bin/bash

set -e

# Start D-Bus if not already running
if [ ! -e /run/dbus/system_bus_socket ]; then
    echo "Starting D-Bus daemon..."
    dbus-daemon --system --print-address 2>/dev/null || true
fi

# Ensure XDG_RUNTIME_DIR exists and has correct permissions
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# Wait for X11 display to be available
echo "Waiting for X11 display at $DISPLAY..."
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if [ -e /tmp/.X11-unix/0 ]; then
        echo "X11 display found!"
        break
    fi
    attempt=$((attempt + 1))
    echo "Display not ready, waiting... ($attempt/$max_attempts)"
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo "WARNING: X11 display not found, but continuing anyway..."
fi

# Validate CHROME_URL is set
if [ -z "$CHROME_URL" ]; then
    echo "ERROR: CHROME_URL environment variable not set"
    exit 1
fi

echo "Launching Chrome with URL: $CHROME_URL"
echo "DISPLAY: $DISPLAY"
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"

# Build Chrome command with flags from Advanced Engineering image
exec google-chrome \
    --app="$CHROME_URL" \
    --kiosk \
    --no-first-run \
    --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT' \
    --no-sandbox \
    --disable-pinch \
    --disable-dev-shm-usage
