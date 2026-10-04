#!/system/bin/sh
# Busybox HTTPD CGI handler for Galaxy Kernel Master & Router Control Panel
# Author: hoc

printf "Content-Type: application/json\r\nAccess-Control-Allow-Origin: *\r\nCache-Control: no-cache\r\n\r\n"

QUERY="${QUERY_STRING}"
if [ "$REQUEST_METHOD" = "POST" ] && [ -n "$CONTENT_LENGTH" ] && [ "$CONTENT_LENGTH" -gt 0 ] 2>/dev/null; then
    read -n "$CONTENT_LENGTH" POST_DATA
    if [ -n "$POST_DATA" ]; then
        QUERY="$POST_DATA"
    fi
fi

# Function to extract query parameter value
get_param() {
    echo "$QUERY" | tr '&' '\n' | grep "^$1=" | head -n 1 | cut -d '=' -f 2-
}

ACTION=$(get_param action)
VAL=$(get_param val)
VAL2=$(get_param val2)
CLUSTER=$(get_param cluster)
WHICH=$(get_param which)

if [ -z "$ACTION" ]; then
    ACTION="status"
fi

KM="/data/adb/modules/galaxy-kernel-master/system/bin/kernel_master"
if [ ! -x "$KM" ]; then
    KM="/data/adb/kernel_master"
fi

case "$ACTION" in
    status)
        sh "$KM" status
        ;;
    set_cpu_gov)
        sh "$KM" set_cpu_gov "$VAL" "$CLUSTER"
        ;;
    set_cpu_unlock_2ghz)
        sh "$KM" set_cpu_unlock_2ghz "$VAL"
        ;;
    set_cpu_freq)
        sh "$KM" set_cpu_freq "$CLUSTER" "$WHICH" "$VAL"
        ;;
    set_ppm_enabled)
        sh "$KM" set_ppm_enabled "$VAL"
        ;;
    set_ppm_boost)
        sh "$KM" set_ppm_boost "$VAL"
        ;;
    set_ppm_thermal_bypass)
        sh "$KM" set_ppm_thermal_bypass "$VAL"
        ;;
    set_swappiness)
        sh "$KM" set_swappiness "$VAL"
        ;;
    set_dirty_ratio)
        sh "$KM" set_dirty_ratio "$VAL" "$VAL2"
        ;;
    set_vfs_cache_pressure)
        sh "$KM" set_vfs_cache_pressure "$VAL"
        ;;
    set_zram_algo)
        sh "$KM" set_zram_algo "$VAL"
        ;;
    drop_caches)
        sh "$KM" drop_caches "$VAL"
        ;;
    set_io_scheduler)
        sh "$KM" set_io_scheduler "$VAL"
        ;;
    set_read_ahead)
        sh "$KM" set_read_ahead "$VAL"
        ;;
    set_sched_child_runs)
        sh "$KM" set_sched_child_runs "$VAL"
        ;;
    set_sched_latency)
        sh "$KM" set_sched_latency "$VAL"
        ;;
    set_tcp_cong)
        sh "$KM" set_tcp_cong "$VAL"
        ;;
    set_tcp_fastopen)
        sh "$KM" set_tcp_fastopen "$VAL"
        ;;
    set_tcp_ecn)
        sh "$KM" set_tcp_ecn "$VAL"
        ;;
    set_tcp_tw_reuse)
        sh "$KM" set_tcp_tw_reuse "$VAL"
        ;;
    set_tcp_slow_start_idle)
        sh "$KM" set_tcp_slow_start_idle "$VAL"
        ;;
    set_tcp_buffers)
        sh "$KM" set_tcp_buffers "$VAL"
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
    set_store_mode)
        sh "$KM" set_store_mode "$VAL"
        ;;
    set_adb_wifi)
        sh "$KM" set_adb_wifi "$VAL"
        ;;
    send_at)
        AT_DEC=$(echo "$VAL" | sed 's/%2B/+/g;s/%20/ /g;s/%3D/=/g;s/%3F/?/g;s/%26/\&/g;s/+/ /g')
        sh "$KM" send_at "$AT_DEC"
        ;;
    apply_preset)
        sh "$KM" apply_preset "$VAL"
        ;;
    revert_all)
        sh "$KM" revert_all
        ;;
    *)
        echo "{\"status\": \"error\", \"message\": \"Unknown API action: $ACTION\"}"
        ;;
esac
