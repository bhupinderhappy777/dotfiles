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
ln -sf ~/dotfiles/audacity/.config/audacity ~/.config/audacity
```

Or to symlink only the preferences file:

```bash
mkdir -p ~/.config/audacity
ln -sf ~/dotfiles/audacity/.config/audacity/audacity.cfg ~/.config/audacity/audacity.cfg
```

## Notes

- Audacity must be closed before modifying `audacity.cfg`, as it overwrites the file on exit.
- The config stores preferences such as default sample rate, recording device, playback device, and UI layout.
- Projects (`.aup3` files) and recordings are **not** stored in this repository.
