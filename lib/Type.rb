class Type

  def initialize(classifierName)
    @name = classifierName
    @fields = Hash.new
    @destination = "."
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

end