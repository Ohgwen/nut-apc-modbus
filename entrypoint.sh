#!/usr/bin/env bash
set -e

echo "Starting NUT..."

chown -R nut:nut /run/nut

echo "Starting driver..."
upsdrvctl start

echo "Starting upsd..."
upsd

echo "Starting upsmon..."
upsmon

# Keep container alive
tail -f /dev/null