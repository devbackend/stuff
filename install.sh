#!/usr/bin/env bash

# Dotfiles installer - symlinks every app config from this repository
# to the location its application expects.
# Run after git clone or git pull on a new machine.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "🔧 Dotfiles Installer"
echo "Repository: $REPO_DIR"
echo ""

mkdir -p "$CONFIG_DIR"

create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [ -L "$target" ]; then
        echo "  ✓ Symlink already exists: $name"
        ln -snf "$source" "$target"
    elif [ -e "$target" ]; then
        echo "  ⚠️  Warning: $target already exists and is not a symlink"
        if [ ! -t 0 ]; then
            echo "  ⚠️  Non-interactive: keeping existing $target"
            return 0
        fi
        read -p "  Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
            echo "  📦 Backed up to ${target}.backup.*"
            ln -s "$source" "$target"
            echo "  ✅ Created symlink: $name"
        else
            echo "  ⏭️  Skipped: $name"
        fi
    else
        ln -s "$source" "$target"
        echo "  ✅ Created symlink: $name"
    fi
}

echo "🔗 Linking nvim..."
create_symlink "$REPO_DIR/nvim" "$CONFIG_DIR/nvim" "~/.config/nvim"

echo "🔗 Linking ghostty..."
create_symlink "$REPO_DIR/ghostty" "$CONFIG_DIR/ghostty" "~/.config/ghostty"

echo "🔗 Linking tmux..."
create_symlink "$REPO_DIR/tmux/tmux.conf" "$HOME/.tmux.conf" "~/.tmux.conf"

echo ""
echo "🔗 Delegating to claude/install.sh..."
bash "$REPO_DIR/claude/install.sh"

# tmux.conf declares its plugins via tpm, which tpm itself must be present to
# resolve — without it the `run` line at the bottom of tmux.conf is a no-op and
# none of the declared plugins load. Non-fatal, same as muxbar below.
echo ""
echo "🔌 Installing tpm (tmux plugin manager)..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm"

install_tpm() {
    if [ ! -d "$TPM_DIR" ]; then
        echo "  📥 Cloning $TPM_REPO -> $TPM_DIR"
        mkdir -p "$(dirname "$TPM_DIR")"
        git clone "$TPM_REPO" "$TPM_DIR" || {
            echo "  ⚠️  Clone failed — skipping tpm"
            return 0
        }
    else
        echo "  ✓ tpm already present ($TPM_DIR)"
    fi

    if ! command -v tmux >/dev/null 2>&1; then
        echo "  ⚠️  tmux not found — skipping plugin installation"
        echo "     Install tmux, then run: $TPM_DIR/bin/install_plugins"
        return 0
    fi

    echo "  🔨 Installing declared plugins..."
    "$TPM_DIR/bin/install_plugins" || {
        echo "  ⚠️  Plugin installation failed — skipping"
        echo "     Retry inside tmux with prefix + I."
        return 0
    }
    echo "  ✅ tpm plugins installed"
}

install_tpm

# muxbar renders the tmux status-right. It is a Rust binary built from its own
# repository — its configuration is src/config.rs there, so it cannot be
# symlinked from here like the other configs; it has to be compiled and installed.
# Kept last and non-fatal: a missing toolchain must not abort the config install.
echo ""
echo "📊 Installing muxbar..."
MUXBAR_DIR="${MUXBAR_DIR:-$HOME/Programming/rust/devbackend-muxbar}"
MUXBAR_REPO="git@github.com:devbackend/muxbar.git"
CARGO_BIN="$HOME/.cargo/bin"

install_muxbar() {
    # install.sh may run without a login shell, so ~/.cargo/bin is not
    # necessarily on PATH — probe the binaries by absolute path.
    if [ -x "$CARGO_BIN/muxbar" ] && [ "${MUXBAR_FORCE:-0}" != "1" ]; then
        echo "  ✓ muxbar already installed ($CARGO_BIN/muxbar)"
        echo "    Rebuild with: MUXBAR_FORCE=1 $0"
        return 0
    fi

    if [ ! -x "$CARGO_BIN/cargo" ]; then
        echo "  ⚠️  cargo not found at $CARGO_BIN/cargo — skipping muxbar"
        echo "     Install Rust (https://rustup.rs), then re-run this script."
        return 0
    fi

    if [ ! -d "$MUXBAR_DIR" ]; then
        echo "  📥 Cloning $MUXBAR_REPO -> $MUXBAR_DIR"
        mkdir -p "$(dirname "$MUXBAR_DIR")"
        git clone "$MUXBAR_REPO" "$MUXBAR_DIR" || {
            echo "  ⚠️  Clone failed — skipping muxbar"
            return 0
        }
    fi

    echo "  🔨 Building from $MUXBAR_DIR (this takes a while)"
    "$CARGO_BIN/cargo" install --path "$MUXBAR_DIR" --locked || {
        echo "  ⚠️  Build failed — skipping muxbar"
        echo "     tmux status-right '#(muxbar)' will render empty until it is built."
        return 0
    }
    echo "  ✅ muxbar installed"
}

install_muxbar

echo ""
echo "✨ Done."
