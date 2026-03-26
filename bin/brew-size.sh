#!/usr/bin/env bash
ROWS=$(brew list --formula | xargs -n1 -P8 -I {} \
    sh -c "brew info {} | grep -E '[0-9]* files, ' | sed 's/^.*[0-9]* files, \(.*\)).*$/{} \1/'" | \
    sort -h -r -k2 -)

echo "$ROWS" | column -t
echo ""
echo "$(echo "$ROWS" | wc -l | tr -d ' ') formulae listed"
