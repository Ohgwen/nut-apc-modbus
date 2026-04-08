echo "Starting NUT..."

# Ensure runtime dir exists
mkdir -p /run/nut
chown -R nut:nut /run/nut

# Wait for USB (critical for apc_modbus)
sleep 5

echo "Starting driver..."
upsdrvctl start

echo "Starting upsd..."
upsd

echo "Starting upsmon..."
upsmon

# Keep container alive
tail -f /dev/null