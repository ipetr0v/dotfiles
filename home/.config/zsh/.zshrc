# ~/.config/zsh/.zshrc

# History — zsh, less and node's REPL all keep history files under here.
# None of the three create the parent dir themselves, so do it once up front.
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_STATE_HOME/less" "$XDG_STATE_HOME/node"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY      # record timestamp + duration with each entry
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

# Shell options
setopt AUTO_CD            # type a dir name to cd into it
setopt AUTO_PUSHD         # cd auto-pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS  # don't push the same dir twice
setopt PUSHD_SILENT       # don't print the stack after pushd/popd
setopt EXTENDED_GLOB      # ^pattern, (foo|bar), **/, etc.

# Editor & paging
export EDITOR=vim
export VISUAL=vim
export LESS='-FRX'    # quit if one screen, allow ANSI colors, keep output on exit
export MANWIDTH=80    # cap man-page width on wide terminals

# Some system-wide zshrc files set the next two, others don't, and we suppress
# parts of that file anyway (see the compinit note in .zshenv). Set them
# explicitly so behaviour is the same on every machine.

# Pager for bare redirections with no command, e.g. `< file`.
READNULLCMD=${PAGER:-less}

# zsh ships `run-help` as an alias for `man`. The autoloaded function is
# smarter: it handles builtins, keywords and `git commit`-style subcommands.
(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# Homebrew (Mac only).
() {
    local brew_path
    for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        [[ -x "$brew_path" ]] && eval "$($brew_path shellenv)" && break
    done
}

# Make less friendlier for non-text input files (handles .gz, .tar, etc.).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Zsh completion cache.
# ZSH_COMPDUMP is set in .zshenv; mkdir guard here since .zshenv runs
# before the cache dir is guaranteed to exist.
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

[ -f "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh"
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# Completion styling.
# Must come after plugins so fzf-tab is loaded.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # color files using LS_COLORS
zstyle ':completion:*' menu no                           # let fzf-tab replace the menu

# Let `sudo <tab>` find sbin binaries, which aren't on a normal user's PATH.
# Set here rather than relying on the system-wide zshrc to do it.
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'          # preview on cd <tab>
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'  # preview on z <tab>

# fzf keybindings and completion.
fzf_dir=/usr/share/doc/fzf/examples
[ -f "$fzf_dir/key-bindings.zsh" ] && source "$fzf_dir/key-bindings.zsh"
[ -f "$fzf_dir/completion.zsh" ] && source "$fzf_dir/completion.zsh"

# fzf defaults — use fd (fast, respects .gitignore). Binary is fdfind on Debian/Ubuntu, fd elsewhere.
if (( $+commands[fdfind] )) || (( $+commands[fd] )); then
    fd_bin=${commands[fdfind]:-${commands[fd]}}
    export FZF_DEFAULT_COMMAND="$fd_bin --type f --hidden --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$fd_bin --type d --hidden --exclude .git"
    unset fd_bin
fi
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'

# zoxide: smarter cd (use `z <dir>` to jump)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Activate the default user virtualenv if present (created once; see dotfiles README).
# VIRTUAL_ENV_DISABLE_PROMPT stops activate from prefixing "(venv)" — Starship shows it instead.
export VIRTUAL_ENV_DISABLE_PROMPT=1
[ -f "$XDG_DATA_HOME/venv/bin/activate" ] && source "$XDG_DATA_HOME/venv/bin/activate"

# Starship prompt — overrides the theme when installed.
command -v starship >/dev/null && eval "$(starship init zsh)"

# zsh-transient-prompt captures $PROMPT when it loads (in the bundle, before
# Starship sets it), so its saved "full prompt" would wrongly be the default
# %m%#. Re-point it at Starship's prompt here, now that init has run.
if (( ${+TRANSIENT_PROMPT_PROMPT} )); then
    TRANSIENT_PROMPT_PROMPT=$PROMPT
    TRANSIENT_PROMPT_RPROMPT=$RPROMPT
    # Collapsed prompt = Starship's character module (green/red by exit status),
    # via a small "transient" profile. Reuses $PROMPT's already-wired --status args.
    TRANSIENT_PROMPT_TRANSIENT_PROMPT="${PROMPT// prompt / prompt --profile transient }"
fi

# Machine-specific config (not tracked in dotfiles).
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"
[ -f ~/.secrets ] && source ~/.secrets

# direnv — auto-load .envrc when cd'ing into a project (e.g. Nix flakes).
# Must be last so it hooks into the final prompt.
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

