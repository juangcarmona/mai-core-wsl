#!/bin/zsh

set -e

# Import logging functions and constants
source "$(dirname "$0")/logs.sh"
source "$(dirname "$0")/constants.sh"

log "Starting alias import..."

# Path to the aliases file
ALIAS_FILE="$HOME/.zsh_aliases"
log "Exporting useful aliases to $ALIAS_FILE..."

# Write aliases to the file
cat << 'EOF' > "$ALIAS_FILE"
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gp='git push'
alias gl='git pull'
alias gh='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcl='git clone'
alias gb='git branch'
alias gm='git merge'
alias hg='history | grep'
alias ll='ls -alF --color=auto'
alias cls='clear'
alias duh='du -h --max-depth=1'
alias dfh='df -h'
alias dus='du -sh *'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias q='exit'
alias mai='cd ~/mai'
alias .mai='cd ~/.mai'
alias zshrc='nano ~/.zshrc'
alias src='source ~/.zshrc'
alias myip='curl ifconfig.me'
alias meminfo='free -m -l -t'
alias netstat='netstat -tulanp'
alias aliaslist='alias | sort'
EOF

log "Checking if aliases are already included in $ZSHRC..."

# Add source command to .zshrc if not already present
if ! grep -q "source $ALIAS_FILE" "$ZSHRC"; then
    echo "\n# Load custom aliases\nsource $ALIAS_FILE" >> "$ZSHRC"
    log "Aliases added to $ZSHRC."
else
    log "Aliases are already included in $ZSHRC. Skipping."
fi

log "Alias import completed successfully."
