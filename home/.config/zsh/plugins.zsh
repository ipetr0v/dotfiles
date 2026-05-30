# ~/.config/zsh/plugins.zsh

antidote_home="$XDG_DATA_HOME/antidote"

# Bootstrap antidote on first run.
if [[ ! -f "$antidote_home/antidote.zsh" ]]; then
    echo "Bootstrapping antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_home"
fi

# Plugin list and a generated static bundle (cache)
zsh_plugins_txt="$ZDOTDIR/zsh_plugins.txt"
zsh_plugins_static="$XDG_CACHE_HOME/zsh/plugins.zsh"
mkdir -p "$(dirname "$zsh_plugins_static")"

# Regenerate bundle if missing or stale
if [[ ! -f "$zsh_plugins_static" ]] || [[ "$zsh_plugins_txt" -nt "$zsh_plugins_static" ]]; then
    source "$antidote_home/antidote.zsh"
    antidote bundle < "$zsh_plugins_txt" > "$zsh_plugins_static"
fi

source "$zsh_plugins_static"

# Re-run compinit so completions added to $fpath by plugins (e.g. zsh-completions) are picked up
compinit -d "$ZSH_COMPDUMP"
