require 'optparse'
require 'fileutils'

require 'Type.rb'
require 'TypeRepository.rb'
require 'Classifier.rb'
require 'SpotlightImportingWordExtractor.rb'
require 'RegexField.rb'

# Facade for the functionality of Librarian
class Librarian

  def newtype(documentType)
    type = TypeRepository.new.get(documentType)
    if type.nil?
      puts "Add new document type #{documentType}"
      type = Type.new(documentType)
      type.setDestination(".")
      type.addField("examplefield",RegexField.new("\\s(\\d{8})\\s"))
      typeRepository = TypeRepository.new
      typeRepository.add(type)
      puts "Don't forget to modify the regular expressions in the data file"
    else
      puts "You already have a type called #{documentType}"
    end
    listtypes()
  end

  def listtypes()
    typeRepository = TypeRepository.new 
    format = "\t%#{typeRepository.maximumNameLength}s  %-#{typeRepository.maximumDestinationLength}s"

    puts ""
    puts format % [ "Type", "Destination"]
    puts format % [ "-"*typeRepository.maximumNameLength, "-"*typeRepository.maximumDestinationLength]
    typeRepository.types.each do | type |
      puts format % [ type.name, type.destination]
    end
    puts ""
  end

  def train(documentType, filename)
    type = TypeRepository.new.get(documentType)
    if type.nil? 
      puts "I don't know what type #{documentType} is."
    else
      typeClassifier = Classifier.new("type");
      typeClassifier.train(documentType, filename);
    end 
  end

  def process(filename, action)

    typeRepository = TypeRepository.new
    format = "\t%#{typeRepository.maximumNameLength}s  %1s  %s --> %s"

    if(File.directory?(filename)) 
      files = Dir.glob("*.pdf")
      files.each { |f| process(f, action) }
    end

    if File.fnmatch("*.pdf",filename)

      typeClassifier = Classifier.new("type");
      category = typeClassifier.classify(filename);

      type = typeRepository.get(category)

      extractedwords = SpotlightImportingWordExtractor.new(filename).extractedWords
      fields = type.getFields(category, filename, extractedwords)
      newfilename = type.getNewFilename(fields)
      complete = type.hasExtractedAllFields(fields)

      puts format % [ fields["category"], complete ? "" : "X", filename, newfilename]

      if(complete)
        FileUtils.mkdir_p(type.destination);
        if action == :move 
          FileUtils.move(filename, type.destination+"/"+newfilename)
        end
        if action == :copy
          FileUtils.cp(filename, type.destination+"/"+newfilename)
        end      
      end

    end
  end

  def words(filename)
    extractedwords = SpotlightImportingWordExtractor.new(filename).extractedWords
    puts "#{extractedwords}"
  end

end



