#!/usr/bin/env bash
# Boot an ARM VM with our initramfs. You need a kernel zImage for -M virt.
# Place your kernel at ./kernel/zImage (not provided here).
set -euo pipefail
KERNEL=kernel/zImage
INITRD=out/initramfs.cpio.gz
test -f "$KERNEL" || { echo "Missing $KERNEL (provide an ARM zImage)"; exit 1; }
test -f "$INITRD" || { echo "Missing $INITRD (run scripts/make_initramfs.sh)"; exit 1; }

qemu-system-arm -M virt -cpu cortex-a15 -m 256M \
  -nographic \
  -kernel "$KERNEL" \
  -initrd "$INITRD" \
  -append "console=ttyAMA0"
