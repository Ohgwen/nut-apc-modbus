#!/usr/bin/env bash
set -e
mkdir -p /var/state/ups
chown -R nut:nut /var/state/ups
chmod 777 /var/state/ups
echo "Starting NUT..."

echo "Starting driver..."
upsdrvctl start

echo "Starting upsd..."
upsd

echo "Starting upsmon..."
upsmon

# Keep container alive
tail -f /dev/null