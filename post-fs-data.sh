#!/system/bin/sh
# Fix Build Fingerprint & VINTF Kernel Compatibility Mismatch on Boot
# Eliminates: "There's an internal problem with your device. Contact your manufacturer for details."

MODDIR=${0%/*}
VINTF_SRC="/data/adb/modules/galaxy-kernel-master/system/etc/vintf"
if [ ! -d "$VINTF_SRC" ] && [ -d "$MODDIR/system/etc/vintf" ]; then
    VINTF_SRC="$MODDIR/system/etc/vintf"
fi

# 1. Bind-mount patched VINTF compatibility matrices (allows CONFIG_SYSVIPC=y)
if [ -d "$VINTF_SRC" ]; then
    for f in "$VINTF_SRC"/compatibility_matrix.*.xml; do
        base="${f##*/}"
        target="/system/etc/vintf/$base"
        if [ -f "$f" ] && [ -f "$target" ]; then
            mount -o bind "$f" "$target" 2>/dev/null
        fi
    done
fi

# 2. Harmonize all partition fingerprints to match system
FP=$(resetprop ro.build.fingerprint)
if [ -z "$FP" ]; then
    FP="samsung/a32xins/a32x:13/TP1A.220624.014/M326BDDSCCYD1:user/release-keys"
fi

DATE_UTC=$(resetprop ro.build.date.utc)
if [ -z "$DATE_UTC" ]; then
    DATE_UTC="1744888626"
fi

DATE=$(resetprop ro.build.date)

for prop in \
    ro.bootimage.build.fingerprint \
    ro.vendor.build.fingerprint \
    ro.odm.build.fingerprint \
    ro.vendor_dlkm.build.fingerprint \
    ro.odm_dlkm.build.fingerprint \
    ro.system_dlkm.build.fingerprint \
    ro.product.build.fingerprint \
    ro.system.build.fingerprint \
    ro.system_ext.build.fingerprint
do
    resetprop -n "$prop" "$FP" 2>/dev/null
    resetprop "$prop" "$FP" 2>/dev/null
done

# Harmonize build dates
for prop in \
    ro.bootimage.build.date.utc \
    ro.vendor.build.date.utc \
    ro.odm.build.date.utc \
    ro.vendor_dlkm.build.date.utc \
    ro.product.build.date.utc \
    ro.system.build.date.utc \
    ro.system_ext.build.date.utc
do
    resetprop -n "$prop" "$DATE_UTC" 2>/dev/null
    resetprop "$prop" "$DATE_UTC" 2>/dev/null
done

if [ -n "$DATE" ]; then
    for prop in \
        ro.bootimage.build.date \
        ro.vendor.build.date \
        ro.odm.build.date \
        ro.vendor_dlkm.build.date \
        ro.product.build.date \
        ro.system.build.date \
        ro.system_ext.build.date
    do
        resetprop -n "$prop" "$DATE" 2>/dev/null
        resetprop "$prop" "$DATE" 2>/dev/null
    done
fi

exit 0
