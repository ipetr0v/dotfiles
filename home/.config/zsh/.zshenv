# $ZDOTDIR/.zshenv
# Loaded when ZDOTDIR is already set in the inherited environment (e.g. when
# opening a new Terminator tab that inherits ZDOTDIR from a parent shell).
# In that case zsh skips ~/.zshenv and looks here instead.
#
# We just re-source the canonical ~/.zshenv so all vars stay in one place.
#
# Deliberately no re-entrancy guard. zsh reads exactly one .zshenv per shell —
# this file OR ~/.zshenv, never both — and ~/.zshenv does not source this one
# back, so there is nothing to guard against. An exported guard is actively
# harmful: the first nested shell sets it, and every shell below that sees it
# already set and skips ~/.zshenv, losing everything non-exported.
[[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
