# BLUENODES Installer

Made By BLUE

## All-in-one install (one command)

Run this on a Debian/Ubuntu server as root. It installs everything in one go, no menus:

```bash
curl -fsSL https://raw.githubusercontent.com/siddhantpashte123-hub/bluenodes-installer-cmds/main/install.sh | sudo bash
```

After running it, a menu appears:
- `1` Installer: system update and upgrade, basic tools (`curl wget git htop nano ufw`), Docker Engine (`docker.io`), Neofetch
- `2` Panel: JTG, Petro, BLUEKVM panels
- `3` Exit

## Interactive menu

```bash
sudo bash bluenodes.sh
```

Menu options: Installer, Panel Installer (JTG, Petro, BLUEKVM).
