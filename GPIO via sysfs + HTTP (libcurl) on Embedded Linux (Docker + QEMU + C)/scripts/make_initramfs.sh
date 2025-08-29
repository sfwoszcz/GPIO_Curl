#!/usr/bin/env bash
# Build a tiny initramfs with busybox + our binary (system-mode QEMU demo)
set -euo pipefail
OUT=out/initramfs
BIN=gpio_curl
rm -rf "$OUT" && mkdir -p "$OUT"/{bin,sbin,etc,proc,sys,dev,tmp,root,app}
cp /bin/busybox "$OUT/bin/"
cp "$BIN" "$OUT/app/"
cat > "$OUT/init" <<'INIT'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev || mkdir -p /dev
echo "[init] Creating mock sysfs GPIO..."
mkdir -p /tmp/mockgpio/gpio22
echo in  > /tmp/mockgpio/gpio22/direction
echo 0   > /tmp/mockgpio/gpio22/value
export SYSFS_GPIO_BASE=/tmp/mockgpio
echo "[init] Running app..."
/app/gpio_curl 22 http://localhost:8000/gpio
echo "[init] Done. Dropping to shell."
exec /bin/busybox sh
INIT
chmod +x "$OUT/init"
(cd "$OUT" && find . | cpio -H newc -ov | gzip) > out/initramfs.cpio.gz
echo "[ok] Built out/initramfs.cpio.gz"
