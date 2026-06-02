# Dotfiles

Personal shell, editor and CLI config. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup on a new machine

### 1. Install packages

**Ubuntu / Debian**

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    git stow curl \
    vim tmux \
    bat fd-find ripgrep eza \
    fzf zoxide \
    htop tree jq \
    python3 python3-venv python3-pip \
    zsh
```

> On Debian/Ubuntu the `bat` and `fd` binaries are installed as `batcat` and `fdfind`
> due to package-name conflicts with older tools. The shell rc files alias them
> back to `bat` / `fd` automatically.

Starship (prompt) isn't reliably packaged in apt — install via the upstream script:

```bash
curl -sS https://starship.rs/install.sh | sh
```

<details>
<summary><b>macOS</b></summary>

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install \
    stow \
    vim tmux \
    bat fd ripgrep eza \
    fzf zoxide \
    htop tree jq \
    python \
    starship \
    zsh
```

</details>

### 2. Clone and stow

```bash
git clone https://github.com/ipetr0v/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow home
```

`stow home` symlinks everything under `~/.dotfiles/home/` into `$HOME`,
preserving directory structure. To remove: `stow -D home`.

### 3. Set zsh as default shell (optional)

```bash
chsh -s "$(command -v zsh)"
```

### 4. Default Python virtualenv (optional)

Both shells auto-activate a venv at `~/.local/share/venv` if it exists.
Create it once for a clean default Python with your common CLI packages:

```bash
python3 -m venv ~/.local/share/venv
~/.local/share/venv/bin/pip install --upgrade pip
```

For per-project environments use a project-local `.venv` (and `direnv` to
auto-activate) rather than this shared one.

### 5. Per-machine config

These files are gitignored — create per machine as needed:

| File | Purpose |
|---|---|
| `~/.bashrc.local` | bash overrides |
| `~/.config/zsh/.zshrc.local` | zsh overrides |
| `~/.vimrc.local` | vim overrides (e.g. `set clipboard=unnamedplus` on desktop) |
| `~/.gitconfig` | git identity (different for personal/work machines) |
| `~/.secrets` | API tokens, etc. — sourced by both shells if present |

## Terminal: Ghostty

[Ghostty](https://ghostty.org) is the desktop terminal emulator
(on Windows, WSL runs under Windows Terminal instead).

**Ubuntu / Debian**

Not in the default apt repos — install via the community `.deb`
([mkasberg/ghostty-ubuntu](https://github.com/mkasberg/ghostty-ubuntu)), or see the
[install guide](https://ghostty.org/docs/install) for other options.

Ghostty uses its own `xterm-ghostty` terminfo — present locally, but **not** on most
remote servers, so SSH sessions can show a garbled prompt. Copy the entry to a server
once (the dotfiles already add `~/.local/share/terminfo` to the terminfo search path):

```bash
infocmp -x xterm-ghostty | ssh user@host -- tic -x -o '$HOME/.local/share/terminfo' -
```

<details>
<summary><b>macOS</b></summary>

```bash
brew install --cask ghostty
```

</details>

## Layout

Everything that maps into `$HOME` lives under `home/` (the single stow package).
Repo-meta (`README`, `.git`) stays at the root, so there's nothing to ignore.

```
~/.dotfiles/
├── README.md
├── .gitignore
└── home/                      # stow package — mirrors $HOME
    ├── .bashrc
    ├── .zshenv
    ├── .vimrc
    └── .config/
        ├── zsh/               # .zshrc, plugins.zsh, aliases.zsh, zsh_plugins.txt
        ├── nix/nix.conf       # Nix: flakes + XDG base directories
        ├── bat/config
        ├── python/startup.py
        └── starship.toml
```
