#!/bin/bash
# Fix Steam webhelper crash in Whisky

WHISKY_BOTTLES="$HOME/Library/Containers/com.isaacmarovitz.Whisky/Bottles"

echo "Available bottles:"
ls -1 "$WHISKY_BOTTLES"
echo ""

read -p "Enter your bottle name: " BOTTLE_NAME

STEAM_PATH="$WHISKY_BOTTLES/$BOTTLE_NAME/drive_c/Program Files (x86)/Steam"

if [ ! -d "$STEAM_PATH" ]; then
    echo "Error: Steam not found"
    exit 1
fi

cd "$STEAM_PATH"

echo "Deleting Steam web cache..."
rm -rf appcache
rm -rf config/htmlcache
rm -rf steam/cached

echo "✓ Cache cleared"
echo ""
echo "Now try: 'Restart Steam with GPU Acceleration disabled'"