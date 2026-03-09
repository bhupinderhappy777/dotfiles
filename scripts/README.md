# scripts/

Standalone Bash automation scripts. Each script is self-contained and can be run manually or invoked by a systemd service.

---

## `process_inbox.sh` — Inbox File Organiser

Sorts files from `~/Inbox_Folder` into their correct home directory based on file extension.

### Extension → Destination Mapping

| Extensions | Destination |
|---|---|
| `jpg jpeg png gif heic` | `~/Pictures` |
| `mp3 m4a wav aac ogg` | `~/Music` |
| `mp4 mkv avi mov wmv` | `~/Videos` |
| `pdf docx doc xlsx xls pptx ppt txt rtf odt zip` | `~/Documents` |
| All others | `~/Documents/Misc_Documents` |

### Collision Handling

When a file with the same name already exists at the destination:

1. **SHA256 hashes match** → The incoming file is a duplicate. It is moved to `~/Inbox_Folder/Duplicates/` for review.
2. **Hashes differ** → Same name, different content. The incoming file is renamed `filename (1).ext`, `filename (2).ext`, etc., and moved to the destination.

### Usage

```bash
# One-shot: process all existing files and exit
bash ~/dotfiles/scripts/process_inbox.sh

# Watch mode: process existing files, then monitor for new ones (requires inotify-tools)
bash ~/dotfiles/scripts/process_inbox.sh --watch
bash ~/dotfiles/scripts/process_inbox.sh -w
```

### Environment Variable Overrides

```bash
INBOX=~/Downloads \
PICTURES=~/Media/Photos \
bash ~/dotfiles/scripts/process_inbox.sh
```

| Variable | Default |
|---|---|
| `INBOX` | `~/Inbox_Folder` |
| `PICTURES` | `~/Pictures` |
| `MUSIC` | `~/Music` |
| `VIDEOS` | `~/Videos` |
| `DOCUMENTS` | `~/Documents` |

### Notes

- Uses `flock` to prevent two instances from running at the same time.
- Skips Syncthing temporary files (`.syncthing.*`) and `.tmp` files.
- Cross-filesystem moves are handled gracefully: `mv` is tried first; if it fails (e.g. different mount points), `cp -p` + `rm` is used to preserve timestamps and permissions.
- In watch mode, the `inotifywait` monitor restarts automatically if it exits unexpectedly.

---

## `wallpaper_wallhaven.sh` — Dynamic Wallpaper Fetcher

Fetches a random **4K abstract** wallpaper from the [Wallhaven API](https://wallhaven.cc/help/api), applies it live to the KDE desktop, and updates the lock screen config.

### What it does

1. Waits for network connectivity (pings `8.8.8.8`).
2. Queries the Wallhaven API for a random 4K image in category `id:37` (Abstract).
3. Downloads the image to `~/Pictures/Wallpapers/wallhaven_<timestamp>.jpg`.
4. Removes previously downloaded `wallhaven_*.jpg` files to avoid accumulation.
5. Applies the wallpaper live via the KDE D-Bus API (works for all monitors).
6. Updates the lock screen wallpaper using `kwriteconfig5` or `kwriteconfig6` (auto-detected).
7. Restarts `kglobalaccel` to work around a known KDE bug that breaks global shortcuts after a wallpaper change.

### Usage

```bash
bash ~/dotfiles/scripts/wallpaper_wallhaven.sh
```

Usually invoked automatically by the `wallpaper-refresh.timer` systemd unit.

---

## `update_sddm_wallpaper.sh` — SDDM Login Wallpaper Sync

Writes the most recently downloaded Wallhaven wallpaper as the SDDM Breeze theme background.

### What it does

1. Finds the newest `wallhaven_*.jpg` in `~/Pictures/Wallpapers/`.
2. Writes `/etc/sddm.conf.d/10-wallpaper.conf` with `sudo tee`.
3. Restarts the `sddm` systemd service (this **logs you out**).

### Usage

```bash
bash ~/dotfiles/scripts/update_sddm_wallpaper.sh
```

> ⚠️ This script restarts SDDM, which will end your current session. Run it only when you are ready to log out, or run it from a TTY.
