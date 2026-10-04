# ⚡ Galaxy Kernel Master & Router Control Panel v2.0 (SM-M326B)

A comprehensive, kernel-level performance optimizer, router engine, cellular modem controller, battery protection suite, and Glassmorphism Web UI management console designed specifically for the **Samsung Galaxy M32 5G** (`SM-M326B` / MediaTek Dimensity 720 `MT6853`).

Author: **hoc**  
Version: **v2.0** (`versionCode=200`)  
Target: **Samsung Galaxy M32 5G / Dimensity 720 (Android 13 / Linux 4.14.186)**  

---

## 🚀 Key Capabilities (v2.0)

### 1. ⚡ CPU DVFS & 2.0 GHz Frequency Unlock
- **Full Frequency Scaling**: Control individual cluster governors (`schedutil`, `performance`, `powersave`, `ondemand`) across Little (Cores 0-5) and Big (Cores 6-7) clusters.
- **2.0 GHz Max Frequency Unlock**: Unlocks and locks the maximum 2000 MHz (2.0 GHz) CPU frequency on Big cores (`policy6`), removing Samsung's stock thermal and power caps.
- **MediaTek PPM Engine**: Direct interface with `/proc/ppm/` (Processor Power Management):
  - **SYS_BOOST**: Force full CPU and memory bus boost for latency-critical packet routing.
  - **Thermal Throttling Bypass**: Prevent thermal-induced frequency downclocking under heavy network throughput.

### 2. 🌐 Complete Android 5G Router Engine
- **Dual-Stack Wire-Speed IP Forwarding**: Instant toggling of IPv4 and IPv6 packet forwarding (`net.ipv4.ip_forward`, `net.ipv6.conf.all.forwarding`).
- **Dynamic NAT Masquerading**: Automatic iptables masquerade across cellular interfaces (`rmnet+`, `v4-rmnet+`), USB Ethernet (`eth+`), USB RNDIS (`rndis+`), and Hotspot / Virtual AP (`wlan+`, `swlan+`, `ap+`).
- **Receive Packet Steering (RPS)**: Spreads hardware network interrupts and packet routing workloads across all 8 CPU cores (`rps_cpus=ff`) for gigabit packet processing without frame drops.
- **Carrier Hotspot Throttling Bypass**: Bypasses carrier tethering entitlement checks and DUN APN requirements (`tether_dun_required=0`).

### 3. 🚀 16MB Gigabit TCP Acceleration
- **TCP Congestion Algorithms**: Switch between `BBR`, `CUBIC`, `BIC`, and `RENO` on the fly.
- **16MB Gigabit Socket Buffers**: Boosts `rmem_max` and `wmem_max` to 16,777,216 bytes (16 MB) with tuned `tcp_rmem` and `tcp_wmem`, maximizing 5G Standalone (NR-SA) gigabit throughput.
- **TCP Fast Open (TFO)**: Enables client/server Fast Open (`tcp_fastopen=3`) to reduce SYN handshake RTT.
- **Explicit Congestion Notification (ECN)**: Reduces retransmissions and jitter.
- **TCP TIME_WAIT Reuse & SACK**: Maximizes socket recycling for high-connection routing scenarios.

### 4. 🧠 Memory, Virtual Memory & ZRAM
- **Swappiness Tuning**: Configure swappiness dynamically (0 to 200) to balance RAM usage between active processes and ZRAM swap cache.
- **I/O Freezing Elimination**: Fine-tunes `dirty_ratio`, `dirty_background_ratio`, and `vfs_cache_pressure` to eliminate kernel flushing stutter.
- **1-Click Cache Drop**: Flush pagecache, dentries, and inodes via `drop_caches`.

### 5. 💽 UFS Storage I/O Optimization
- **I/O Schedulers**: Switch storage schedulers across all block devices (`cfq`, `deadline`, `noop`).
- **Read-Ahead Scaling**: Tune blockdev read-ahead from 128 KB up to 2048 KB for ultra-fast sequential read performance.

### 6. 🔋 Battery Store Mode / Direct AC Power Bypass
- **24/7 Dedicated Router Protection**: Enables hardware `store_mode` and `batt_slate_mode` via `/sys/class/power_supply/battery/store_mode`.
- Powers the phone directly from the USB charger while bypassing battery charging once desired capacity is reached, preventing battery swelling, overheating, and degradation during long-term router or tethering operation!

### 7. 📡 5G Modem AT Console
- Direct hardware access to MediaTek CCCI modem AT port (`/dev/ttyC_AT`).
- Instant 1-click execution for Engineering Mode cell queries (`AT+ECENG=3`), Band queries (`AT+EPBSE?`), and Signal Quality (`AT+CSQ`).

### 8. 🛡️ VINTF Matrix Compatibility & 1-Click Revert
- **Internal Problem Warning Fix**: Includes updated VINTF compatibility matrices (`compatibility_matrix.3-7.xml`) and build fingerprint harmonization (`post-fs-data.sh`) to eliminate Android "internal problem with your device" boot warnings.
- **1-Click Universal Revert**: Every modified sysctl, iptables rule, CPU governor, and memory parameter is recorded at launch. Clicking **"Revert All to Factory Defaults"** completely restores 100% of factory stock kernel settings.

---

## 💻 Web Control Panel (Port 8090)

The module runs an ultra-lightweight, zero-dependency embedded web server via Magisk busybox on **Port 8090**.

### Accessing the Web UI:
- **On Device**: Open any browser and navigate to `http://localhost:8090`
- **Over Local Wi-Fi / Hotspot / LAN**: Navigate to `http://<phone-ip>:8090`
- **Via USB / ADB**:
  ```bash
  adb forward tcp:8090 tcp:8090
  ```
  Then open `http://localhost:8090` on your PC browser.
- **Magisk App**: Tap the **Action** button on the `Galaxy Kernel Master` card inside the Magisk App!

---

## 🛠️ CLI Engine (`kernel_master`)

The engine can also be executed directly via root shell:

```bash
# Query complete JSON telemetry (CPU, PPM, RAM, ZRAM, I/O, TCP, Battery, Thermals)
kernel_master status

# Unlock 2.0 GHz CPU frequency
kernel_master set_cpu_unlock_2ghz 1

# Set CPU governor (schedutil | performance | powersave | ondemand)
kernel_master set_cpu_gov performance

# MediaTek PPM boost / thermal throttling bypass
kernel_master set_ppm_boost 1
kernel_master set_ppm_thermal_bypass 1

# Enable / Disable dual-stack IP forwarding & NAT
kernel_master set_ip_forward 1
kernel_master set_nat 1

# 16MB Gigabit TCP Socket Buffers
kernel_master set_tcp_buffers 1

# Enable Battery Store Mode (bypass charging for 24/7 router use)
kernel_master set_store_mode 1

# Apply Presets (router | performance | battery | balanced)
kernel_master apply_preset router

# Revert all parameters to factory stock defaults
kernel_master revert_all
```

---

## 📦 Installation

1. Flash `galaxy-kernel-master-v2.0.zip` via **Magisk App** -> Modules -> Install from storage.
2. Or flash via ADB root:
   ```bash
   adb push galaxy-kernel-master-v2.0.zip /data/local/tmp/
   adb shell su -c "magisk --install-module /data/local/tmp/galaxy-kernel-master-v2.0.zip"
   ```
3. Access the Web UI immediately without rebooting!
