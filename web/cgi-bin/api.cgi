#!/system/bin/sh
# Busybox HTTPD CGI handler for Galaxy Kernel Master

printf "Content-Type: application/json\r\nAccess-Control-Allow-Origin: *\r\nCache-Control: no-cache\r\n\r\n"

QUERY="${QUERY_STRING}"
if [ "$REQUEST_METHOD" = "POST" ] && [ -n "$CONTENT_LENGTH" ] && [ "$CONTENT_LENGTH" -gt 0 ] 2>/dev/null; then
    read -n "$CONTENT_LENGTH" POST_DATA
    if [ -n "$POST_DATA" ]; then
        QUERY="$POST_DATA"
    fi
fi

ACTION=$(echo "$QUERY" | tr '&' '\n' | grep '^action=' | head -n 1 | cut -d '=' -f 2)
VAL=$(echo "$QUERY" | tr '&' '\n' | grep '^val=' | head -n 1 | cut -d '=' -f 2)

if [ -z "$ACTION" ]; then
    ACTION="status"
fi

KM="/data/adb/kernel_master"
if [ ! -x "$KM" ]; then
    KM="/data/adb/modules/galaxy-kernel-master/system/bin/kernel_master"
fi

case "$ACTION" in
    status)
        sh "$KM" status
        ;;
    set_ip_forward)
        sh "$KM" set_ip_forward "$VAL"
        ;;
    set_nat)
        sh "$KM" set_nat "$VAL"
        ;;
    set_hotspot_bypass)
        sh "$KM" set_hotspot_bypass "$VAL"
        ;;
    set_rps)
        sh "$KM" set_rps "$VAL"
        ;;
    set_tcp_cong)
        sh "$KM" set_tcp_cong "$VAL"
        ;;
    set_tcp_buffers)
        sh "$KM" set_tcp_buffers "$VAL"
        ;;
    set_cpu_gov)
        sh "$KM" set_cpu_gov "$VAL"
        ;;
    set_swappiness)
        sh "$KM" set_swappiness "$VAL"
        ;;
    set_dirty_ratio)
        sh "$KM" set_dirty_ratio "$VAL"
        ;;
    set_adb_wifi)
        sh "$KM" set_adb_wifi "$VAL"
        ;;
    send_at)
        AT_DEC=$(echo "$VAL" | sed 's/+/ /g;s/%\(..\)/\\x\1/g;')
        sh "$KM" send_at "$AT_DEC"
        ;;
    revert_all)
        sh "$KM" revert_all
        ;;
    *)
        echo "{\"status\": \"error\", \"message\": \"Invalid CGI action $ACTION\"}"
        ;;
esac
