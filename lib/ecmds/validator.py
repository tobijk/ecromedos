# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Date:    2009/11/15
#

# std includes
import libxml2, sys, os

# ecmds includes
from ecmds.error import ECMDSError, validateErrorHandler

class ECMDSValidator:

	def __init__(self):
		pass
	#end function


	def setupCatalog(self):
		'''Add temporary entries to shared catalog.'''

		try:
			style_dir = self.config['style_dir']
		except KeyError:
			msg = "Please specify the location of the stylesheets."
			raise ECMDSError(msg)
		#end try

		for name in ["book", "article", "report", "ecromedos"]:
			system_id  = "http://www.ecromedos.net/dtd/2.0/" + name + ".dtd"
			system_uri = os.sep.join([style_dir, "DTD", "ecromedos.dtd"])
			libxml2.catalogAdd("system", system_id, system_uri)
		#end for

	#end function


	def isValidDocument(self, document):
		'''Validate the given document.'''

		system_id = "http://www.ecromedos.net/dtd/2.0/ecromedos.dtd"

		dtd = libxml2.parseDTD("", system_id)
		if not dtd:
			msg = "Failed to load the DTD."
			raise ECMDSError(msg)
		#end if
		
		validator = libxml2.newValidCtxt()
		validator.setValidityErrorHandler(validateErrorHandler, validateErrorHandler, validator)
		retval = validator.validateDtd(document, dtd)
	
		return retval
	#end function

#end class

