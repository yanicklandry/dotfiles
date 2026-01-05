#!/bin/bash
# Planet Crafter Whisky Setup Script

echo "=== Planet Crafter Whisky Setup ==="

# Check if Whisky is installed
if [ ! -d "/Applications/Whisky.app" ]; then
    echo "Error: Whisky not installed"
    echo "Download from: https://getwhisky.app/"
    echo "Or install via Homebrew: brew install --cask whisky"
    exit 1
fi

echo "✓ Whisky found"

# Check if Steam installer exists
STEAM_INSTALLER="$HOME/Downloads/SteamSetup.exe"
if [ ! -f "$STEAM_INSTALLER" ]; then
    echo "Downloading Steam installer..."
    curl -L "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe" -o "$STEAM_INSTALLER"
fi

echo "✓ Steam installer ready at $STEAM_INSTALLER"

echo ""
echo "=== MANUAL STEPS ==="
echo ""
echo "1. Open Whisky"
echo "2. Click 'Create Bottle'"
echo "3. Name it 'PlanetCrafter' (or whatever you want)"
echo "4. Wait for bottle creation"
echo ""
echo "5. Select the bottle → Settings (gear icon)"
echo "6. Under 'Graphics' → Enable DXVK"
echo ""
echo "7. Click 'Run' on the bottle"
echo "8. Navigate to: $STEAM_INSTALLER"
echo "9. Install Steam"
echo ""
echo "10. Launch Steam from Whisky"
echo "11. Log in to Steam"
echo "12. Install The Planet Crafter"
echo "13. Launch game from Steam"
echo ""
echo "=== IMPORTANT ==="
echo "Keep graphics on Medium for MacBook Air, High for MacBook Pro"
echo ""

read -p "Press Enter to open Whisky..."
open -a Whisky