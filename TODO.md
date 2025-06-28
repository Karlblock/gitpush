# TODO

## High Priority
- [ ] Fix that weird bug when branch name has spaces
- [ ] Add proper error handling in AI module (currently just crashes)
- [ ] Tests are breaking on macOS - need to investigate

## Features
- [ ] Add support for custom git hooks
- [ ] Integrate with GitLab (not just GitHub)
- [ ] Maybe add a config file instead of env vars everywhere?
- [ ] Voice commands (lol probably never)

## Refactoring
- [ ] The main script is getting huge, need to split it
- [ ] Remove duplicate code between ai_manager and conflict_resolver
- [ ] Plugin system needs better docs

## Bugs
- [ ] Sometimes the stats file gets corrupted
- [ ] GUI doesn't work without npm install (obvious but annoying)
- [ ] Emoji plugin breaks with non-UTF8 terminals

## Random ideas
- blockchain commits? (Karl's idea, not mine)
- integrate with spotify to play music while committing
- ML model to predict merge conflicts before they happen
- gitpush as a service?

---
Last updated: whenever I remember to update this file