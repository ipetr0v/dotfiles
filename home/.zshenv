# ~/.zshenv
# Loaded first, for every zsh invocation (interactive, login, scripts).

# Move zsh config out of $HOME
export ZDOTDIR=~/.config/zsh

# XDG base dirs
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_CACHE_HOME=~/.cache
export XDG_STATE_HOME=~/.local/state
# Note: XDG_RUNTIME_DIR is managed by systemd/PAM — don't set it here

# Completion dump cache. Without this, non-interactive shells would default to
# $ZDOTDIR/.zcompdump since ZDOTDIR is set above.
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# less history
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# Prevent /etc/zsh/zshrc from calling bare compinit (which would write
# $ZDOTDIR/.zcompdump). We call compinit ourselves in .zshrc with the XDG path.
skip_global_compinit=1
