# systemd/

Systemd **user** units (services and timers) that automate inbox file organisation and wallpaper refresh. All units run as your regular user — no root access is required.

## Units

### `inbox-watcher.service`

Runs `process_inbox.sh --watch` as a long-lived background process.

| Field | Value |
|---|---|
| Type | `simple` |
| Restart | `on-failure` (10 s delay) |
| Script | `~/dotfiles/scripts/process_inbox.sh --watch` |

### `wallpaper-refresh.service`

One-shot service that runs `wallpaper_wallhaven.sh` once and exits.

| Field | Value |
|---|---|
| Type | `oneshot` |
| Requires network | Yes (`After=network-online.target`) |
| Script | `~/dotfiles/scripts/wallpaper_wallhaven.sh` |

### `wallpaper-refresh.timer`

Activates `wallpaper-refresh.service` on a schedule.

| Trigger | When |
|---|---|
| `OnActiveSec=30s` | 30 seconds after login |
| `OnUnitActiveSec=30m` | Every 30 minutes thereafter |
| `OnCalendar=*-*-* 03:00:00` | Once every day at 03:00 |
| `Persistent=true` | Catches up on missed runs (e.g. after sleep) |

## Installation

```bash
# Symlink units into the user systemd directory
mkdir -p ~/.config/systemd/user

ln -sf ~/dotfiles/systemd/.config/systemd/user/inbox-watcher.service     ~/.config/systemd/user/
ln -sf ~/dotfiles/systemd/.config/systemd/user/wallpaper-refresh.service ~/.config/systemd/user/
ln -sf ~/dotfiles/systemd/.config/systemd/user/wallpaper-refresh.timer   ~/.config/systemd/user/

# Reload the daemon and enable/start the units
systemctl --user daemon-reload
systemctl --user enable --now inbox-watcher.service wallpaper-refresh.timer
```

## Common Commands

```bash
# Check status
systemctl --user status inbox-watcher.service
systemctl --user status wallpaper-refresh.timer

# View real-time logs
journalctl --user -u inbox-watcher.service -f
journalctl --user -u wallpaper-refresh.service -n 50

# Trigger a wallpaper change immediately (outside the schedule)
systemctl --user start wallpaper-refresh.service

# Restart the inbox watcher after a config change
systemctl --user restart inbox-watcher.service

# Disable everything
systemctl --user disable --now inbox-watcher.service wallpaper-refresh.timer
```

## Notes

- The `wallpaper-refresh.service` file currently has a hard-coded home directory path (`/home/bhupi/`). Replace it with the systemd `%h` home-directory specifier for portability across different user accounts:
  ```ini
  ExecStart=/bin/bash %h/dotfiles/scripts/wallpaper_wallhaven.sh
  ```
- Units are stored under `systemd/.config/systemd/user/` in the repo (mirroring the `~/.config/systemd/user/` target path) so that a dotfiles manager like GNU Stow can deploy them directly.
