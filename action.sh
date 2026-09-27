#!/system/bin/sh
# Magisk Action Button Handler for Galaxy Kernel Master
MODDIR=${0%/*}

echo "=========================================="
echo "  ⚡ Galaxy Kernel Master & Router Control"
echo "  Samsung Galaxy M32 5G (MT6853)"
echo "=========================================="
echo ""

# Ensure httpd is running and responsive
if ! /data/adb/magisk/busybox wget -q -O - http://localhost:8090/ >/dev/null 2>&1; then
    echo "[*] Starting / reviving Web UI daemon on port 8090..."
    pkill -9 -f "8090" 2>/dev/null
    sleep 1
    /data/adb/magisk/busybox httpd -p 0.0.0.0:8090 -h "$MODDIR/web" -c "$MODDIR/web/httpd.conf"
else
    echo "[✓] Web UI daemon active on port 8090."
fi

echo "[*] Opening Web UI in browser: http://localhost:8090 ..."

# Launch the default web browser to http://localhost:8090
am start -a android.intent.action.VIEW -d "http://localhost:8090" >/dev/null 2>&1

echo ""
echo "[✓] Browser launched successfully!"
echo "    URL: http://localhost:8090"
echo "=========================================="
exit 0
