#!/system/bin/sh
# Galaxy Kernel Master Background Service
MODDIR=${0%/*}

# Wait for boot completion
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 3
done

# Set permissions
chmod 755 "$MODDIR/system/bin/kernel_master" 2>/dev/null
chmod 755 "$MODDIR/web/cgi-bin/api.cgi" 2>/dev/null

# Link kernel_master to /data/adb/kernel_master for easy fallback
cp "$MODDIR/system/bin/kernel_master" /data/adb/kernel_master 2>/dev/null
chmod 755 /data/adb/kernel_master 2>/dev/null

# Save factory defaults
/data/adb/kernel_master status >/dev/null 2>&1

# Kill any existing or stale instance on port 8090
pkill -9 -f "8090" 2>/dev/null
sleep 1

# Start Web Server on port 8090 using Magisk Busybox
BUSYBOX="/data/adb/magisk/busybox"
if [ -x "$BUSYBOX" ]; then
    "$BUSYBOX" httpd -p 0.0.0.0:8090 -h "$MODDIR/web" -c "$MODDIR/web/httpd.conf"
fi

# Enable carrier hotspot bypass by default
settings put global tether_dun_required 0 2>/dev/null
settings put global tether_entitlement_check_state 0 2>/dev/null

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1 2>/dev/null
sysctl -w net.ipv6.conf.all.forwarding=1 2>/dev/null

exit 0
