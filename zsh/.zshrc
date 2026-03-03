export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Starship Initialization
eval "$(starship init zsh)"

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

# Add Flatpak binaries to PATH
export PATH=$PATH:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin
