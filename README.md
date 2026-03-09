# dotfiles

> A comprehensive, automated Linux desktop environment built around **KDE Plasma** (v5 & v6), managed entirely through version-controlled configuration files and systemd user services.

---

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Prerequisites](#prerequisites)
4. [Quick Installation](#quick-installation)
5. [Components](#components)
   - [KDE Plasma Layout Management](#1-kde-plasma-layout-management)
   - [Automation Scripts](#2-automation-scripts)
   - [Systemd User Services](#3-systemd-user-services)
   - [Zsh Shell Configuration](#4-zsh-shell-configuration)
   - [Application Configurations](#5-application-configurations)
6. [Security Notes](#security-notes)
7. [Development Conventions](#development-conventions)
8. [Roadmap](#roadmap)

---

## Overview

This repository stores every configuration file and automation script needed to reproduce a consistent, automated, and secure KDE Plasma desktop — across fresh installs, multiple machines, or Plasma version upgrades.

**Key goals:**
- Reproducible desktop: apply the full environment in minutes on a new machine.
- Automated file management: incoming files sorted automatically via an inbox workflow.
- Dynamic wallpapers: fresh 4K abstract art fetched from Wallhaven on a timer.
- Secure credential handling: no plain-text passwords — all secrets live in KWallet.

**Main technologies:**

| Area | Tool |
|---|---|
| Desktop Environment | KDE Plasma 5 & 6 |
| Shell | Zsh · Oh My Zsh · Starship |
| Secret Management | KWallet (`kwallet-query`) |
| Automation | Bash · systemd user services · inotify-tools |
| Containerisation | Podman (Gemini CLI sandbox) |
| Remote Desktop | FreeRDP 3.x |
| Applications | VS Code (Flatpak) · Double Commander · Git · Audacity · Konsole |

---

## Repository Structure

```
dotfiles/
├── README.md                    ← You are here
├── GEMINI.md                    ← Context file for Gemini AI agent
├── .gitignore
│
├── plasma/                      ← KDE Plasma layout management
│   ├── common/                  ← Shared KDE config files (theme, shortcuts, kwin)
│   │   └── .config/
│   │       ├── kdeglobals       ← Breeze Dark colour scheme
│   │       ├── kglobalshortcutsrc
│   │       ├── konsolerc
│   │       ├── kscreenlockerrc
│   │       ├── kwalletrc
│   │       └── kwinrc
│   ├── v5/                      ← Plasma 5-specific layout scripts
│   │   ├── appletsrc.master     ← Saved panel/widget layout (template)
│   │   ├── apply_layout.sh      ← Deploy layout, patching the Activity ID
│   │   └── harvest_layout.sh   ← Back up current layout to this repo
│   └── v6/                      ← Plasma 6-specific layout scripts
│       ├── appletsrc.master
│       ├── apply_layout.sh
│       └── harvest_layout.sh
│
├── scripts/                     ← Standalone automation scripts
│   ├── process_inbox.sh         ← Sort ~/Inbox_Folder into ~/Documents, ~/Pictures, etc.
│   ├── wallpaper_wallhaven.sh   ← Fetch & apply a random 4K wallpaper from Wallhaven
│   └── update_sddm_wallpaper.sh ← Sync SDDM login screen to the current wallpaper
│
├── systemd/                     ← Systemd user service & timer units
│   └── .config/systemd/user/
│       ├── inbox-watcher.service
│       ├── wallpaper-refresh.service
│       └── wallpaper-refresh.timer
│
├── zsh/                         ← Zsh shell configuration
│   ├── .zshrc                   ← Main shell config (aliases, functions, PATH)
│   └── .config/                 ← Additional Zsh-related configs
│
├── git/
│   └── .gitconfig               ← Global Git identity
│
├── konsole/
│   └── .local/share/            ← Konsole terminal profiles & colour schemes
│
├── vscode/
│   └── .var/app/                ← VS Code (Flatpak) settings & keybindings
│
├── audacity/
│   └── .config/audacity/        ← Audacity preferences
│
└── doublecmd/
    └── .config/doublecmd/       ← Double Commander configuration
```

---

## Prerequisites

Install these packages before running the setup scripts.

### Arch / Manjaro
```bash
sudo pacman -S zsh inotify-tools curl jq podman freerdp
```

### Fedora
```bash
sudo dnf install zsh inotify-tools curl jq podman freerdp
```

### Ubuntu / Debian
```bash
sudo apt install zsh inotify-tools curl jq podman freerdp2-x11
```

### All distributions — additional setup
```bash
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Starship prompt
curl -sS https://starship.rs/install.sh | sh

# VS Code via Flatpak (if not using the native package)
flatpak install flathub com.visualstudio.code
```

---

## Quick Installation

```bash
# 1. Clone the repository
git clone https://github.com/bhupinderhappy777/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Symlink Zsh config
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc

# 3. Symlink Git config
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# 4. Symlink KDE common configs
for f in ~/dotfiles/plasma/common/.config/*; do
    ln -sf "$f" ~/.config/$(basename "$f")
done

# 5. Install systemd services
mkdir -p ~/.config/systemd/user
ln -sf ~/dotfiles/systemd/.config/systemd/user/inbox-watcher.service     ~/.config/systemd/user/
ln -sf ~/dotfiles/systemd/.config/systemd/user/wallpaper-refresh.service ~/.config/systemd/user/
ln -sf ~/dotfiles/systemd/.config/systemd/user/wallpaper-refresh.timer   ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable --now inbox-watcher.service wallpaper-refresh.timer

# 6. Apply the Plasma layout (choose your version)
bash ~/dotfiles/plasma/v6/apply_layout.sh   # Plasma 6
# bash ~/dotfiles/plasma/v5/apply_layout.sh # Plasma 5
```

> **Tip:** After running step 6, log out and back in (or restart plasmashell) for the layout to take full effect.

---

## Components

### 1. KDE Plasma Layout Management

**Location:** `plasma/`

KDE stores widget/panel layout in `~/.config/plasma-org.kde.plasma.desktop-appletsrc`. The file contains a hardcoded *Activity ID* that changes with every fresh install, making direct copy-paste fail silently.

This repository solves that with a **Master Layout** approach:

| Script | Purpose |
|---|---|
| `harvest_layout.sh` | Copy the live config file into `appletsrc.master` for safekeeping |
| `apply_layout.sh` | Copy `appletsrc.master` to `~/.config/…`, patch the Activity ID to match the current session, wipe the Plasma cache, and restart `plasmashell` |

**Usage:**

```bash
# Save current layout to the repo
bash ~/dotfiles/plasma/v6/harvest_layout.sh

# Restore layout (e.g. after a reinstall)
bash ~/dotfiles/plasma/v6/apply_layout.sh
```

**Shared KDE configs** in `plasma/common/.config/`:

| File | What it controls |
|---|---|
| `kdeglobals` | Breeze Dark colour scheme, animation speed, contrast |
| `kglobalshortcutsrc` | Global keyboard shortcuts |
| `kwinrc` | Window decoration and tiling behaviour |
| `kscreenlockerrc` | Lock screen wallpaper path |
| `konsolerc` | Default Konsole terminal settings |
| `kwalletrc` | KWallet daemon configuration |

---

### 2. Automation Scripts

**Location:** `scripts/`

#### `process_inbox.sh` — Inbox Organiser

Watches `~/Inbox_Folder` and moves files into their correct home directory folder based on file extension.

**Extension → Folder mapping:**

| Extensions | Destination |
|---|---|
| `jpg jpeg png gif heic` | `~/Pictures` |
| `mp3 m4a wav aac ogg` | `~/Music` |
| `mp4 mkv avi mov wmv` | `~/Videos` |
| `pdf docx doc xlsx xls pptx ppt txt rtf odt zip` | `~/Documents` |
| Everything else | `~/Documents/Misc_Documents` |

**Collision handling:** if a file with the same name already exists at the destination, SHA256 hashes are compared. Identical files go to `~/Inbox_Folder/Duplicates`; files with the same name but different content are renamed `file (1).ext`, `file (2).ext`, etc.

```bash
# Process existing files once and exit
bash ~/dotfiles/scripts/process_inbox.sh

# Watch continuously for new files (requires inotify-tools)
bash ~/dotfiles/scripts/process_inbox.sh --watch

# Override default paths via environment variables
INBOX=~/Downloads bash ~/dotfiles/scripts/process_inbox.sh
```

#### `wallpaper_wallhaven.sh` — Dynamic Wallpaper

Fetches a random 4K abstract wallpaper from the [Wallhaven API](https://wallhaven.cc/help/api), applies it to the KDE desktop via D-Bus, and updates the lock screen config.

- Auto-detects Plasma 5 or 6 and uses the correct `kwriteconfig` binary.
- Cleans up old downloaded wallpapers before saving the new one.
- Restarts `kglobalaccel` to work around a known KDE bug where global shortcuts break after a wallpaper change.

```bash
bash ~/dotfiles/scripts/wallpaper_wallhaven.sh
```

#### `update_sddm_wallpaper.sh` — SDDM Login Screen Sync

Sets the SDDM (Breeze theme) background to match the most recently downloaded Wallhaven wallpaper. Requires `sudo`.

```bash
bash ~/dotfiles/scripts/update_sddm_wallpaper.sh
```

---

### 3. Systemd User Services

**Location:** `systemd/.config/systemd/user/`

All units run as the **user** (no root required) via `systemctl --user`.

| Unit | Type | Description |
|---|---|---|
| `inbox-watcher.service` | Service | Runs `process_inbox.sh --watch` continuously; restarts on failure after 10 s |
| `wallpaper-refresh.service` | Service | One-shot unit that runs `wallpaper_wallhaven.sh` |
| `wallpaper-refresh.timer` | Timer | Triggers `wallpaper-refresh.service` 30 s after login, then every 30 min, and at 03:00 daily |

**Managing the services:**

```bash
# Enable and start everything
systemctl --user enable --now inbox-watcher.service wallpaper-refresh.timer

# Check status
systemctl --user status inbox-watcher.service
systemctl --user status wallpaper-refresh.timer

# View logs
journalctl --user -u inbox-watcher.service -f
journalctl --user -u wallpaper-refresh.service -n 50

# Trigger a wallpaper change immediately
systemctl --user start wallpaper-refresh.service

# Disable
systemctl --user disable --now inbox-watcher.service wallpaper-refresh.timer
```

---

### 4. Zsh Shell Configuration

**Location:** `zsh/.zshrc`

Built on **Oh My Zsh** with the **Starship** cross-shell prompt. Performance-sensitive plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`) are loaded asynchronously in a subshell to keep startup fast.

**Plugins enabled:** `git` · `autoswitch_virtualenv` · `zsh-history-substring-search`

**Key functions and aliases:**

| Alias / Function | What it does |
|---|---|
| `withvault <cmd>` | Fetches the Ansible Vault password from KWallet and sets `ANSIBLE_VAULT_PASSWORD_FILE` for the wrapped command |
| `ap <playbook.yml>` | Short for `withvault ansible-playbook` |
| `av <subcommand>` | Short for `withvault ansible-vault` (edit, encrypt, rekey, etc.) |
| `ufv_connect` / `urdp` | Launches an RDP session to the UFV lab via FreeRDP 3.x, pulling credentials from KWallet |
| `code` | Opens VS Code via Flatpak (`flatpak run com.visualstudio.code`) |
| `geminicli` | Runs the Google Gemini CLI inside a **Podman** container — no local Node.js install needed |

**PATH additions:** `~/.local/bin` · `/usr/local/bin` · `/opt/oci/bin` · Flatpak export directories

---

### 5. Application Configurations

#### Git — `git/.gitconfig`
Global Git identity (name and email). Symlink to `~/.gitconfig`.

#### Konsole — `konsole/.local/share/`
Terminal profiles and colour schemes for the KDE Konsole emulator.

#### VS Code — `vscode/.var/app/`
Settings and keybindings for the VS Code Flatpak installation.

#### Audacity — `audacity/.config/audacity/`
Audacity preferences (sample rate, recording device, UI layout).

#### Double Commander — `doublecmd/.config/doublecmd/`
File manager configuration including keyboard shortcuts, colour theme, and panel layout.

---

## Security Notes

- **No plain-text secrets.** Passwords are never stored in files. All credentials (Ansible Vault password, RDP password) are retrieved at runtime from **KWallet** using `kwallet-query`.
- The `wallpaper-refresh.service` unit file currently hard-codes the home directory path (e.g. `/home/username/`). Update `ExecStart` in `systemd/.config/systemd/user/wallpaper-refresh.service` to use `%h` (the systemd specifier for the user's home directory) for portability.
- The `update_sddm_wallpaper.sh` script uses `sudo` to write to `/etc/sddm.conf.d/` — review it before running on a shared machine.

---

## Development Conventions

- **Bash safety:** all scripts start with `set -euo pipefail` to catch unset variables, command failures, and pipe errors early.
- **Dotfiles root:** scripts reference `$HOME/dotfiles` as the repository root. If you clone elsewhere, update this path or export a `DOTFILES` environment variable and adapt the scripts.
- **Atomic file operations:** `process_inbox.sh` uses `flock` to prevent concurrent runs and `sha256sum` to detect duplicate content before moving files.

---

## Roadmap

### Phase 1 — Foundation (completed ✅)
- [x] KDE Plasma layout backup & restore scripts (v5 + v6)
- [x] Inbox file organiser with collision handling and watch mode
- [x] Dynamic wallpaper fetcher (Wallhaven API, 4K)
- [x] SDDM login screen wallpaper sync
- [x] Systemd user service and timer for inbox watcher and wallpaper refresh
- [x] KWallet-backed secret handling for Ansible Vault and RDP
- [x] Podman-containerised Gemini CLI alias
- [x] Shared KDE theme, shortcuts, and kwin settings

### Phase 2 — Installation & Portability (next)
- [ ] Write a top-level `install.sh` that symlinks all configs and enables systemd units in one command
- [ ] Add [GNU Stow](https://www.gnu.org/software/stow/) support as an alternative to manual symlinking
- [ ] Replace hard-coded `/home/bhupi/` in `wallpaper-refresh.service` with the `%h` specifier
- [ ] Support `$DOTFILES` environment variable override across all scripts

### Phase 3 — Reliability & Observability
- [ ] Add structured logging to `process_inbox.sh` (timestamped log file under `~/.local/share/process_inbox/`)
- [ ] Add health-check script that verifies all symlinks and services are active
- [ ] Write unit tests for the collision-handling logic in `process_inbox.sh` using `bats` (Bash Automated Testing System)
- [ ] Add `--dry-run` flag to `process_inbox.sh` to preview moves without making changes

### Phase 4 — Enhanced Automation
- [ ] Wallpaper history: keep a rolling archive of the last N wallpapers with quick-switch support
- [ ] Wallhaven API key support for accessing NSFW/SFW filtering and personal collections
- [ ] Notification integration: send desktop notifications (via `notify-send`) when the inbox processes files or the wallpaper changes
- [ ] Multi-monitor wallpaper support (set different wallpapers per screen)

### Phase 5 — Cross-Distro & Cross-Machine
- [ ] Distro-detection in `install.sh` to auto-install prerequisites on Arch, Fedora, and Ubuntu
- [ ] Machine profiles: allow per-hostname config overrides (e.g. different RDP targets, different wallpaper categories)
- [ ] Ansible playbook for full system bootstrap (packages, Flatpaks, systemd units, dotfiles)

### Phase 6 — Documentation
- [ ] Add screenshots of the Plasma layout, Konsole theme, and wallpaper output to the README
- [ ] Record a short terminal screencast demonstrating the inbox organiser and wallpaper refresh
