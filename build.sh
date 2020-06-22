#!/bin/bash
set -e
rm -rf dest pkg && mkdir -p dest pkg
make -C src
for file in $(ls dest); do
  echo $file
  find dest/$file | cpio -o > packages/$file.cpio
done
