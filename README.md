# Locaxlinux (2026.07.22)

> **A custom Arch Linux Distribution engineered with macOS Visual Elegance and Windows 11 Ergonomics.**

---

## 🛠️ How to Build Your ISO

### Option A: Local Build (Arch Linux / Manjaro / Carch)
```bash
chmod +x build_iso.sh
sudo ./build_iso.sh
```

### Option B: Cloud Build (GitHub Actions - Free)
1. Push this repository to GitHub.
2. Go to **Actions** tab.
3. Select **Build Locaxlinux Bootable ISO** and click **Run workflow**.
4. Download the generated `.iso` artifact!

---

## 💾 How to Flash to USB
```bash
# Identify your USB drive (e.g. /dev/sdX)
lsblk

# Flash using dd
sudo dd if=out/locaxlinux-hypr-macwin-2026.07.22-x86_64.iso of=/dev/sdX status=progress bs=4M
```
Or use **Ventoy** / **BalenaEtcher**.
