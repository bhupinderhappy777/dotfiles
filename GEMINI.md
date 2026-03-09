# Gemini CLI Context: Dotfiles Project

This directory is a personal dotfiles repository for a Linux environment, primarily focused on **KDE Plasma** (versions 5 and 6). It includes configurations for various applications and several automation scripts managed by systemd.

## Project Overview
A comprehensive set of configuration files and automation scripts to maintain a consistent, automated, and secure Linux desktop environment.

### Main Technologies
*   **Desktop Environment**: KDE Plasma (v5 and v6)
*   **Shell**: Zsh (Oh My Zsh, Starship)
*   **Secret Management**: KWallet integration for Ansible Vault and RDP
*   **Automation**: Systemd user services, Bash scripts, inotify-tools
*   **Containerization**: Podman (used for running Gemini CLI and other tools)
*   **Applications**: VS Code (Flatpak), Double Commander, Git, Audacity

## Key Components & Usage

### 1. KDE Plasma Management (`/plasma`)
The repository uses a "Master Layout" system to solve Activity ID mismatch issues across different installs.
*   **`v5/` & `v6/`**: Version-specific directories.
*   **`apply_layout.sh`**: Deploys the `appletsrc.master` by injecting the current session's Activity ID.
*   **`harvest_layout.sh`**: Backs up the current active layout to the repository.
*   **`common/.config/`**: Contains shared theme (`kdeglobals`), shortcuts (`kglobalshortcutsrc`), and window manager (`kwinrc`) settings.

### 2. Automation Scripts (`/scripts`)
*   **`process_inbox.sh`**: Monitors `~/Inbox_Folder` and organizes files into `Pictures`, `Music`, `Videos`, and `Documents`.
    *   Handles collisions via SHA256 hash comparison.
    *   Can run in one-shot or `--watch` mode.
*   **`wallpaper_wallhaven.sh`**: Fetches 4K abstract wallpapers from Wallhaven and applies them to the desktop and lock screen.
*   **`update_sddm_wallpaper.sh`**: Synchronizes the SDDM login screen with the current wallpaper.

### 3. Systemd Services (`/systemd`)
Managed as user services (`systemctl --user`):
*   **`inbox-watcher.service`**: Keeps the inbox organizer running in the background.
*   **`wallpaper-refresh.timer`**: Triggers a wallpaper change periodically.

### 4. Shell & Helpers (`/zsh`)
*   **`withvault`**: A Zsh function that fetches the Ansible Vault password from KWallet and runs a command.
*   **`ufv_connect`**: A helper to launch a FreeRDP session with credentials pulled from KWallet.
*   **`gemini`**: An alias to run the Gemini CLI inside a Podman container for a clean, dependency-free environment.

## Building and Running
As a dotfiles project, deployment is handled by **chezmoi**.
*   **Initial setup**: `chezmoi init --apply https://github.com/bhupinderhappy777/dotfiles.git`
*   **Update + apply**: `chezmoi update` (or `chezmoi git pull && chezmoi apply`)
*   **Deployment flow**:
    1.  Chezmoi deploys managed files from `dot_*` paths to `$HOME`.
    2.  `.chezmoiscripts` installs shell prerequisites and enables systemd user services.
    3.  Plasma layout is applied via `plasma/v[5|6]/apply_layout.sh` using the detected Plasma version.

## Development Conventions
*   **Bash Safety**: Scripts use `set -euo pipefail` where appropriate.
*   **Secret Handling**: Never store plain-text passwords. Use the KWallet integration patterns found in `.zshrc`.
*   **Pathing**: Scripts generally assume `$HOME/dotfiles` as the root path for local references.
