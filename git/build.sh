#!/bin/bash

set -e

log () {
  /bin/echo -e "[ $1\033[39m ] $2"
}

log "$INFO" "Generating out.cpio"
cd src && find ./* -type f | cpio -o > ../out.cpio && cd ..
