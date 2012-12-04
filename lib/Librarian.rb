require 'optparse'
require 'fileutils'

require 'Type.rb'
require 'TypeRepository.rb'
require 'Classifier.rb'
require 'SpotlightImportingWordExtractor.rb'
require 'RegexField.rb'

# Facade for the functionality of Librarian
class Librarian

  def initialize()
    @typeRepository = TypeRepository.new
  end

  def newtype(documentType)
    type = @typeRepository.get(documentType)
    if type.nil?
      puts "Add new document type #{documentType}"
      type = Type.new(documentType)
      type.setDestination(".")
      type.addField("examplefield",RegexField.new("\\s(\\d{8})\\s"))
      typeRepository = @typeRepository
      typeRepository.add(type)
      puts "Don't forget to modify the regular expressions in the data file"
    else
      puts "You already have a type called #{documentType}"
    end
    listtypes()
  end

  def listtypes()
    typeRepository = @typeRepository 
    format = "\t%#{typeRepository.maximumNameLength}s  %-#{typeRepository.maximumDestinationLength}s"

    puts ""
    puts format % [ "Type", "Destination"]
    puts format % [ "-"*typeRepository.maximumNameLength, "-"*typeRepository.maximumDestinationLength]
    typeRepository.types.each do | type |
      puts format % [ type.name, type.destination]
    end
    puts ""
  end


  def interactiveGetType(prompt) 
    typeRepository = @typeRepository 
    types = typeRepository.types
    format = "%5s %s"
    choice = 1
    types.each do | type |
      puts format % [ choice.to_s, type.name ]
      choice += 1
    end
    puts format % [ "xyz", "Create new type - just type the name" ]
    chosenIndex = "-1"
    
    while chosenIndex.empty? || !is_numeric?(chosenIndex) || chosenIndex.to_i < 0 || chosenIndex.to_i > types.size
      print prompt
      chosenIndex = STDIN.gets.chop

      if !chosenIndex.empty? && !is_numeric?(chosenIndex)
        typeRepository.add(Type.new(chosenIndex))
        chosenIndex = choice.to_s
      end
    end

    types[chosenIndex.to_i-1]
  end

  def is_numeric?(i)
    i.to_i.to_s == i || i.to_f.to_s == i
  end


  def trainSingleDocument(documentType, filename)
    type = @typeRepository.get(documentType)
    if type.nil? 
      puts "I don't know what type #{documentType} is."
    else
      typeClassifier = Classifier.new("type");
      typeClassifier.train(documentType, filename);
      puts "Librarian has trained #{filename} as a #{documentType}"
      puts ""
    end 
  end


  def interactiveTrain(filename)
    if(File.directory?(filename)) 
      files = Dir.glob("*.pdf")
      files.each { |f| interactiveTrainFile(f) }
    end
    if File.fnmatch("*.pdf",filename)
      interactiveTrainFile(filename)
    end
  end

  def interactiveTrainFile(filename)
    type = interactiveGetType("#{filename} - which type is it? : ")
    trainSingleDocument(type.name, filename)   
  end


  def process(filename, action)
    typeRepository = @typeRepository
    format = "\t%#{typeRepository.maximumNameLength}s  %1s  %s --> %s"

    if(File.directory?(filename)) 
      files = Dir.glob("*.pdf")
      files.each { |f| process(f, action) }
    end

    if File.fnmatch("*.pdf",filename)
      processFile(filename, action, format)
    end
  end


  def processFile(filename, action, format)
      typeClassifier = Classifier.new("type");
      category = typeClassifier.classify(filename);
      type = @typeRepository.get(category)

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

  def words(filename)
    extractedwords = SpotlightImportingWordExtractor.new(filename).extractedWords
    puts "#{extractedwords}"
  end

end



