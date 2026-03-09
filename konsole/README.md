# konsole/

Konsole terminal emulator configuration — profiles and colour schemes.

## Structure

```
konsole/
└── .local/share/        ← mirrors ~/.local/share/
    └── konsole/         ← Konsole profiles and colour scheme files
```

## Installation

```bash
# Symlink the entire share directory (recommended)
ln -sf ~/dotfiles/konsole/.local/share/konsole ~/.local/share/konsole

# Or copy individual files
cp ~/dotfiles/konsole/.local/share/konsole/* ~/.local/share/konsole/
```

## Notes

- Profile files have a `.profile` extension and are referenced by name in Konsole's settings.
- Colour scheme files have a `.colorscheme` extension.
- The active profile is configured in `plasma/common/.config/konsolerc`.
- After symlinking, restart Konsole or reload the profile from **Settings → Manage Profiles** for changes to take effect.
