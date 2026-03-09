# plasma/

KDE Plasma layout management for both **Plasma 5** and **Plasma 6**.

## The Problem: Activity ID Mismatch

KDE stores its panel and widget layout in:

```
~/.config/plasma-org.kde.plasma.desktop-appletsrc
```

This file contains a hardcoded **Activity ID** (a UUID) that is freshly generated on every install. Copying the file directly to a new machine results in a blank or broken desktop because the ID does not match the running session.

## The Solution: Master Layout + Patch

Each version directory (`v5/`, `v6/`) contains:

| File | Description |
|---|---|
| `appletsrc.master` | The saved layout template (Activity ID is a placeholder) |
| `harvest_layout.sh` | Reads the live config and saves it as `appletsrc.master` |
| `apply_layout.sh` | Copies `appletsrc.master` to `~/.config/…`, patches the Activity ID in-place using `sed`, wipes the Plasma cache, and restarts `plasmashell` |

## Usage

### Save the current layout
```bash
# Plasma 6
bash ~/dotfiles/plasma/v6/harvest_layout.sh

# Plasma 5
bash ~/dotfiles/plasma/v5/harvest_layout.sh
```

### Restore (apply) the layout
```bash
# Plasma 6
bash ~/dotfiles/plasma/v6/apply_layout.sh

# Plasma 5
bash ~/dotfiles/plasma/v5/apply_layout.sh
```

> After `apply_layout.sh` runs, `plasmashell` is automatically restarted. The screen will go black briefly and the desktop will reload.

## Shared KDE Configs (`dot_config/`)

These files are version-agnostic and work with both Plasma 5 and Plasma 6.
They are managed by chezmoi and deployed to `~/.config/`.

| File | Controls |
|---|---|
| `kdeglobals` | Breeze Dark colour scheme, animation speed (`AnimationDurationFactor=0`), contrast |
| `kglobalshortcutsrc` | All global keyboard shortcuts (Super key, media keys, etc.) |
| `kwinrc` | Window decoration, focus policy, tiling, compositing |
| `kscreenlockerrc` | Lock screen timeout and wallpaper path |
| `konsolerc` | Default Konsole terminal profile |
| `kwalletrc` | KWallet daemon settings |

### Applying with chezmoi
```bash
chezmoi apply
```
