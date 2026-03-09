# systemd/

Systemd **user** units (services and timers) that automate inbox file organisation and wallpaper refresh. All units run as your regular user — no root access is required.

## Units

### `inbox-watcher.service`

Runs `process_inbox.sh --watch` as a long-lived background process.

| Field | Value |
|---|---|
| Type | `simple` |
| Restart | `on-failure` (10 s delay) |
| Script | `{{ .chezmoi.sourceDir }}/scripts/process_inbox.sh --watch` |

### `wallpaper-refresh.service`

One-shot service that runs `wallpaper_wallhaven.sh` once and exits.

| Field | Value |
|---|---|
| Type | `oneshot` |
| Requires network | Yes (`After=network-online.target`) |
| Script | `{{ .chezmoi.sourceDir }}/scripts/wallpaper_wallhaven.sh` |

### `wallpaper-refresh.timer`

Activates `wallpaper-refresh.service` on a schedule.

| Trigger | When |
|---|---|
| `OnActiveSec=30s` | 30 seconds after login |
| `OnUnitActiveSec=30m` | Every 30 minutes thereafter |
| `OnCalendar=*-*-* 03:00:00` | Once every day at 03:00 |
| `Persistent=true` | Catches up on missed runs (e.g. after sleep) |

## Installation

**Automatic (via chezmoi):**
```bash
# Services are automatically deployed and enabled when you run:
chezmoi apply

# The .chezmoiscripts/run_onchange_after_setup-systemd.sh script handles:
# - Reloading systemd user daemon
# - Enabling and starting inbox-watcher.service
# - Enabling and starting wallpaper-refresh.timer
```

**Manual installation (if needed):**
```bash
# Files are stored in chezmoi's source directory:
# ~/.local/share/chezmoi/dot_config/systemd/user/

# Reload the daemon (chezmoi does this automatically)
systemctl --user daemon-reload

# Enable and start services
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

- The systemd unit files are templates and use `{{ .chezmoi.sourceDir }}` so script paths remain portable across user accounts.
- Services are managed by chezmoi and automatically deployed to `~/.config/systemd/user/` when you run `chezmoi apply`.
- The `.chezmoiscripts/run_onchange_after_setup-systemd.sh` script automatically enables and starts the services after deployment.
