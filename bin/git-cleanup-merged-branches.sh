#!/bin/bash

# Script to delete local branches whose remote tracking branches have been deleted
# This happens after PRs are merged and remote branches are deleted
# Usage: ./scripts/cleanup-merged-branches.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Cleaning up local branches with deleted remotes...${NC}\n"

# Fetch and prune to update remote tracking branches
echo -e "${YELLOW}Fetching and pruning remote branches...${NC}"
git fetch --prune

# Protected branches that should never be deleted
PROTECTED_BRANCHES="master|staging|develop|main"

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "\n${BLUE}Current branch: ${CURRENT_BRANCH}${NC}\n"

# Find branches with deleted remotes (marked as "gone")
BRANCHES_TO_DELETE=$(git branch -vv | grep ': gone]' | awk '{print $1}' | sed 's/^[* ]*//')

if [ -z "$BRANCHES_TO_DELETE" ]; then
    echo -e "${GREEN}✅ No branches to delete. All clean!${NC}"
    exit 0
fi

echo -e "${YELLOW}Branches with deleted remotes:${NC}"
echo "$BRANCHES_TO_DELETE" | while read branch; do
    echo "  - $branch"
done
echo ""

# Filter out protected branches
FILTERED_BRANCHES=""
SKIPPED_BRANCHES=""

while IFS= read -r branch; do
    if echo "$branch" | grep -E "^($PROTECTED_BRANCHES)$" > /dev/null; then
        SKIPPED_BRANCHES="$SKIPPED_BRANCHES $branch"
    else
        FILTERED_BRANCHES="$FILTERED_BRANCHES $branch"
    fi
done <<< "$BRANCHES_TO_DELETE"

# Show skipped protected branches if any
if [ -n "$SKIPPED_BRANCHES" ]; then
    echo -e "${YELLOW}⚠️  Skipping protected branches:${NC}"
    echo "$SKIPPED_BRANCHES" | tr ' ' '\n' | grep -v '^$' | while read branch; do
        echo "  - $branch"
    done
    echo ""
fi

# Exit if no branches to delete after filtering
if [ -z "$FILTERED_BRANCHES" ]; then
    echo -e "${GREEN}✅ No branches to delete after filtering. All clean!${NC}"
    exit 0
fi

# Switch to a safe branch if current branch will be deleted
WILL_DELETE_CURRENT=false
while IFS= read -r branch; do
    if [ "$branch" = "$CURRENT_BRANCH" ]; then
        WILL_DELETE_CURRENT=true
        break
    fi
done <<< "$(echo $FILTERED_BRANCHES | tr ' ' '\n' | grep -v '^$')"

if [ "$WILL_DELETE_CURRENT" = true ]; then
    echo -e "${YELLOW}Current branch will be deleted. Switching to staging...${NC}"
    if git show-ref --verify --quiet refs/heads/staging; then
        git checkout staging
        git pull origin staging
    elif git show-ref --verify --quiet refs/heads/develop; then
        git checkout develop
        git pull origin develop
    elif git show-ref --verify --quiet refs/heads/main; then
        git checkout main
        git pull origin main
    else
        git checkout master
        git pull origin master
    fi
    echo ""
fi

# Delete branches (without force)
DELETED_COUNT=0
FAILED_COUNT=0
FAILED_BRANCHES=""

echo -e "${YELLOW}Deleting branches...${NC}"
echo "$FILTERED_BRANCHES" | tr ' ' '\n' | grep -v '^$' | while read branch; do
    if git branch -d "$branch" 2>&1; then
        echo -e "  ${GREEN}✓${NC} Deleted: $branch"
        DELETED_COUNT=$((DELETED_COUNT + 1))
    else
        echo -e "  ${RED}✗${NC} Failed: $branch (not fully merged)"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        FAILED_BRANCHES="$FAILED_BRANCHES $branch"
    fi
done

echo ""
echo -e "${GREEN}✅ Cleanup complete!${NC}"

# Show summary at the end if there were failures
if [ -n "$FAILED_BRANCHES" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Some branches could not be deleted (not fully merged):${NC}"
    echo "$FAILED_BRANCHES" | tr ' ' '\n' | grep -v '^$' | while read branch; do
        echo "  - $branch"
    done
    echo ""
    echo -e "${BLUE}To force delete these branches, run:${NC}"
    echo "$FAILED_BRANCHES" | tr ' ' '\n' | grep -v '^$' | while read branch; do
        echo "  git branch -D $branch"
    done
fi
