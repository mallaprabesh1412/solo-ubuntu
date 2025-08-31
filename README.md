

## 📜 `solo-ubuntu'

---

# SOLO Ubuntu

**Run Ubuntu GUI on Termux with extra features, optimized for beginners and power users.**

---

### 🚀 Features

* Fixed **Audio Output** (no more silent Ubuntu)
* Lightweight (requires at least **4GB storage**)
* Preinstalled with **2 Browsers** (Chromium & Firefox)
* Supports **Bangla Fonts**
* **VLC** & **MPV** Media Players
* **Visual Studio Code** (buggy on ARM)
* **Sublime Text** (for arm64/aarch64 only)
* Beginner-friendly setup
* Cool pre-applied themes 🎨

---

### ⚙️ Installation

1. **Install Termux**
   Download the latest Termux APK from 👉 [HERE](https://f-droid.org/repo/com.termux_118.apk)

2. **Clone the repository & run setup**

   ```bash
   yes | pkg up
   pkg install git wget -y
   git clone --depth=1 https://github.com/mallaprabesh1412/solo-ubuntu.git
   cd solo-ubuntu
   bash setup.sh
   ```

3. **Restart Termux** & type:

   ```bash
   ubuntu
   bash user.sh
   ```

   * Enter your Ubuntu **root username** (must be lowercase, no spaces).

4. **Restart Termux again** & type:

   ```bash
   ubuntu
   sudo bash gui.sh
   ```

👉 **Remember your VNC password!**

---

### 🖥️ Running Ubuntu GUI

* Start VNC server:

  ```bash
  vncstart
  ```

* Stop VNC server:

  ```bash
  vncstop
  ```

* Install **VNC Viewer** from 👉 [Google Play Store](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android&hl=en)

* Open **VNC Viewer** → tap **+** →

  * Address: `localhost:1`
  * Name: anything you like

* Set **Picture Quality → High** for best experience.

* Connect, enter your password, and boom — Ubuntu desktop on your phone 🎉

---

### 📌 Notes

* `ubuntu` → Run Ubuntu CLI
* `vncstart` → Start VNC server
* `vncstop` → Stop VNC server
* `bash purge.sh` → Completely remove SOLO Ubuntu

---

### 📹 Video Tutorial

🎥 [Watch Here](https://mega.nz/embed/QvIC1TLQ#3z27MRNPwANAg6JTtx1Ei8kDouOZsZgk00bg4TsJMNQ!1m)

---

### 📖 Changelog

👉 [View Updates](https://github.com/mallaprabesh1412/solo-ubuntu/blob/master/CHANGELOG.md)

---

### 📜 License

Licensed under [Apache License](https://github.com/mallaprabesh1412/solo-ubuntu/blob/master/LICENSE)

---

### 🙌 Credits

* Ubuntu image provided by **Termux proot-distro** → [GitHub](https://github.com/termux/proot-distro)
* Full credit for Ubuntu base image goes to them.

---

### 👨‍💻 Maintainers

* [**Mallaprabesh**](https://github.com/mallaprabesh1412)



⭐ If you like SOLO Ubuntu, don’t forget to **star the repo**!

--
