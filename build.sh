#!/bin/bash
#
# Build it.

set -e

export OK=" \033[92mOK "
export INFO="\033[94mINFO"

log () {
  /bin/echo -e "[ $1 \033[39m] $2"
}

log $INFO "Starting build"

for pkg in $(cat pkgdirs); do
  log $INFO "Starting package build: $pkg"
  cd $pkg && ./build.sh && cd ..
  mv "$pkg/out.cpio" "packages/$pkg.cpio"
  log "$OK" "Finished package build"
done

log "$OK" "Done"
