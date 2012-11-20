class Type

  def initialize(classifierName)
    @name = classifierName
    @fields = Hash.new
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

end