#!/system/bin/sh
# Fix Build Fingerprint Inconsistency Warning on Boot
# Eliminates: "There's an internal problem with your device. Contact your manufacturer for details."

FP=$(resetprop ro.build.fingerprint)
if [ -z "$FP" ]; then
    FP="samsung/a32xins/a32x:13/TP1A.220624.014/M326BDDSCCYD1:user/release-keys"
fi

DATE_UTC=$(resetprop ro.build.date.utc)
if [ -z "$DATE_UTC" ]; then
    DATE_UTC="1744888626"
fi

DATE=$(resetprop ro.build.date)

# Harmonize all partition fingerprints to match system
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
