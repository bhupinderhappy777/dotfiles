# zsh/

Zsh shell configuration built on **Oh My Zsh** with the **Starship** cross-shell prompt.

## Files

| File | Description |
|---|---|
| `.zshrc` | Main shell configuration — PATH, plugins, aliases, and helper functions |

## Installation

```bash
# Prerequisites
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh

# Optional plugins (placed in $ZSH_CUSTOM/plugins/)
git clone https://github.com/zsh-users/zsh-autosuggestions    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Symlink the config
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```

## Oh My Zsh Plugins

| Plugin | Purpose |
|---|---|
| `git` | Aliases and prompt helpers for Git |
| `autoswitch_virtualenv` | Automatically activates/deactivates Python virtualenvs when entering a directory |
| `zsh-history-substring-search` | Search history by typing part of a previous command and pressing ↑ |
| `zsh-autosuggestions` | Greyed-out completion suggestions as you type (loaded async) |
| `zsh-syntax-highlighting` | Real-time command syntax highlighting (loaded async) |

## Aliases

| Alias | Expands to |
|---|---|
| `ap` | `withvault ansible-playbook` |
| `av` | `withvault ansible-vault` |
| `urdp` | `ufv_connect` (FreeRDP session to UFV lab) |
| `code` | `flatpak run com.visualstudio.code` |
| `geminicli` | Podman-containerised Google Gemini CLI (no local Node.js needed) |

## Functions

### `withvault <command> [args…]`

Runs any command with `ANSIBLE_VAULT_PASSWORD_FILE` set to the password fetched live from KWallet. The password is never written to disk.

```bash
# Examples
withvault ansible-playbook site.yml
ap site.yml          # shorthand alias

withvault ansible-vault edit secrets.yml
av edit secrets.yml  # shorthand alias
```

**KWallet entry required:** `vault_pass` in the `Secret Service` folder of `kdewallet`.

### `ufv_connect`

Launches a FreeRDP 3.x session to the UFV computer lab, pulling the RDP password from KWallet at runtime.

```bash
ufv_connect
urdp        # alias
```

**KWallet entry required:** `ufv_pass` in the `Secret Service` folder of `kdewallet`.

## Gemini CLI (Podman)

The `geminicli` alias runs the [Google Gemini CLI](https://github.com/google-gemini/gemini-cli) inside a `node:20-slim` Podman container. This keeps your system clean — no global `npm` install needed.

```bash
geminicli
```

Mounts:
- `~/.gemini` → `/home/node/.gemini` (API key and conversation history)
- `$(pwd)` → `/home/node/project` (current working directory as the project root)

## PATH Additions

The following directories are prepended/appended to `$PATH`:

| Directory | Purpose |
|---|---|
| `/usr/local/bin` | System-wide tools |
| `~/.local/bin` | User-installed scripts and pip binaries |
| `/opt/oci/bin` | OCI (Oracle Cloud) CLI tools |
| `/var/lib/flatpak/exports/bin` | System-wide Flatpak binaries |
| `~/.local/share/flatpak/exports/bin` | User Flatpak binaries |
