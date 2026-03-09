# doublecmd/

Double Commander dual-pane file manager configuration.

## Structure

```
doublecmd/
└── .config/doublecmd/    ← mirrors ~/.config/doublecmd/
    └── doublecmd.xml     ← Full application configuration
```

## Installation

```bash
ln -sf ~/dotfiles/doublecmd/.config/doublecmd ~/.config/doublecmd
```

Or to symlink only the config file:

```bash
mkdir -p ~/.config/doublecmd
ln -sf ~/dotfiles/doublecmd/.config/doublecmd/doublecmd.xml ~/.config/doublecmd/doublecmd.xml
```

## What is Stored

The `doublecmd.xml` file captures:
- Keyboard shortcuts and hotkeys
- Colour theme and font settings
- Panel layout (column widths, sort order)
- Bookmarked directories
- Plugin configuration
- File association / viewer assignments

## Notes

- Double Commander must be closed before replacing `doublecmd.xml`, as it writes the file on exit and will overwrite any changes made while it is running.
- The `doublecmd.xml` file may contain absolute paths (e.g. bookmarks). Review and update these paths if deploying on a machine with a different username or home directory.
