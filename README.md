# ⚡ Galaxy Kernel Master & Router Control Panel (SM-M326B)

A comprehensive kernel-level performance optimizer, router engine, cellular modem controller, and Web UI management console designed specifically for the **Samsung Galaxy M32 5G** (`SM-M326B` / MediaTek Dimensity 720 `MT6853`).

---

## 🚀 Key Capabilities

### 1. 🌐 Complete Android Router Transformation
- **Dual-Stack IP Forwarding**: Instant toggling of IPv4 and IPv6 packet forwarding (`net.ipv4.ip_forward`, `net.ipv6.conf.all.forwarding`).
- **Inter-Interface NAT Masquerade**: Automated dynamic iptables masquerading across cellular interfaces (`rmnet+`), USB Ethernet (`eth+`), and WiFi Hotspot / VirtualAP (`wlan+`).
- **Carrier Hotspot Throttling Bypass**: Bypasses mobile carrier tethering entitlement checks and DUN APN requirements (`tether_dun_required=0`).
- **Receive Packet Steering (RPS)**: Spreads hardware network interrupts and packet routing workloads across all 8 CPU cores (`rps_cpus=ff`) for gigabit packet processing without frame drops.

### 2. 🚀 TCP Acceleration & Buffer Optimization
- **Dynamic TCP Congestion Control**: Switch between `CUBIC`, `BIC`, and `RENO` on the fly.
- **16MB Gigabit Socket Buffers**: Boosts `rmem_max` and `wmem_max` from stock Android limits to 16 MB, maximizing 5G Standalone (NR-SA) gigabit throughput.

### 3. ⚙️ CPU & Memory Tuning
- **CPU Scaling Governors**: Switch between `schedutil` (balanced), `performance` (lock 2.0 GHz max across all 8 cores for latency-critical routing), and `powersave`.
- **VM Swappiness Optimization**: Tune swappiness (160 aggressive ZRAM $\leftrightarrow$ 60 Linux standard $\leftrightarrow$ 10 low-latency) to eliminate container/router latency.
- **I/O Stutter Elimination**: Tunes `vm.dirty_ratio=20` and `vm.dirty_background_ratio=10` to avoid kernel flushing freezes.

### 4. 📡 5G Modem AT Console
- Direct hardware access to MediaTek CCCI modem AT port (`/dev/ttyC_AT`).
- Instant 1-click execution for Engineering Mode cell queries (`AT+ECENG=3`), Band queries (`AT+EPBSE?`), and Signal Quality (`AT+CSQ`).

### 5. 🛡️ 1-Click Universal Revert
- Every modified sysctl, iptables rule, CPU governor, and memory parameter is recorded at launch.
- A single click on **"Revert All to Factory Defaults"** cleanly removes all custom routing rules and restores 100% of factory stock kernel settings.

---

## 💻 Web Control Panel

The module runs an ultra-lightweight, zero-dependency embedded web server via Magisk busybox on **Port 8090**.

### Accessing the Web UI:
- **On Device**: Open any browser and navigate to `http://localhost:8090`
- **Over Local Wi-Fi / LAN**: Navigate to `http://<phone-ip>:8090`
- **Via USB / ADB**:
  ```bash
  adb forward tcp:8090 tcp:8090
  ```
  Then open `http://localhost:8090` on your PC browser.

---

## 📦 Installation

1. Download `galaxy_kernel_master_v1.0.zip` from the [Releases](https://github.com/vishalhoc/magisk-galaxy-kernel-master/releases) page.
2. Flash via **Magisk App** -> Modules -> Install from storage.
3. Or flash via ADB root:
   ```bash
   adb push galaxy_kernel_master_v1.0.zip /data/local/tmp/
   adb shell su -c "magisk --install-module /data/local/tmp/galaxy_kernel_master_v1.0.zip"
   ```
4. Access the Web UI immediately without rebooting!

---

## 🛠️ CLI Engine (`kernel_master`)

The engine can also be executed directly via root shell:
```bash
# Query live JSON status
kernel_master status

# Enable / Disable IP forwarding
kernel_master set_ip_forward 1
kernel_master set_ip_forward 0

# Enable / Disable NAT
kernel_master set_nat 1

# Change TCP Congestion Algorithm
kernel_master set_tcp_cong cubic

# Revert all parameters to factory defaults
kernel_master revert_all
```
