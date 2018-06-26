# Status Plugins

The `spell-check` package allows for other packages to report the spell-checking status to the user. This can be a status indicator on the bottom of the page, feeding into `linter` or the IDE plugins, or any other methods that makes sense. The various plugins use the `providedServices` element in the `package.json` file.

    "providedServices": {
      "spell-check-status": {
        "versions": {
          "1.0.0": "functionNameThatReturnsISpellCheckStatus"
        }
      }
    }

Unlike the [checker](checker.md) plugins, the status plugins live completely in the main Atom process and don't need a path to the module to load. Instead, they return a `ISpellCheckerStatus` instance.

    provideSpellCheckStatus: ->
      @createStatus

    class StatusBarSpellCheckerStatus
      # Magical code
    checker = new StatusBarSpellCheckerStatus()
    module.exports = checker

For a default using Typescript:

    export default class StatusBarSpellCheckerStatus {}

The signature of the checker (`ISpellCheckStatus`) is below.

## ISpellCheckStatusDetail ⇐ ISpellCheckContext

The interface for a status update on the spell-check results. This includes all of the properties inside `ISpellCheckContext` plus additional ones.

**Kind:** Interface

Property     | Type     | Description
------------ | -------- | ------
projectPath  | `string` | "/absolute/path/to/project/root,
relativePath | `string` | "relative/path/from/project/root"

## ISpellCheckStatus

The interface for a checker plugin for `spell-check`.

**Kind:** Interface

### updateStatus(detail)

Parameter | Type                 | Description
--------- | -------------------- | -----------
detail    | `ISpellCheckDetail`  | The contextual and details for the spell-check results.
