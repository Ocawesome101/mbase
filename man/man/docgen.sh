#!/bin/bash
# Automated manual page generation in lieu of a proper Makefile

echo "Generating man-page documentation...."
set -e

for file in $(find man -type f); do
  ./docgen.lua $file ../usr/$file
done
