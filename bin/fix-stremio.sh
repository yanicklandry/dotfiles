#!/usr/bin/env bash
brew update
brew uninstall stremio

# Clear cached web app data
rm -rf ~/Library/Application\ Support/Stremio/
rm -rf ~/Library/Caches/Stremio/
rm -rf ~/Library/Application\ Support/stremio-server/

brew install stremio

sudo xattr -cr /Applications/Stremio.app
find /Applications/Stremio.app -name "._*" -delete
find /Applications/Stremio.app -name ".DS_Store" -delete
sudo codesign --force --deep --sign - /Applications/Stremio.app

open /Applications/Stremio.app/Contents/MacOS/Stremio --webui-url="https://app.strem.io/shell-v4.4/#?loginFlow=desktop"
