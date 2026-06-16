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

# GPG keyring
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Docker config (avoids ~/.docker/)
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Python REPL history (avoids ~/.python_history)
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

# Extra terminfo search path (e.g. xterm-ghostty installed per-server via tic).
# Trailing colon = then fall back to the compiled-in system terminfo dirs.
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:"

# Prepend user-installed binaries (pipx, pip --user, etc.) to PATH.
# zsh doesn't read ~/.profile, so we add it here. typeset -U keeps PATH unique
# even though .zshenv runs for every shell (nested shells, scripts).
typeset -U path PATH
path=("$HOME/.local/bin" $path)

# Prevent /etc/zsh/zshrc from calling bare compinit (which would write
# $ZDOTDIR/.zcompdump). We call compinit ourselves in .zshrc with the XDG path.
skip_global_compinit=1

# Nix package manager (uses XDG state dir when use-xdg-base-directories = true).
_nix_sh="$XDG_STATE_HOME/nix/profile/etc/profile.d/nix.sh"
[ -e "$_nix_sh" ] && . "$_nix_sh"
unset _nix_sh

# Rootless Docker
[[ -S "$XDG_RUNTIME_DIR/docker.sock" ]] && export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
