# GPIO via sysfs + HTTP (libcurl) on Embedded Linux (Docker + QEMU + C)

## What it does
- Reads a GPIO (e.g., 22) via **sysfs** as input and prints its value.
- Reconfigures the same pin to output, writes **HIGH (1)**, verifies by reading back.
- Sends an **HTTP GET** with **libcurl**: `...?pin=22&state=high`.

## Tech
- **C** with raw POSIX I/O: `open, read, write, lseek, close, fsync`
- **libcurl** for HTTP (easy API)
- **Docker** for reproducible toolchain
- **QEMU** user-mode (and optional system-mode) for emulation

## Repo

---

gpio-curl/
├─ Dockerfile
├─ Makefile
├─ src/gpio_curl.c
└─ scripts/
├─ prepare_mock_sysfs.sh
├─ build_and_run.sh
├─ make_initramfs.sh
└─ run_qemu_system.sh

---

## Quick start (native in Docker)
```bash
bash scripts/build_and_run.sh
# Tip: in another shell, run: python3 -m http.server 8000

---

## QEMU user-mode (ARM) — optional
Uncomment ARM section in Dockerfile to build gpio_curl.arm, rebuild, then:

docker run --rm -it gpio-curl:latest
export SYSFS_GPIO_BASE=/tmp/mockgpio
./scripts/prepare_mock_sysfs.sh 22
qemu-arm-static ./gpio_curl.arm 22 http://localhost:8000/gpio

---

## QEMU system-mode (VM) — optional

# Build initramfs:
docker run --rm -it -v "$PWD":/app -w /app gpio-curl:latest \
  bash -lc "./scripts/make_initramfs.sh"

# Provide an ARM kernel at ./kernel/zImage, then:
docker run --rm -it --net=host -v "$PWD":/app -w /app gpio-curl:latest \
  bash -lc "./scripts/run_qemu_system.sh"

---

## Real hardware
Run the container privileged and mount real sysfs:

docker run --rm -it --privileged \
  -v /sys/class/gpio:/sys/class/gpio \
  -e SYSFS_GPIO_BASE=/sys/class/gpio \
  gpio-curl:latest
./gpio_curl 22 http://myserver.com/gpio

---

## Notes

 * In plain QEMU, real GPIO sysfs may not be present unless the guest kernel exposes a GPIO controller. The mock sysfs (/tmp/mockgpio) allows testing the same file I/O logic anywhere.

 * For production, consider modern character device GPIO (/dev/gpiochip*, libgpiod).
 
---

License

MIT

---
