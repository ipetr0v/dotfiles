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

# Rust / Cargo (avoids ~/.cargo/ and ~/.rustup/)
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Prepend user-installed binaries (pipx, pip --user, etc.) to PATH.
# zsh doesn't read ~/.profile, so we add it here. typeset -U keeps PATH unique
# even though .zshenv runs for every shell (nested shells, scripts).
typeset -U path PATH
path=("$HOME/.local/bin" "$CARGO_HOME/bin" $path)

# Prevent the system-wide zshrc from running its own compinit (which would write
# a dump under $ZDOTDIR). We call compinit ourselves in .zshrc with the XDG path.
# Plain (non-exported) var, ignored on systems that don't look for it. Some
# distros use a different opt-out; set that in .zshenv.local (see bottom).
skip_global_compinit=1

# Nix package manager (uses XDG state dir when use-xdg-base-directories = true).
_nix_sh="$XDG_STATE_HOME/nix/profile/etc/profile.d/nix.sh"
[ -e "$_nix_sh" ] && . "$_nix_sh"
unset _nix_sh

# Rootless Docker
[[ -S "$XDG_RUNTIME_DIR/docker.sock" ]] && export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"

# Machine-specific environment (not tracked in dotfiles).
# Must be here rather than in .zshrc.local for anything that has to be set
# before the system-wide zshrc runs — the global order is
#   /etc/zsh/zshenv -> ~/.zshenv -> /etc/zsh/zshrc -> $ZDOTDIR/.zshrc
[ -f "$ZDOTDIR/.zshenv.local" ] && source "$ZDOTDIR/.zshenv.local"
