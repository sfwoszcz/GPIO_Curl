#!/usr/bin/env bash
set -euo pipefail
IMAGE="gpio-curl:latest"
docker build -t "$IMAGE" .
docker run --rm -it "$IMAGE" bash -lc '
  set -e
  export SYSFS_GPIO_BASE=/tmp/mockgpio
  ./scripts/prepare_mock_sysfs.sh 22
  echo "[run] Native demo:"
  ./gpio_curl 22 http://localhost:8000/gpio || true
  echo
  echo "[hint] Start a tiny test server in another shell: python3 -m http.server 8000"
'
