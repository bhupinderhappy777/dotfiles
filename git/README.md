# git/

Global Git configuration.

## Files

| File | Deployed to | Description |
|---|---|---|
| `.gitconfig` | `~/.gitconfig` | Git user identity (name and email) |

## Installation

```bash
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
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
