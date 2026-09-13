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
