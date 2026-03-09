# git/

Global Git configuration.

## Files

| File | Deployed to | Description |
|---|---|---|
| `.gitconfig` | `~/.gitconfig` | Git user identity (name and email) |

## Installation

**Automatic (via chezmoi):**
```bash
# Deployed automatically when you run:
chezmoi apply

# The file is stored as dot_gitconfig in the chezmoi source directory
# and deployed to ~/.gitconfig
```

**Manual edit:**
```bash
# Edit using chezmoi
chezmoi edit ~/.gitconfig
chezmoi apply

# Or edit directly (changes will be detected on next chezmoi diff)
vim ~/.gitconfig
```

## Configuration Details

```ini
[user]
    email = user@example.com
    name  = Your Name
```

To add more global settings (aliases, diff tool, merge strategy, etc.) edit `~/.gitconfig` directly and commit the changes to the repo.

### Useful additions to consider

```ini
[core]
    editor = vim
    autocrlf = input

[pull]
    rebase = true

[alias]
    st = status
    co = checkout
    lg = log --oneline --graph --decorate --all
```
