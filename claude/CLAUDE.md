- /compact

## Git Guidelines

- **NEVER run `git commit` or `git push` unless explicitly asked by the user**
  - Wait for explicit user request before committing or pushing
  - `git fetch` and `git pull` are allowed when needed
  - Always ask first if unsure about git operations

## Expo/EAS CLI Notes

- **When using `--json` with `eas update`, you MUST also use `--non-interactive`**
  - EAS CLI requires: `eas update --json --non-interactive`
  - Also set `CI=1` environment variable to satisfy expo-cli (used internally)
  - You may see this warning (it's safe to ignore): `[expo-cli] --non-interactive is not supported, use $CI=1 instead`
  - The warning is from expo-cli (internal bundler) but doesn't break anything