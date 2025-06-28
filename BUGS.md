# Known Bugs & Issues

## Critical
- **[BUG-001]** Stats file occasionally gets corrupted when multiple gitpush instances run simultaneously
  - Workaround: `rm ~/.gitpush/stats.json` and let it regenerate
  - Need proper file locking mechanism

## High Priority  
- **[BUG-002]** AI commit generation fails silently when API key is invalid
  - Should show clear error message instead of falling back
  
- **[BUG-003]** Branch names with spaces break the workflow
  - Regex doesn't escape properly
  - Affects ~5% of users who use GUI tools

## Medium Priority
- **[BUG-004]** Progress bar rendering breaks in non-UTF8 terminals
  - Fallback to ASCII characters needed
  
- **[BUG-005]** Team stats shows mock data (not implemented yet)
  - Placeholder since v0.7.0
  - Waiting for backend API

- **[BUG-006]** Date calculations fail on macOS due to different `date` command syntax
  - Partially fixed but edge cases remain

## Low Priority
- **[BUG-007]** Help text overflows on narrow terminals (<80 chars)
  - Need responsive formatting
  
- **[BUG-008]** Emoji plugin causes issues with some fonts
  - Document supported terminals

- **[BUG-009]** GUI requires global electron install
  - Should bundle electron or use npx

## Won't Fix
- **[BUG-010]** Doesn't work with Git < 2.0
  - Modern Git features required
  - Document minimum version

## Reported by Users
- "Sometimes commits twice" - investigating, can't reproduce
- "AI suggestions are too verbose" - prompt engineering needed
- "Conflicts with oh-my-zsh git plugin" - alias collision

---
Last updated: When I remember to check GitHub issues