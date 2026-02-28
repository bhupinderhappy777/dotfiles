export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Starship Initialization
eval "$(starship init zsh)"

# Wrapper to run ANY command with the KWallet Vault password
withvault() {
    local WALLET="kdewallet"
    local FOLDER="Secret Service"
    local ENTRY="vault_pass"

    # Run the provided command ($@) with the vault variable set
    ANSIBLE_VAULT_PASSWORD_FILE=<(kwallet-query -r "$ENTRY" -f "$FOLDER" "$WALLET") "$@"
}

# For running playbooks
alias ap='withvault ansible-playbook'

# For managing the vault (editing, creating, rekeying)
alias av='withvault ansible-vault'
