export ZSH="$HOME/.oh-my-zsh"
# Ensure the pip-installed binaries are prioritized
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
export PATH="/opt/oci/bin/:$PATH"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting autoswitch_virtualenv zsh-history-substring-search)
source $ZSH/oh-my-zsh.sh

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Starship Initialization
eval "$(starship init zsh)"

# --- Global KWallet Settings ---
# Moving these here makes them available to BOTH functions
K_WALLET="kdewallet"
K_FOLDER="Secret Service"

# Wrapper to run ANY command with the KWallet Vault password
withvault() {
    local ENTRY="vault_pass"
    ANSIBLE_VAULT_PASSWORD_FILE=<(kwallet-query -r "$ENTRY" -f "$K_FOLDER" "$K_WALLET") "$@"
}

# UFV RDP Helper
ufv_connect() {
    local ENTRY="ufv_pass"
    # Fetch the password using the global variables
    local PASS=$(kwallet-query -r "$ENTRY" -f "$K_FOLDER" "$K_WALLET")

    if [ -z "$PASS" ]; then
        echo "❌ Error: Could not fetch 'ufv_pass' from KWallet folder '$K_FOLDER'"
        return 1
    fi

    echo " Connecting to UFV Desktop..."
# FreeRDP 3.x Unified Gateway Syntax
    xfreerdp /v:AA353W2508 \
             /u:300140363 /d:AD-UFV /p:"$PASS" \
             /gateway:g:rdl.ufv.ca,u:300140363,d:AD-UFV,p:"$PASS",type:http \
             /dynamic-resolution +clipboard /cert:ignore
}


# For running playbooks
alias ap='withvault ansible-playbook'

# For managing the vault (editing, creating, rekeying)
alias av='withvault ansible-vault'

# To connect to ufv lab
alias urdp='ufv_connect'

# Alias for vscode
alias code='flatpak run com.visualstudio.code'

# Add Flatpak binaries to PATH
export PATH=$PATH:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin
export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock

# Gemini CLI - Podman Containerized (No-Clutter)
if [ ! -d "$HOME/.gemini/bin" ]; then mkdir -p "$HOME/.gemini/bin"; fi

alias gemini='podman run --rm -it \
  --userns=keep-id \
  --net=host \
  --env="TERM=xterm-256color" \
  -v "$HOME/.gemini:/home/node/.gemini:Z" \
  -v "$HOME/.gemini/bin:/home/node/.npm:Z" \
  -v "$(pwd):/home/node/project" \
  -w /home/node/project \
  node:20-slim \
  npx @google/gemini-cli'