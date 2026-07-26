# C/C++ terminal development environment

Portable macOS dotfiles for a tmux and Neovim C/C++ IDE. The setup includes
clangd completion, clang-format, CMake, GoogleTest/CTest, CodeLLDB debugging,
Telescope, Git signs, Treesitter, an animated cursor, and seamless navigation
between Neovim splits and tmux panes.

## Install on a new Mac

Install Apple's Command Line Tools first:

```bash
xcode-select --install
```

Then clone this repository and run the installer:

```bash
git clone https://github.com/tm1944/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer is safe to rerun. Existing `~/.config/nvim` and `~/.tmux.conf`
paths are moved into a timestamped `~/.dotfiles-backup/` directory before the
new configuration is linked.

## Install with a coding agent

After cloning, open the repository in your agent and ask:

> Read AGENTS.md and install this environment. Stop if authentication or an
> operating-system compatibility issue requires my input.

The actual setup remains deterministic; the agent should run and verify
`./install.sh` rather than recreating the configuration from scratch.

## What is managed

- `nvim/.config/nvim`: Neovim configuration and pinned plugin lockfile
- `tmux/.tmux.conf`: tmux configuration and TPM plugins
- `Brewfile`: command-line dependencies
- `install.sh`: repeatable bootstrap and health checks

GNU Stow creates symlinks from these packages into your home directory.
Neovim's Mason integration installs clangd, clang-format, CodeLLDB, and
Pyright. The committed `lazy-lock.json` pins plugin revisions.

## Updating

After changing the live configuration, edit the corresponding file in this
repository (the live files are symlinks after installation), then verify:

```bash
nvim --headless "+Lazy! sync" +qa
nvim --headless "+checkhealth lazy mason nvim-treesitter vim.lsp" +qa
tmux source-file ~/.tmux.conf
```

Review changes before committing:

```bash
git status
git diff
```

Never commit SSH keys, API tokens, `.env` files, Git credentials, or other
machine-specific secrets.
