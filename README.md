

## 📜 `solo-ubuntu'

---


---

# 🖥️ SOLO Ubuntu for Termux

Run **Ubuntu with GUI** directly on your Android device using Termux — powered by **SOLO**.
Everything is automated: install once, choose your username + VNC password, and you’re ready to roll.

---

## 🚀 Features

* Lightweight & stable (requires at least **4GB storage**)
* XFCE4 Desktop Environment (fast, smooth)
* **Firefox & Chromium** browsers
* **Visual Studio Code** (buggy on ARM)
* **Sublime Text** (arm64 only)
* **VLC & MPV Media Players**
* **GIMP (Photoshop alternative)**
* Audio support (via PulseAudio)
* Custom user creation (no root needed)
* Single command installation (no restarts needed)

---

## 📲 Installation

### 1. Install Termux

Download Termux APK from: [F-Droid](https://f-droid.org/repo/com.termux_118.apk)

### 2. Clone & Run Setup

```bash
yes | pkg up
pkg install git wget -y
git clone https://github.com/mallaprabesh1412/solo-ubuntu.git
cd solo-ubuntu
bash setup.sh
```

👉 During setup, enter your **Ubuntu username** (lowercase, no spaces) and set a **VNC password**.

---

## 🔑 Usage

After installation:

* Enter Ubuntu CLI:

  ```bash
  solo
  ```

* Start Ubuntu GUI (VNC):

  ```bash
  vncstart
  ```

* Stop VNC:

  ```bash
  vncstop
  ```

---

## 🖥️ VNC Viewer Setup

1. Install [VNC Viewer](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android) from Play Store.
2. Open app → Press `+` → Enter:

   * **Address**: `localhost:1`
   * **Name**: `SOLO Ubuntu` (or anything you like)
3. Set **Quality = High**.
4. Connect → Enter your VNC password.
5. Enjoy full Ubuntu Desktop on Android 🎉

---

## ❌ Removal

If you want to remove SOLO Ubuntu:

```bash
bash purge.sh
```

---

## 🎥 Video Tutorial

*(Coming soon — YouTube link planned)*

---

## 📜 Notes

* Use `solo` for CLI Ubuntu
* Use `vncstart` / `vncstop` for GUI session
* Requires **VNC Viewer** app to access GUI

---

## 👑 Maintainer

Created & Powered by **SOLO**

---


