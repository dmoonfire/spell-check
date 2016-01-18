SpellChecker = require 'spellchecker'

module.exports = ({id, text}) ->
  SpellChecker.add("GitHub")
  SpellChecker.add("github")

  misspelledCharacterRanges = SpellChecker.checkSpelling(text)
  console.log("initializing spellchecker")

  row = 0
  rangeIndex = 0
  characterIndex = 0
  misspellings = []
  while characterIndex < text.length and rangeIndex < misspelledCharacterRanges.length
    lineBreakIndex = text.indexOf('\n', characterIndex)
    if lineBreakIndex is -1
      lineBreakIndex = Infinity

    loop
      range = misspelledCharacterRanges[rangeIndex]
      if range and range.start < lineBreakIndex
        misspellings.push([
          [row, range.start - characterIndex],
          [row, range.end - characterIndex]
        ])
        rangeIndex++
      else
        break

    characterIndex = lineBreakIndex + 1
    row++

  {id, misspellings}
