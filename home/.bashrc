# ~/.bashrc

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoredups:erasedups:ignorespace   # don't record space-prefixed commands
HISTTIMEFORMAT='%F %T '                        # show timestamps when running `history`
shopt -s histappend
shopt -s histverify   # !! and !42 show the command before running it

# Shell options
shopt -s checkwinsize  # Update LINES/COLUMNS after each command
shopt -s globstar      # ** matches files and dirs recursively
shopt -s cdspell       # Correct minor typos in cd arguments
bind 'set completion-ignore-case on'  # Case-insensitive tab completion

# Editor & paging
export EDITOR=vim
export VISUAL=vim
export LESS='-FRX'    # quit if one screen, allow ANSI colors, keep output on exit
export MANWIDTH=80    # cap man-page width on wide terminals

# Extra terminfo search path (e.g. xterm-ghostty installed per-server via tic).
# Trailing colon = then fall back to the compiled-in system terminfo dirs.
export TERMINFO_DIRS="${XDG_DATA_HOME:-$HOME/.local/share}/terminfo:"

# Homebrew (Mac only).
for _brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$_brew_path" ] && eval "$($_brew_path shellenv)" && break
done
unset _brew_path

# Make less friendlier for non-text input files (handles .gz, .tar, etc.).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Identify the chroot you're in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Detect color terminal capability.
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Prompt
#   PS1 escape sequences:
#   \u = user, \h = host, \w = full working dir, \$ = $ (or # for root)
#   \[\033[XXm\] = ANSI color code wrapped so bash doesn't count it visually
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# Set the xterm window title to user@host:dir.
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable color support for ls/grep.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases — kept in sync with OMZ defaults so muscle memory works in both shells.
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias md='mkdir -p'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias rm='rm -I'

# Ubuntu/Debian package-name fixups (no-op on Mac/Arch where binaries are unrenamed).
command -v batcat >/dev/null && alias bat='batcat'
command -v fdfind >/dev/null && alias fd='fdfind'

# eza — modern ls (overrides the ls aliases above when available).
if command -v eza >/dev/null; then
    alias ls='eza'
    alias l='eza -lah --git'
    alias ll='eza -lh --git'
    alias la='eza -lAh --git'
    alias lt='eza --tree --level=2'
fi

# CLI tool integrations (zoxide, fzf).
command -v zoxide >/dev/null && eval "$(zoxide init bash)"

[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && . /usr/share/doc/fzf/examples/key-bindings.bash
[ -f /usr/share/doc/fzf/examples/completion.bash ]   && . /usr/share/doc/fzf/examples/completion.bash

# fzf defaults — use fd if available (fdfind on Debian/Ubuntu).
fd_bin=$(command -v fdfind || command -v fd)
if [ -n "$fd_bin" ]; then
    export FZF_DEFAULT_COMMAND="$fd_bin --type f --hidden --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$fd_bin --type d --hidden --exclude .git"
fi
unset fd_bin
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'

# Source extra aliases.
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Bash completion.
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Activate the default user virtualenv if present (created once; see dotfiles README).
# VIRTUAL_ENV_DISABLE_PROMPT stops activate from prefixing "(venv)" — Starship shows it instead.
export VIRTUAL_ENV_DISABLE_PROMPT=1
venv_activate="${XDG_DATA_HOME:-$HOME/.local/share}/venv/bin/activate"
[ -f "$venv_activate" ] && . "$venv_activate"
unset venv_activate

# Starship prompt (when installed).
command -v starship >/dev/null && eval "$(starship init bash)"

# Machine-specific config (not tracked in dotfiles).
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
[ -f ~/.secrets ] && source ~/.secrets
