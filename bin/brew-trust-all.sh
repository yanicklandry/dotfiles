#!/usr/bin/env bash
# Trust all non-official Homebrew taps.
# Replaces the deprecated HOMEBREW_NO_REQUIRE_TAP_TRUST environment variable.
set -euo pipefail

# Official Homebrew taps are trusted by default; no need to trust them explicitly.
official_re='^homebrew/(core|cask|cask-versions|cask-fonts|bundle|services|command-not-found)$'

while IFS= read -r tap; do
  [ -z "$tap" ] && continue
  if [[ "$tap" =~ $official_re ]]; then
    echo "skipping official tap: $tap"
  else
    echo "trusting: $tap"
    brew trust "$tap"
  fi
done < <(brew tap)

echo "Done. Remove HOMEBREW_NO_REQUIRE_TAP_TRUST from your shell profile (e.g. ~/.zshrc) and restart your terminal."
