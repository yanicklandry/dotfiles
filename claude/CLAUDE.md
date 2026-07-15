- /compact

## Git Guidelines

- **NEVER run `git commit`, `git add`, or `git push` — not even inside implementation skills like /kiro-impl**
  - The user handles ALL staging, commits, pushes, and branch management
  - `git fetch`, `git pull`, `git log`, `git diff`, `git status` are allowed (read-only)
  - Inside /kiro-impl: implement one task at a time, then PAUSE and ask user to review and commit before continuing to the next task
  - "Explicitly asked" means the user typed "commit this" or "push this" — running /kiro-impl does NOT count as permission to commit

- **NEVER post comments, replies, or messages on GitHub, Slack, or any external platform unless explicitly asked**
  - Do not call `gh api .../comments`, `.../replies`, or any GitHub comment/review API
  - When user says "draft a reply" or "confirm this", they will post it themselves
  - Only act when user types explicit words like "post the reply" or "send this"

## Style Rules

- **NEVER use em dash (—) or right arrow (->)** in responses or in any written file
  - Replace — with : (colon)
  - Replace -> with =>

## Expo/EAS CLI Notes

- **When using `--json` with `eas update`, you MUST also use `--non-interactive`**
  - EAS CLI requires: `eas update --json --non-interactive`
  - Also set `CI=1` environment variable to satisfy expo-cli (used internally)
  - You may see this warning (it's safe to ignore): `[expo-cli] --non-interactive is not supported, use $CI=1 instead`
  - The warning is from expo-cli (internal bundler) but doesn't break anything
