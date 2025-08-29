# Partial Exam environment: build native + ARM, libcurl, QEMU, scripts
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential make pkg-config \
      libcurl4-openssl-dev curl \
      qemu-user-static qemu-system-arm \
      busybox-static \
      tzdata ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone

WORKDIR /app
COPY Makefile .
COPY src ./src
COPY scripts ./scripts

# Build native (x86_64) with libcurl
RUN make

# Optional: ARM build with libcurl (dynamic); enable if you add armhf libs
# RUN dpkg --add-architecture armhf && apt-get update && apt-get install -y \
#       gcc-arm-linux-gnueabihf libc6:armhf libcurl4:armhf libcurl4-openssl-dev:armhf && \
#     arm-linux-gnueabihf-gcc -O2 -Wall -Wextra -o gpio_curl.arm src/gpio_curl.c -lcurl

CMD ["/bin/bash"]
