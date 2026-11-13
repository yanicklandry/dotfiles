#!/bin/bash

# Find first-level node_modules and .venv directories (not nested inside another
# node_modules/.venv), list them by size, and interactively delete the ones you pick.
#
# Usage: dep-cleanup.sh [--dry-run] [--list] [ROOT]
#   ROOT       directory to scan (default: current directory)
#   --dry-run  show what would be deleted, delete nothing
#   --list     only print the table, no prompt

set -u

DRY_RUN=false
LIST_ONLY=false
ROOT=""

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --list) LIST_ONLY=true ;;
    -h|--help) sed -n '3,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) ROOT="$arg" ;;
  esac
done
ROOT="${ROOT:-$PWD}"
ROOT="$(cd "$ROOT" 2>/dev/null && pwd)" || { echo "Not a directory: $ROOT" >&2; exit 1; }

if [[ -t 1 ]]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  BLUE='\033[0;34m'; DIM='\033[2m'; NC='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; BLUE=''; DIM=''; NC=''
fi

human() { # KB => human readable
  awk -v k="$1" 'BEGIN { split("K M G T", u); i=1; while (k>=1024 && i<4) { k/=1024; i++ } printf (i==1 ? "%d%s" : "%.1f%s"), k, u[i] }'
}

echo -e "${BLUE}🔍 Scanning ${ROOT} for node_modules and .venv...${NC}"

# -prune on the match stops find from descending into it, so nested ones are skipped.
# Also skip noisy/system locations.
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

find "$ROOT" \
  \( -path "$HOME/Library" -o -path "$HOME/.Trash" -o -name .git \) -prune -o \
  -type d \( -name node_modules -o -name .venv \) -prune -print 2>/dev/null |
while IFS= read -r dir; do
  kb=$(du -sk "$dir" 2>/dev/null | cut -f1)
  mtime=$(stat -f '%m' "$(dirname "$dir")" 2>/dev/null || echo 0)
  printf '%s\t%s\t%s\n' "${kb:-0}" "$mtime" "$dir"
done | sort -t$'\t' -k1,1nr > "$TMP"

COUNT=$(wc -l < "$TMP" | tr -d ' ')
if [[ "$COUNT" -eq 0 ]]; then
  echo -e "${GREEN}Nothing found.${NC}"
  exit 0
fi

# Load into indexed arrays (bash 3.2 compatible)
PATHS=(); SIZES=()
NOW=$(date +%s)
TOTAL=0
i=0
echo
printf "${DIM}%4s  %8s  %6s  %-12s  %s${NC}\n" "#" "SIZE" "AGE" "TYPE" "PROJECT"
while IFS=$'\t' read -r kb mtime dir; do
  i=$((i + 1))
  PATHS[$i]="$dir"; SIZES[$i]="$kb"
  TOTAL=$((TOTAL + kb))
  age_days=$(( (NOW - mtime) / 86400 ))
  type="$(basename "$dir")"
  project="${dir%/*}"; project="${project#$ROOT/}"
  [[ "$project" == "$ROOT" ]] && project="."
  color="$NC"; (( age_days > 90 )) && color="$YELLOW"
  printf "%4d  %8s  ${color}%5sd${NC}  %-12s  %s\n" "$i" "$(human "$kb")" "$age_days" "$type" "$project"
done < "$TMP"

echo -e "\n${BLUE}${COUNT} directories, $(human "$TOTAL") total${NC} ${DIM}(age = days since project folder changed; yellow > 90d)${NC}"

$LIST_ONLY && exit 0

echo
echo "Enter numbers to delete (e.g. 1 3 5-8), 'all', or press Enter to quit:"
read -r -p "> " SELECTION
[[ -z "$SELECTION" ]] && { echo "Nothing deleted."; exit 0; }

# Expand selection into a list of indexes
PICK=()
for tok in ${SELECTION//,/ }; do
  if [[ "$tok" == "all" ]]; then
    PICK=(); for ((n = 1; n <= COUNT; n++)); do PICK+=("$n"); done; break
  elif [[ "$tok" =~ ^([0-9]+)-([0-9]+)$ ]]; then
    for ((n = BASH_REMATCH[1]; n <= BASH_REMATCH[2]; n++)); do PICK+=("$n"); done
  elif [[ "$tok" =~ ^[0-9]+$ ]]; then
    PICK+=("$tok")
  else
    echo -e "${RED}Invalid token: $tok${NC}" >&2; exit 1
  fi
done

SEL_KB=0
echo -e "\n${YELLOW}Will delete:${NC}"
for n in "${PICK[@]}"; do
  if (( n < 1 || n > COUNT )); then echo -e "${RED}Out of range: $n${NC}" >&2; exit 1; fi
  echo "  $(human "${SIZES[$n]}")  ${PATHS[$n]}"
  SEL_KB=$((SEL_KB + SIZES[n]))
done
echo -e "${YELLOW}Total: $(human "$SEL_KB")${NC}"

if $DRY_RUN; then
  echo -e "\n[dry-run] nothing deleted."
  exit 0
fi

read -r -p "Confirm delete? [y/N] " ok
[[ "$ok" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

for n in "${PICK[@]}"; do
  dir="${PATHS[$n]}"
  # Safety: only ever remove dirs actually named node_modules or .venv
  case "$(basename "$dir")" in
    node_modules|.venv) rm -rf "$dir" && echo -e "${GREEN}✓${NC} $dir" || echo -e "${RED}✗${NC} $dir" ;;
    *) echo -e "${RED}skipped (unexpected name):${NC} $dir" ;;
  esac
done

echo -e "\n${GREEN}Freed ~$(human "$SEL_KB").${NC}"
