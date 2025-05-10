# ⚠ WARNING ⚠
If you actually want to try my **Dotfiles**, proceed at your own risk. Not everything is set up correctly yet.

# Gothic ● [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Yet another **minimal [Hyprland](https://hyprland.org/) rice** for [Arch Linux](https://archlinux.org/) with a gothic/aesthetic/dark/emo theme.

- [Setup](#setup) ● [Preview](#preview) ● [Features](#features)

## Features
- **Fully customized status bar** using **[Waybar](https://github.com/Alexays/Waybar)**
- **App launcher** with **[Rofi](https://github.com/davatorium/rofi)**
- **Power menu** via **[Rofi](https://github.com/davatorium/rofi)**
- **Screen locker** using **[Hyprlock](https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/)**
- **There's more but I'm too lazy to list all the features!**

---

## Setup
1. Clone the repository to `$HOME/gothic`:
   ```bash
   git clone --depth=1 --recursive https://github.com/MarceIine/gothic.git $HOME/gothic
   ```

2. Navigate to the directory and run the installation script:
   ```bash
   cd $HOME/gothic && ./install_packages.bash
   ```

   Or do it all in one command:
   ```bash
   git clone --depth=1 --recursive https://github.com/MarceIine/gothic.git $HOME/gothic && cd $HOME/gothic && ./install_packages.bash
   ```

3. After the script finishes, your tty1 will restart. This indicates everything installed correctly* (probably).

---

## Preview
### Desktop
![Desktop Preview](https://github.com/user-attachments/assets/17a43d6c-d32b-4575-9ff7-60e595268d48)

### Kitty Terminal + Notifications + SwayOSD
![Terminal Preview](https://github.com/user-attachments/assets/afd07ca2-31d4-4c52-8ee9-3eb001b46a90)

### System Monitoring with Btop
![Btop Preview](https://github.com/user-attachments/assets/21007c7d-f1d5-4171-9fc4-095bba5d14ef)

### App Launcher
![App Launcher Preview](https://github.com/user-attachments/assets/745425ce-1ce4-4fbd-9cd8-b692b94cdc46)

### Power Menu
![Power Menu Preview](https://github.com/user-attachments/assets/4f49271f-4102-40a8-9594-ae72f9ee599b)

---

### Credits
- **Important:** I did not create all the config files. Shoutout to all the people whose configs/scripts I used - this wouldn't have been possible without you!
- **All original authors are credited within their respective config/script files**, and I'm sorry if I missed crediting you here!
