# konsole/

Konsole terminal emulator configuration — profiles and colour schemes.

## Structure

```
dot_local/share/konsole/         ← chezmoi-managed canonical path
konsole/.local/share/konsole/    ← legacy source copy
```

## Installation

```bash
# Apply managed files
chezmoi apply

# Edit the managed profile
chezmoi edit ~/.local/share/konsole/my_profile.profile
```

## Notes

- Profile files have a `.profile` extension and are referenced by name in Konsole's settings.
- Colour scheme files have a `.colorscheme` extension.
- The active profile is configured in `plasma/common/.config/konsolerc`.
- After applying changes, restart Konsole or reload the profile from **Settings → Manage Profiles** for changes to take effect.
