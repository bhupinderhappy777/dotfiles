export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Add local bin to PATH for pip-installed tools (Ansible, etc.)
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH

PROMPT='%F{cyan}%n%f@%F{blue}%m%f %F{green}➜ %F{white}%~ %f$(git branch 2>/dev/null | grep "* " | sed -e "s/* \(.*\)/ (\1)/") %# '

