# dotfiles

Application configs, kept in one place. The repository is the source of truth —
the paths each application reads from are symlinks back into here.

## Layout

| Path | Linked to |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `ghostty/` | `~/.config/ghostty` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `claude/` | individual entries inside `~/.claude` |

`~/.claude` is never symlinked as a whole directory — it also holds machine-local
state (credentials, session history, project data). `claude/install.sh` links
each tracked item separately and merges `settings.json` key by key.

## Install

```sh
./install.sh
```

Run it after `git clone` or `git pull` on a new machine. Existing real files at a
target path are backed up to `<path>.backup.<timestamp>` before being replaced
(interactive prompt; in a non-interactive shell the existing file is kept).

## tmux plugins

`tmux.conf` declares its plugins through [tpm](https://github.com/tmux-plugins/tpm).
The installer clones tpm to `~/.tmux/plugins/tpm` and runs `install_plugins` for
the plugins declared in `tmux.conf`. Without tmux on `PATH` the clone still
happens and only the plugin step is skipped; inside tmux you can always redo it
with `prefix + I`.

## muxbar

`tmux.conf` renders its status line with [muxbar](https://github.com/devbackend/muxbar),
a Rust binary built from its own repository. Its configuration is `src/config.rs`
over there, so it is not part of this repo — `install.sh` only makes sure the
binary exists.

The installer clones the repo to `~/Programming/rust/devbackend-muxbar` (override
with `MUXBAR_DIR`) and runs `cargo install --path`. It is skipped when the binary
is already present; force a rebuild with `MUXBAR_FORCE=1 ./install.sh`. A missing
Rust toolchain only skips this step — the rest of the install still completes.
