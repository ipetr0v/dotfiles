# $ZDOTDIR/.zshenv
# Loaded when ZDOTDIR is already set in the inherited environment (e.g. when
# opening a new Terminator tab that inherits ZDOTDIR from a parent shell).
# In that case zsh skips ~/.zshenv and looks here instead.
#
# We just re-source the canonical ~/.zshenv so all vars stay in one place.
# Guard against double-sourcing by checking a sentinel var.
if [[ -z "$_ZSHENV_SOURCED" ]]; then
    export _ZSHENV_SOURCED=1
    [[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
fi
