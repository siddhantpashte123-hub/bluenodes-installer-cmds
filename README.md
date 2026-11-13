# BLUENODES Installer

Made By BLUE

## All-in-one install (one command)

Run this on a Debian/Ubuntu server as root. It installs everything in one go, no menus:

```bash
curl -fsSL https://raw.githubusercontent.com/siddhantpashte123-hub/bluenodes-installer-cmds/main/install.sh | sudo bash
```

This installs:
- System update and upgrade
- Basic tools: `curl wget git htop nano ufw`
- Docker Engine (`docker.io`)
- Neofetch

## Interactive menu

```bash
sudo bash bluenodes.sh
```

Menu options: Installer, Panel Installer (JTG, Petro, BLUEKVM).
