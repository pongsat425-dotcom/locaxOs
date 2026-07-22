#!/usr/bin/env bash
# profiledef.sh for Locaxlinux

iso_name="locaxlinux-hypr-macwin"
iso_label="LOCAXLINUX_v1"
iso_publisher="Locaxlinux Systems Architect <https://github.com/locaxlinux-distro>"
iso_application="Locaxlinux Live / Installer DVD"
iso_version="2026.07.22"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:0400"
  ["/etc/gshadow"]="0:0:0400"
  ["/root"]="0:0:0700"
  ["/root/.automated_script.sh"]="0:0:0755"
  ["/usr/local/bin/choose-mirror"]="0:0:0755"
  ["/usr/local/bin/Installation_guide"]="0:0:0755"
  ["/usr/local/bin/live-init.sh"]="0:0:0755"
)
