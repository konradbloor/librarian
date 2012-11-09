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

* I learn some Ruby basics which help me widen my outlook and make me more fluent in using Puppet
* I save many hours of moving and renaming files into directories when scanning
* I rid my house of so much paper I can remove a bookcase so there's more space


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

To use librarian, there are three things you must do first

1. Install
2. Add a document type to librarian - for example 'bank statement', 'invoice from supplier X', etc
2. Train librarian for that new type of document
3. Tell librarian what to do for each new type of document (i.e. where to move it, what to extract from it, what to
rename it to).


Install
-------

1. Clone this repo
2. Install oasic's [Naive Bayes ruby gem](https://github.com/oasic/nbayes) (thanks Oasic!) using


    gem install nbayes







