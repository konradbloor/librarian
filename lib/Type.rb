class Type

  def initialize(classifierName)
    @name = classifierName
    @fields = Hash.new
    @destination = "."
    @filename = "%%filename%%%%fileext%%"
  end

  def name
    @name
  end

  def addField(name, regex)
    @fields[name] = regex
  end

  def setDestination(destination)
    @destination = destination
  end

  def destination
    @destination
  end

  def getFields(category, filename,filecontents)
    fieldcontents = Hash.new
    fieldcontents["category"] = category
    fieldcontents["filename"] = filename.slice(0,filename.rindex(File.extname(filename)))
    fieldcontents["fileext"] = File.extname(filename)

    @fields.each do | fieldname,  regex |
      regexToEvaluate = Regexp.new(regex)
      regexToEvaluate.match(filecontents) { |m|
        fieldcontents[fieldname] = m[1]
      }
    end
    fieldcontents
  end

  def hasExtractedAllFields(extractedfields)
    return (@fields.length+3 == extractedfields.length)
  end

  def getNewFilename(extractedfields)
    newfilename = String.new(@filename)

    # replace all extracted fields
    extractedfields.each do | fieldname, contents |
      newfilename = newfilename.gsub("\%\%"+fieldname+"\%\%",contents);
    end 

    # replace any existing fields 
    @fields.each do | fieldname, contents |
      newfilename = newfilename.gsub("\%\%"+fieldname+"\%\%",fieldname);
    end 

    newfilename   
  end

end