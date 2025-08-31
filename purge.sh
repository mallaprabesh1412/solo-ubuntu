#!/bin/bash
echo "[SOLO] Removing Ubuntu..."
proot-distro remove ubuntu
proot-distro clear-cache
rm -f $PREFIX/bin/solo $PREFIX/bin/vncstart $PREFIX/bin/vncstop
echo "[SOLO] Ubuntu completely removed."
