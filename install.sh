#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer currently supports macOS only." >&2
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Apple Command Line Tools. Finish the dialog, then run this script again."
  xcode-select --install
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Installing command-line dependencies..."
# --no-upgrade keeps reruns from upgrading unrelated packages already on the machine.
HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 \
  brew bundle install --no-upgrade --file="$DOTFILES_DIR/Brewfile"

backup_conflict() {
  local target="$1"
  local expected="$2"

  # Stow writes relative symlinks, so compare resolved paths.
  if [[ -L "$target" ]] && [[ "$(cd "$(dirname "$target")" && realpath "$(readlink "$target")" 2>/dev/null)" == "$expected" ]]; then
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local relative="${target#"$HOME"/}"
    mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
    mv "$target" "$BACKUP_DIR/$relative"
    echo "Backed up $target to $BACKUP_DIR/$relative"
  fi
}

mkdir -p "$HOME/.config" "$HOME/.tmux/plugins"
backup_conflict "$HOME/.config/nvim" "$DOTFILES_DIR/nvim/.config/nvim"
backup_conflict "$HOME/.tmux.conf" "$DOTFILES_DIR/tmux/.tmux.conf"

echo "Linking configuration..."
stow --dir="$DOTFILES_DIR" --target="$HOME" --restow nvim tmux

if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# TPM needs a running server to install plugins.
if tmux list-sessions >/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux.conf"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
else
  tmux new-session -d -s dotfiles-bootstrap
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
  tmux kill-session -t dotfiles-bootstrap
fi

echo "Installing Neovim plugins and development tools..."
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonToolsInstallSync" +qa
nvim --headless \
  "+checkhealth lazy mason nvim-treesitter vim.lsp" \
  "+lua local errors={}; for _,line in ipairs(vim.api.nvim_buf_get_lines(0,0,-1,false)) do if line:match('ERROR') then table.insert(errors,line) end end; assert(#errors == 0, table.concat(errors,'\n'))" \
  +qa

echo
echo "Environment installed successfully."
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Previous configuration was saved under $BACKUP_DIR."
fi
echo "Open a new terminal, then run: nvim"
