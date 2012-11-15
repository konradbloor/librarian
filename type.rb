class Type

  def initialize(name)
    @name = name
    @fields = Hash.new
  end

  def name
    @name
  end

  def addField(name, regex)
    @fields[name] = regex;
  end

end