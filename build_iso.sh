#!/usr/bin/env bash
# =========================================================================
#  Locaxlinux - ISO Builder Script
#  Run on Arch Linux, Manjaro, EndeavourOS, or Carch
# =========================================================================

set -e

echo "🚀 [Locaxlinux Architect] Initializing ISO Build Environment..."

if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run as root (sudo ./build_iso.sh)"
  exit 1
fi

echo "📦 [1/5] Installing build dependencies..."
pacman -Sy --needed --noconfirm archiso squashfs-tools git libisoburn grub mtools dosfstools efibootmgr python

WORK_DIR="/tmp/locaxlinux-build-tmp"
OUT_DIR="$(pwd)/out"

echo "🧹 [2/5] Cleaning previous workspace ($WORK_DIR)..."
rm -rf "$WORK_DIR"
mkdir -p "$OUT_DIR"

PROFILE_DIR="./archlive"
if [ ! -d "$PROFILE_DIR" ] && [ -d "./archiso" ]; then
  PROFILE_DIR="./archiso"
elif [ ! -d "$PROFILE_DIR" ]; then
  echo "⚠️ Warning: ./archlive directory not found. Copying default Arch Linux releng profile..."
  cp -r /usr/share/archiso/configs/releng ./archlive
  PROFILE_DIR="./archlive"
fi

echo "⚙️ [3/5] Verifying & preparing profile boot configurations..."
if [ ! -d "$PROFILE_DIR/syslinux" ] && [ -d "/usr/share/archiso/configs/releng/syslinux" ]; then
  echo "--> Copying syslinux configs..."
  cp -r /usr/share/archiso/configs/releng/syslinux "$PROFILE_DIR/"
fi
if [ ! -d "$PROFILE_DIR/efiboot" ] && [ -d "/usr/share/archiso/configs/releng/efiboot" ]; then
  echo "--> Copying efiboot configs..."
  cp -r /usr/share/archiso/configs/releng/efiboot "$PROFILE_DIR/"
fi
if [ ! -d "$PROFILE_DIR/grub" ] && [ -d "/usr/share/archiso/configs/releng/grub" ]; then
  echo "--> Copying grub configs..."
  cp -r /usr/share/archiso/configs/releng/grub "$PROFILE_DIR/" 2>/dev/null || true
fi

if [ -f "$PROFILE_DIR/packages.x86_64" ]; then
  grep -q "^syslinux$" "$PROFILE_DIR/packages.x86_64" || echo "syslinux" >> "$PROFILE_DIR/packages.x86_64"
fi

if [ -f "$PROFILE_DIR/profiledef.sh" ]; then
  echo "--> Modernizing bootmodes in profiledef.sh..."
  python3 -c "
import re
path = '$PROFILE_DIR/profiledef.sh'
with open(path, 'r') as f:
    text = f.read()
new_text = re.sub(r'bootmodes=([^)]*)', 'bootmodes=('bios.syslinux' 'uefi.systemd-boot')', text, flags=re.DOTALL)
with open(path, 'w') as f:
    f.write(new_text)
"
fi

echo "🔨 [4/5] Building Bootable ISO with mkarchiso..."
mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo "✅ [5/5] ISO Build Completed Successfully!"
echo "📁 Your bootable ISO is located at: $OUT_DIR/"
ls -lh "$OUT_DIR"/*.iso
