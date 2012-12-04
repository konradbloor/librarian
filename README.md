Librarian
=========

Introduction
------------

Librarian is a simple tool that sorts PDF documents into folders and renames them based on their contents.

I created it because I wanted to learn Ruby (because I wanted to become more effective in using Puppet), and I had
a bookcase *full* of files of paper, and I wanted to scan it all into a Fujitsu Scansnap.  But I didn't want to spend
hours manually moving and renaming files.

The problem is, the Scansnap software can dump all the scans in a folder, or it can ask me what to name the file.
It doesn't just let me feed in each document and automatically know what the file is, or name the file based on the
dates/page numbers/account numbers in it.  Because it doesn't do this, if I wish to retrieve any of these files in the
future using only the Scansnap software, I will have to manually move the files into directories, and rename them so
I know what they are.

So the creation of this gives me three main benefits:

* I learn some Ruby basics which help me widen my outlook and make me more fluent in using Puppet.  Interesting to use Ruby.  Feels like a better more logically laid out Perl, nice and terse.  More freedom than Java and thus more responsibility.  I can see why it has taken off.
* I save many hours of moving and renaming files into directories when scanning.
* I rid my house of so much paper I can remove a bookcase so there's more space.


Features
--------


* __Works with PDF documents__ (the caveat being you have to be running under OSX with spotlight switched on for these
  documents)


* __Naive Bayes Classification__ of documents.  This means that you train the system with a number of each type of
  document, and as a result, it is able to work out what a new document is likely to be.  Say for example you scan
  bank statements, and phone bills.  If you scan in some of each, and tell librarian 'this set of files are bank
  statements' and 'this set of files are phone bills' librarian builds a model that it can apply to subsequent
  documents, it can then know where you want to put the file, and how you want
  to name it.


* __Extracts meaningful information__ from documents.  Librarian can be configured to extract dates, account numbers,
  page numbers, and other information.  It does this using regular expressions unfortunately, and not some kind of
  clever technology that overcomes the failure of OCR, so sometimes this doesn't work as well as it could.


* __Renames the documents__ based on the information you extract.  Mobile phone bill?  Good to have it named:


    [phonenumber]-[date].pdf


* __Files the documents into directories__.  Bank statements can go in their folder.  Phone bills can go in another.
  This is not a feature that will draw the gasp of alumni of MIT, Caltech, Stanford, Oxford, Cambridge etc but it is
  damn useful when scanning.

Usage
-----

Here's an example way to use librarian.

1. Install
2. Scan a bunch of PDF files with Scansnap
3. Train librarian.  You can do this by running 

    librarian train -f [dirname] 

  where [dirname] is where you have all your scanned PDF's.  It will then ask you what each type of document is from a list.  If you have a new type of document that librarian hasn't encountered (and to start with it has encountered no documents) you can name it here, and it will be added to the list.  

4. Edit the configuration file.  This is where you can set, for each type of document, where you want it go, and how it should be named.
5. Try a test run where it copies all the files it can

    librarian copy -f [dirname]

  This will also output a summary showing 'x' marks where it couldn't get complete data and so didn't copy the files.


Configuration file
------------------

Librarian builds a file called 'documenttypes.librarian' in which it stores the following information on each type:

- name
- destination directory (i.e. where to copy or move the files to)
- how the filename is constructed from fields (you get two free fields from the filename - for example 'test.pdf' gives you the field values 'test' in field 'filename', and '.pdf' in 'fileext'.)  Each field needs to have %% before and after it to be recognised properly.
- the fields
  - name
  - regular expression to extract them from the file contents
  - format string for when it is placed in the filename (say for date formatting or 0-padding)

When you first create types though, none of the information on the directory, filename, or the fields is useful.  Because this is just a personal tool, I thought I'd prefer to just edit the file rather than build a UI or set of command line tools to modify the file.

An example entry for a document type could be the following, and the whole file is simply differing versions of the below, repeated:

    - !ruby/object:Type
      name: Bank statement page
      fields:
        account: !ruby/object:RegexField
          regex: \s(\d{8})\s
          format: ! '%s'
        page: !ruby/object:RegexField
          regex: \s\(\D*(\d+)\D*\)\s*\w
          format: ! '%04d'
      destination: statementdir
      filename: ! '%%account%%-%%page%%%%fileext%%'

This example shows the following:

- Name is 'Bank statement page'
- Destination is the directory 'statementdir'
- There are two fields, 'account' which is found by looking in the OCR'd text for eight digits with space around them, and page, which is found by looking for at least one digit, possibly surrounded by things that aren't digits, starting with some whitespace and ending with possibly some whitespace before a word character.  The page is 0 padded and 4 digits long.
- The filename should take the fields so that if the original file was called test.pdf, and librarian found account was 12345678 and the page was 5, the filename would 12345678-0005.pdf

Install
-------

1. Clone this repo
2. Ensure you've got Ruby 1.9 as the ability to set/get default_proc is in Ruby 1.9 and that's required by the gem you are just about to install.  I used RBENV to do this.
3. Install oasic's [Naive Bayes ruby gem](https://github.com/oasic/nbayes) (thanks Oasic!) using


    gem install nbayes


Caveats
-------

I've written this from the perspective of someone that has been slinging Java (since 1998...), so no doubt this code will
exhibit some smell of Java and not be quite idiomatic Ruby.  I will have missed tricks as it is the first Ruby code
I've written outside of puppet configuration.

