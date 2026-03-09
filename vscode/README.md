# vscode/

VS Code configuration for the **Flatpak** installation (`com.visualstudio.code`).

## Structure

```
vscode/
└── .var/app/com.visualstudio.code/    ← mirrors ~/.var/app/com.visualstudio.code/
    └── config/Code/User/
        ├── settings.json              ← Editor preferences
        └── keybindings.json           ← Custom keyboard shortcuts
```

## Installation

```bash
# Ensure the Flatpak VS Code data directory exists
mkdir -p ~/.var/app/com.visualstudio.code/config/Code/User

# Symlink settings
ln -sf ~/dotfiles/vscode/.var/app/com.visualstudio.code/config/Code/User/settings.json \
       ~/.var/app/com.visualstudio.code/config/Code/User/settings.json

ln -sf ~/dotfiles/vscode/.var/app/com.visualstudio.code/config/Code/User/keybindings.json \
       ~/.var/app/com.visualstudio.code/config/Code/User/keybindings.json
```

## Notes

- The Flatpak edition of VS Code stores its user data under `~/.var/app/com.visualstudio.code/` instead of the usual `~/.config/Code/`.
- Extensions are **not** stored in this repository. Reinstall them manually or export a list with:
  ```bash
  flatpak run com.visualstudio.code --list-extensions > ~/dotfiles/vscode/extensions.txt
  ```
  Then restore with:
  ```bash
  xargs -n1 flatpak run com.visualstudio.code --install-extension < ~/dotfiles/vscode/extensions.txt
  ```
- The `code` alias in `.zshrc` launches VS Code via Flatpak: `alias code='flatpak run com.visualstudio.code'`
