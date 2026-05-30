# ~/.config/zsh/aliases.zsh

# Ubuntu/Debian package-name fixups (no-op on Mac/Arch where binaries are unrenamed).
command -v batcat >/dev/null && alias bat='batcat'
command -v fdfind >/dev/null && alias fd='fdfind'

# Edit/reload shortcuts
alias zshrc='$EDITOR $ZDOTDIR/.zshrc'
alias aliases='$EDITOR $ZDOTDIR/aliases.zsh'
alias reload='exec zsh'

# Grep color (not defaulted in zsh)
alias grep='grep --color=auto'

# Personal preferences
alias c='clear'
alias rm='rm -I'

# Human-readable sizes (OMZ doesn't ship these)
alias df='df -h'
alias du='du -h'
alias free='free -h'

# eza — modern ls (overrides OMZ ls aliases when available).
if (( $+commands[eza] )); then
    alias ls='eza'
    alias l='eza -lah --git'
    alias ll='eza -lh --git'
    alias la='eza -lAh --git'
    alias lt='eza --tree --level=2'
fi
