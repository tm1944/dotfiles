# Neovim C/C++ IDE

Open Neovim at a project root. CMake projects should configure with
`-DCMAKE_EXPORT_COMPILE_COMMANDS=1`; the CMake integration does this and links
the resulting database into the project root so clangd sees the exact include
paths and compiler flags.

## Core keys

| Keys | Action |
| --- | --- |
| `Space e` | Toggle file explorer |
| `Space ff` / `Space fg` | Find files / search text |
| `gd` / `gr` / `gI` | Definition / references / implementations |
| `K` / `gK` | Hover docs / signature help |
| `Space cr` / `Space ca` | Rename / code action |
| `Space cf` | Format |
| `Space ch` | Switch C/C++ source and header |
| `Space ci` | Toggle inlay hints |
| `Space xx` | Workspace diagnostics |
| `Ctrl-Space` | Open completion menu |
| `Space uc` | Toggle animated cursor |

Completion uses `Tab` and `Shift-Tab` to move through candidates and snippet
fields, and `Enter` to accept.

## Build and run

| Keys | Action |
| --- | --- |
| `Space mg` | Configure/generate CMake project |
| `Space mb` | Build |
| `Space mt` | Select build target |
| `Space mr` | Run selected target |
| `Space md` | Debug selected target |
| `Space mv` | Select Debug/Release variant |
| `Space bk` | Run `make` for a non-CMake project |
| `Ctrl-\`` | Toggle terminal |

## Debug and test

| Keys | Action |
| --- | --- |
| `F5` / `F10` / `F11` / `F12` | Continue / over / into / out |
| `Space db` | Toggle breakpoint |
| `Space du` | Toggle debug UI |
| `Space tn` / `Space tf` / `Space ta` | Test nearest / file / all |
| `Space td` | Debug nearest test |
| `Space ts` / `Space to` | Test summary / output |

GoogleTest executables must be registered with CTest (normally with CMake's
`gtest_discover_tests`) and built before running them. The test adapter then
discovers the executable and maps CTest results back to the source.

## Git and navigation

| Keys | Action |
| --- | --- |
| `]h` / `[h` | Next / previous Git hunk |
| `Space gp` | Preview hunk |
| `Space gb` | Toggle current-line blame |
| `Ctrl-h/j/k/l` | Move across Neovim splits and tmux panes |
| `Option-h/j/k/l` | Move directly between tmux panes |

Run `:Mason` to inspect managed tools, `:ConformInfo` for formatting, and
`:checkhealth` when troubleshooting.
