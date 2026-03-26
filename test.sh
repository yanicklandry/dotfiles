#!/usr/bin/env bash
# Dotfiles test suite
# Usage: ./test.sh
#   --bench   also run zsh startup benchmark (slower)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0
SKIP=0

# ── Helpers ───────────────────────────────────────────────────────────────────
_pass() { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
_fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }
_skip() { echo "  [SKIP] $1"; SKIP=$((SKIP + 1)); }
_header() { echo; echo "==> $1"; }

# ── 1. shellcheck ─────────────────────────────────────────────────────────────
_header "shellcheck"

if ! command -v shellcheck &>/dev/null; then
  _skip "shellcheck not installed (brew install shellcheck)"
else
  SCRIPTS=(
    bin/git-cleanup-merged-branches.sh
    bin/vpn_check.sh
    bin/dfs
    bin/code-wait
    bin/fix-stremio.sh
    bin/brew-size.sh
    bin/create_timestamp_folder.sh
    bin/restart_whisky.sh
    bin/setup_planet_crafter.sh
  )

  for script in "${SCRIPTS[@]}"; do
    path="$REPO_DIR/$script"
    if [ ! -f "$path" ]; then
      _skip "$script (not found)"
      continue
    fi
    if shellcheck "$path" 2>/dev/null; then
      _pass "$script"
    else
      shellcheck "$path" || true
      _fail "$script"
    fi
  done
fi

# ── 2. Executability ──────────────────────────────────────────────────────────
_header "bin/ executability"

while IFS= read -r -d '' f; do
  # Skip gitignored entries and .DS_Store
  name="$(basename "$f")"
  [[ "$name" == .DS_Store ]] && continue
  [[ -L "$f" ]] && continue   # symlinks: check their target instead

  if [ -x "$f" ]; then
    _pass "$name is executable"
  else
    _fail "$name is NOT executable (run: chmod +x bin/$name)"
  fi
done < <(find "$REPO_DIR/bin" -maxdepth 1 -type f -print0)

# ── 3. Broken symlinks ────────────────────────────────────────────────────────
_header "symlink health in bin/"

while IFS= read -r -d '' link; do
  target="$(readlink "$link")"
  if [ -e "$link" ]; then
    _pass "$(basename "$link") -> $target"
  else
    _fail "$(basename "$link") -> $target  (broken)"
  fi
done < <(find "$REPO_DIR/bin" -maxdepth 1 -type l -print0)

# ── 4. Dotfile presence ───────────────────────────────────────────────────────
_header "dotfiles present in repo"

DOTFILES=(.zshrc .zprofile .gitconfig .jshintrc)
for f in "${DOTFILES[@]}"; do
  if [ -f "$REPO_DIR/$f" ]; then
    _pass "$f"
  else
    _fail "$f missing from repo"
  fi
done

# ── 5. .env files not committed ───────────────────────────────────────────────
_header "no secrets in git index"

if git -C "$REPO_DIR" ls-files | grep -qE '\.env(\.|$)|secret|credential|token|\.pem$|\.key$'; then
  _fail "possible secrets found in tracked files"
  git -C "$REPO_DIR" ls-files | grep -E '\.env(\.|$)|secret|credential|token|\.pem$|\.key$' || true
else
  _pass "no secret-looking files tracked"
fi

# ── 6. zsh startup benchmark (opt-in) ────────────────────────────────────────
if [[ "${1:-}" == "--bench" ]]; then
  _header "zsh startup benchmark (10 runs)"

  if ! command -v zsh &>/dev/null; then
    _skip "zsh not found"
  else
    TIMES=()
    for i in $(seq 1 10); do
      t=$( { time zsh -i -c exit; } 2>&1 | grep real | awk '{print $2}' )
      TIMES+=("$t")
      printf "  run %2d: %s\n" "$i" "$t"
    done

    # Extract seconds for a rough average using awk
    AVG=$(printf '%s\n' "${TIMES[@]}" | \
      awk -F'[ms]' '{
        if (NF==3) { total += $1*60 + $2 }
        else { total += $1 }
        count++
      } END { printf "%.3fs", total/count }')
    echo "  average: $AVG"
    _pass "benchmark complete"
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo
echo "Results: ${PASS} passed, ${FAIL} failed, ${SKIP} skipped"
[ "$FAIL" -eq 0 ]
