require 'rubygems'
require 'nbayes'

require 'SpotlightImportingWordExtractor.rb'

class Classifier

  def initialize(name)
    @name = name
    @bayesfilename = @name+"-classifier.librarian"
  end

  def train(documentType, file)
    words = SpotlightImportingWordExtractor.new(file).extractedWords

    nbayes = NBayes::Base.new
    if File.exists?(bayesfilename)
      nbayes = NBayes::Base.from(bayesfilename)
    end
    nbayes.train(words.split(' '),documentType)
    nbayes.dump(bayesfilename)
  end

  def classify(file)
    nbayes = NBayes::Base.new
    if File.exists?(@bayesfilename)
      nbayes = NBayes::Base.from(@bayesfilename)
    end
    words = SpotlightImportingWordExtractor.new(file).extractedWords
    result = nbayes.classify(words.split(' '))
    result.max_class
  end

end