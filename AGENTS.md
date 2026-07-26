# Agent instructions

This repository installs the owner's macOS tmux and Neovim C/C++ environment.

## New-machine setup

1. Confirm the host is macOS.
2. Read `README.md` and inspect `install.sh`.
3. Run `./install.sh`.
4. If Apple Command Line Tools opens an installation dialog, wait for the user
   to finish it and then rerun the installer.
5. Do not replace pinned plugin versions or rewrite the configuration unless
   required to fix a verified compatibility failure.
6. Report the backup directory, installation result, and any health-check
   failures.

## Safety

- Never collect or commit credentials, tokens, SSH keys, `.env` files, or
  contents from password managers.
- Do not publish the repository or create a remote without the user's approval.
- Do not delete backups created under `~/.dotfiles-backup/`.
- Keep the installer idempotent.
