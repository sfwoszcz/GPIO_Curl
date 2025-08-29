#!/usr/bin/env bash
set -euo pipefail
PIN="${1:-22}"
BASE="${SYSFS_GPIO_BASE:-/tmp/mockgpio}"
mkdir -p "$BASE/gpio$PIN"
echo in  > "$BASE/gpio$PIN/direction"
echo 0   > "$BASE/gpio$PIN/value"
echo "[mock] SYSFS base: $BASE | gpio$PIN prepared (direction=in, value=0)"
