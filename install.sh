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

echo ""
echo "✨ Done."
