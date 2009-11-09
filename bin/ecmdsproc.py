# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the eCromedos document preparation system
# Date:    2006/03/09
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Update:  2006/12/30
#

# std includes
import os, sys, libxml2, urllib

#ecmds includes
from error import ECMDSError, parserErrorHandler, ECMDSPluginError

from configreader import ECMDSCfgManager
from validator    import ECMDSValidator
from preprocessor import ECMDSPreproc
from xslprocessor import ECMDSXslProc


class ECMDSProc(ECMDSCfgManager, ECMDSPreproc, ECMDSXslProc, ECMDSValidator):

	def __init__(self):
		ECMDSCfgManager.__init__(self)
		ECMDSPreproc.__init__(self)
		ECMDSXslProc.__init__(self)
		ECMDSValidator.__init__(self)
	#end function


	def loadXMLDocument(self, filename):
		'''Try to load XML document from @filename.'''

		fd = None
		try:
			fd = os.open(filename, os.O_RDONLY)
		except Exception, e:
			msg = "Could not open file '%s'" % (filename,)
			raise ECMDSError(msg)
		#end try
	
		# create parser context
		xmlparser = libxml2.newParserCtxt()
		xmlparser.setErrorHandler(parserErrorHandler, xmlparser)
		parse_opts = (
			libxml2.XML_PARSE_NOENT |    # replace entities
			libxml2.XML_PARSE_NOCDATA |  # convert CDATA to text()
			libxml2.XML_PARSE_DTDLOAD    # load DTD if specified
			)

		# parse file
		doc = None
		try:
			url = filename
			# windows compatibility hack
			if os.sep == '\\': url = filename.replace('\\', '/')
			doc = xmlparser.ctxtReadFd(fd, url, None, parse_opts)
		except libxml2.libxmlError:
			msg = "There were errors while parsing file %s" % (filename,)
			raise ECMDSError(msg)
		#end try

		# close file
		try:
			os.close(fd)
		except: pass

		# return document tree
		return doc
	#end function


	def __message(self, msg):
		sys.stdout.write(" * " + msg)
		sys.stdout.write(" " * (50 - len(msg)))
		sys.stdout.flush()
	#end function
	
	def __status(self, status):
		sys.stdout.write(status + "\n")
	#end function


	def process(self, filename, options):
		
		# read configuration
		self.__message("Reading configuration...")
		self.readConfig(options)
		self.__status("DONE")
		
		# setup xml-catalog
		self.__message("Setting up catalog...")
		self.setupCatalog()
		self.__status("DONE")
		
		# load preprocessor plugins
		self.__message("Loading plugins...")
		self.loadPlugins()
		self.__status("DONE")
		
		# load document
		self.__message("Reading document...")
		document = self.loadXMLDocument(filename)
		self.__status("DONE")
		
		# load stylesheet
		self.__message("Loading stylesheets...")
		stylesheet = self.loadStylesheet()
		self.__status("DONE")
		
		# validate document
		self.__message("Validating document...")
		if self.config['do_validate'] == "yes":
			if not self.isValidDocument(document):
				msg = "Document is not valid."
				raise ECMDSError(msg)
			else:
				self.__status("VALID")
			#end if
		else:
			self.__status("SKIPPED")
		#end if

		# prepare document
		self.__message("Running preprocessor on document tree...")
		self.prepareDocument(document)
		self.__status("DONE")
		
		# apply stylesheet
		self.__message("Transforming document...")
		self.applyStylesheet(document, stylesheet)
		self.__status("DONE")
		
		# clean up
		self.__message("Releasing memory...")
		document.freeDoc()
		stylesheet.freeStylesheet()
		self.__status("DONE")
		
		return True
	#end function

#end class

