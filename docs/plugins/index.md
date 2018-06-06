# Plugins

The `spell-check` package as a number of optional providers that allow additional functionality to tie into the core spell-checking engine. These providers allow for project-specific checking or increase the ways misspellings are reported to the user.

## Checker Plugins

A [checker plugin](checker.md) plugin is one that provides additional checking. This can be a combination of whitelisted words (for example the "known words" and `spell-check-project`) or blacklisting (such as the ones provided via `node-spellchecker`).

## Status Plugins

[Status](status.md) plugins are ones that report the current state of the checking, such as the presence of misspelled words or their counts, and displays them to the user. Other examples are interfaces into the status bar or `linter`.

## ISpellCheckContext

Common arguments passed into various functions of `ISpellCheckChecker`.

**Kind:** Interface

Property     | Type     | Description
------------ | -------- | ------
projectPath  | `string` | "/absolute/path/to/project/root,
relativePath | `string` | "relative/path/from/project/root"

The primary purpose of providing this is to allow for plugins to make project root decisions, such as having a word list in the root of the project root.

