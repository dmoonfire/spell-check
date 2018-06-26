# Checker Plugins

The `spell-check` package allows for additional dictionaries to be used at the same time using Atom's `providedServices` element in the `package.json` file.

    "providedServices": {
      "spell-check": {
        "versions": {
          "1.0.0": "pathToModuleThatReturnsACheckObject"
        }
      }
    }

The `pathToModuleThatReturnsACheckObject` function may return either a single `require`able path or an array of them. This must be an absolute path to a class that provides a checker instance (below).

    provideSpellCheck: ->
      require.resolve './project-checker.coffee'

The path given must either resolve to a singleton instance of a class or a default export in a ES6 module. *The reason this is required is because the checker will be instantiated in a background process which can't reuse the existing Atom process nor has a correct path for the default `require` operation.*

    class ProjectChecker
      # Magical code
    checker = new ProjectChecker()
    module.exports = checker

For a default using Typescript:

    export default class ProjectChecker {}

The signature of the checker (`ISpellCheckChecker`) is below. See the `spell-check-project` for an example implementation.

## ISpellCheckBufferRange

A range in the buffer for a correct or incorrect word. This is an array of two numbers, the first being a zero-based start character in the given `text` string for `check()`. The second is a zero-based stop index in the same text buffer.

**Kind:** An array of exactly two numbers.

## ISpellCheckCheckerResults

**Kind:** Interface

Property                 | Type                                   | Default     | Description
------------------------ | -------------------------------------- | ----------- | -----------
invertIncorrectAsCorrect | `boolean \| undefined`                  | `false`     | If true, assume everything no in the `incorrect` range is correct.
incorrect                | `ISpellCheckBufferRange[] \| undefined` | `undefined`
correct                  | `ISpellCheckBufferRange[] \| undefined` | `undefined`

A correct word range is always considered correct even if other checkers indicate it is incorrect.

A word or character that is neither correct nor incorrect is considered correct.

## ISpellCheckAddTarget

The interface for a potential target for adding unknown words.

**Kind:** Interface

Name                     | Type      | Default | Description
------------------------ | --------- | ------- | -----------
label                    | `string`  | None    | The name of the menu item to add to the target.

## ISpellCheckChecker

The interface for a checker plugin for `spell-check`.

**Kind:** Interface

### getId() ⇒ string

Returns a canoncial identifier to to identify this checker. Typically, this will be the package name with an optional suffix for options, such as `spell-check-project` or `spell-check:en-US`. The intent is that this identifier will be used to control functionality and reporting.

### getPriority() ⇒ number

Determines how significant the plugin is for information with lower numbers being more important. Typically, user-entered data (such as the config `knownWords` configuration or a project's dictionary) will be lower than system data (priority 100).

### isEnabled() ⇒ boolean

If this returns true, then the plugin will considered for processing.

### providesSpelling(context) ⇒ boolean

Determines if this checker can provide correctness checking of the buffer. If this is true, then the `check` method will be used to check a buffer for misspellings.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.

The output of this is not cached which means the spelling status can change over time.

### providesSuggestions(context) ⇒ boolean

Determines if this checker can provide suggestions for incorrect words. If true, then the `suggest` method will be used to request suggestions.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.

The output of this is not cached which means the spelling status can change over time.

### providesAdding(context) ⇒ boolean

Determines if this checker can add unknown words to a dictionary. If this is true, then the list of addition targets will be called using `getAddingTargets` and words are added via `add`.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.

The output of this is not cached which means the spelling status can change over time.

### check(context, text) ⇒ ISpellCheckCheckerResults

Takes the entire text of a buffer and reports correct (whitelist) or incorrect (blacklist) spellings and their location.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.
text      | `string`             | The context of the text buffer.

### suggest(context, word) ⇒ string[]

Takes the entire text of a buffer and reports correct (whitelist) or incorrect (blacklist) spellings and their location. The output is an ordered list of strings with the closest being first.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.
word      | `string`             | A single word that is misspelled.

### getAddingTargets(context) ⇒ ISpellCheckAddTarget[]

Gets a list of targets that the user can add an unknown word to. Multiples can be returned to allow for "Add Word" and "Add Word (Case-Insensitive)" or other checker-specific logic.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.

### add(context, target, word) ⇒ ISpellCheckAddTarget[]

Adds a given word to the dictionary with the provided target.

Parameter | Type                 | Description
--------- | -------------------- | -----------
context   | `ISpellCheckContext` | The information about the buffer being checked.
target    | `string`             | The target to add, this is a generated `ISpellCheckAddTarget.label` from `getAddingTargets`.
word      | `string`             | A single word to be added.
