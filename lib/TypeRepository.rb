require 'yaml'

class TypeRepository

  def initialize()
    @filename = "documenttypes.librarian"
    @types = []
    @file = File.join(".", @filename)
    if !File.exists?(@file)
      dump(@file)
    end
    @types = from(@file)
  end

  def add(newtype)
    @types.push(newtype)
    puts "Types now has #{@types.length} elements"
    dump(@file)
  end

  def get(typename)
    @types.find { |t| t.name == typename }
  end

  def from(yml_file)
    @types = YAML.load_file(yml_file)
  end

  def load(yml)
    if yml.nil?
      return []
    elsif yml[0..2] == "---"
      @types = YAML.load(yml)
    else
      @types = YAML.load_file(yml_file)
    end
  end

  def dump(arg)
    if arg.instance_of? String
      File.open(arg, "w") {|f| YAML.dump(@types, f) }
    else
      YAML.dump(arg)
    end
  end


end