#!/usr/bin/env bash
# Local helper script to build xnu locally (Linux/macOS)
# Usage: ./scripts/build_xnu.sh [-a ARCH] [-d DARWIN_MAJOR] [-s SDKROOT]
set -euo pipefail

ARCH="X86_64"
DARWIN_MAJOR=""
SDKROOT=""

while getopts "a:d:s:" opt; do
  case $opt in
    a) ARCH="$OPTARG" ;;
    d) DARWIN_MAJOR="$OPTARG" ;;
    s) SDKROOT="$OPTARG" ;;
    *) echo "Usage: $0 [-a ARCH] [-d DARWIN_MAJOR] [-s SDKROOT]"; exit 1 ;;
  esac
done

if [ -n "$DARWIN_MAJOR" ]; then
  export RC_DARWIN_KERNEL_VERSION="$DARWIN_MAJOR"
  echo "RC_DARWIN_KERNEL_VERSION set to $RC_DARWIN_KERNEL_VERSION"
fi

if [ -n "$SDKROOT" ]; then
  echo "Using custom SDKROOT: $SDKROOT"
fi

# Ensure we're in repo root containing xnu source (or cd into it)
if [ ! -d xnu-src ]; then
  echo "xnu-src not found: cloning from Apple OSS"
  git clone --depth 1 https://github.com/apple-oss-distributions/xnu.git xnu-src
fi

cd xnu-src
echo "Starting build (ARCH=$ARCH)"
if [ -n "$SDKROOT" ]; then
  make SDKROOT="$SDKROOT" ARCH_CONFIGS=$ARCH KERNEL_CONFIGS=RELEASE -j$(sysctl -n hw.ncpu)
else
  make ARCH_CONFIGS=$ARCH KERNEL_CONFIGS=RELEASE -j$(sysctl -n hw.ncpu)
fi

echo "Build finished. Output (if successful) is in BUILD/obj/RELEASE_${ARCH}/kernel"
