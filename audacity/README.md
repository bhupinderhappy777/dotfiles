# audacity/

Audacity audio editor configuration.

## Structure

```
audacity/
└── .config/audacity/    ← mirrors ~/.config/audacity/
    └── audacity.cfg     ← Audacity preferences
```

## Installation

```bash
# This module is currently kept in legacy layout.
# To migrate it into chezmoi, add it from your live config:
chezmoi add ~/.config/audacity/audacity.cfg

# Or use the existing file manually:
mkdir -p ~/.config/audacity
cp ./audacity/.config/audacity/audacity.cfg ~/.config/audacity/audacity.cfg
```

## Notes

- Audacity must be closed before modifying `audacity.cfg`, as it overwrites the file on exit.
- The config stores preferences such as default sample rate, recording device, playback device, and UI layout.
- Projects (`.aup3` files) and recordings are **not** stored in this repository.
