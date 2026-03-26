#!/usr/bin/env bash
# Bootstrap dotfiles onto a new machine.
# Safe to re-run: existing targets are skipped (use -f to overwrite with backup).
#
# Usage:
#   ./install.sh        # dry-run preview
#   ./install.sh -y     # apply symlinks
#   ./install.sh -yf    # apply, backing up any existing files first

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY=true
FORCE=false

for arg in "$@"; do
  case "$arg" in
    -y|--yes)   DRY=false ;;
    -f|--force) FORCE=true ;;
    -yf|-fy)    DRY=false; FORCE=true ;;
  esac
done

$DRY && echo "[dry-run] pass -y to apply changes" && echo

# ── Helpers ───────────────────────────────────────────────────────────────────
_link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  [ok]     $dst -> $src"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if $FORCE; then
      $DRY || mv "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
      echo "  [backup] $dst"
    else
      echo "  [skip]   $dst already exists (use -f to backup and replace)"
      return
    fi
  fi
  echo "  [link]   $dst -> $src"
  $DRY || ln -sf "$src" "$dst"
}

# ── Root-level dotfiles ───────────────────────────────────────────────────────
echo "Dotfiles:"
_link "$REPO_DIR/.zshrc"    "$HOME/.zshrc"
_link "$REPO_DIR/.zprofile" "$HOME/.zprofile"
_link "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"
_link "$REPO_DIR/.jshintrc" "$HOME/.jshintrc"

# ── .env.local from template ──────────────────────────────────────────────────
echo
echo "Secrets template:"
if [ ! -f "$HOME/.env.local" ]; then
  echo "  [copy]   ~/.env.local (from template — fill in your API keys)"
  $DRY || cp "$REPO_DIR/.env.local.template" "$HOME/.env.local"
else
  echo "  [ok]     ~/.env.local already exists"
fi

# ── ~/bin ─────────────────────────────────────────────────────────────────────
echo
echo "bin/:"
if [ -L "$HOME/bin" ] && [ "$(readlink "$HOME/bin")" = "$REPO_DIR/bin" ]; then
  echo "  [ok]     ~/bin -> $REPO_DIR/bin"
elif [ -d "$HOME/bin" ] && ! [ -L "$HOME/bin" ]; then
  # ~/bin is a real directory — symlink individual files instead
  while IFS= read -r -d '' f; do
    name="$(basename "$f")"
    [[ "$name" == .DS_Store ]] && continue
    _link "$f" "$HOME/bin/$name"
  done < <(find "$REPO_DIR/bin" -maxdepth 1 \( -type f -o -type l \) -print0)
else
  echo "  [link]   ~/bin -> $REPO_DIR/bin"
  $DRY || ln -sf "$REPO_DIR/bin" "$HOME/bin"
fi

# ── Git hooks ─────────────────────────────────────────────────────────────────
echo
echo "Git hooks:"
if [ -d "$REPO_DIR/.git" ]; then
  while IFS= read -r -d '' hook; do
    name="$(basename "$hook")"
    _link "$hook" "$REPO_DIR/.git/hooks/$name"
  done < <(find "$REPO_DIR/hooks" -maxdepth 1 -type f -print0)
else
  echo "  [skip]   not inside a git repo"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo
if $DRY; then
  echo "Dry-run complete. Run './install.sh -y' to apply."
else
  echo "Done. Open a new shell or: source ~/.zshrc"
fi
