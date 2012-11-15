class SpotlightImportingWordExtractor

  def initialize(filename)
    @filename = filename
  end

  def extractedWords
    commandOutput = `mdimport -d 2 #{@filename} 2>&1 | grep "kMDItemTextContent"`
    extractFrom = commandOutput.index("\"")+1
    extractTo = commandOutput.rindex("\"")
    length = extractTo-extractFrom
    fieldContents = commandOutput.slice(extractFrom, length)
  end

end