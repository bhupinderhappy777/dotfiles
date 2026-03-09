# vscode/

VS Code configuration for the **Flatpak** installation (`com.visualstudio.code`).

## Structure

```
dot_var/app/com.visualstudio.code/config/Code/User/  ← chezmoi-managed canonical path
vscode/.var/app/com.visualstudio.code/config/Code/User/ ← legacy source copy
```

## Installation

```bash
# Apply managed files
chezmoi apply

# Edit the managed file
chezmoi edit ~/.var/app/com.visualstudio.code/config/Code/User/settings.json
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
