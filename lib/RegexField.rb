class RegexField

  def initialize(regex)
    @regex = regex
    @format = "%s"
  end

  def regex
    Regexp.new(@regex)
  end

  def formatValue(value)
    @format % value
  end

end