# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Date:    2009/11/15
#

# std includes
import os, libxml2, libxslt

# ecmds includes
from error import ECMDSError


class ECMDSXslProc:

	def __init__(self):
		pass
	#end function


	def applyStylesheet(self, document, stylesheet):
		'''Apply stylesheet to document.'''

		try:
			result = stylesheet.applyStylesheet(document, None)
		except libxml2.libxmlError, e:
			msg = "Error while transforming document:\n %s." % (str(e),)
			raise ECMDSError(msg)
		#end try

		return result
	#end function


	def loadStylesheet(self):
		'''Load matching stylesheet for desired output format.'''

		target_format = self.config['target_format']

		try:
			style_dir = self.config['style_dir']
		except KeyError:
			msg = "Please specify the location of the stylesheets."
			raise ECMDSError(msg)
		#end try
		
		name = os.path.join(style_dir, target_format, "ecmds.xsl")
		try:
			styledoc = self.loadXMLDocument(name)
		except ECMDSError, e:
			msg = "Could not load stylesheet:\n %s" % (e.msg(),)
			raise ECMDSError(msg)
		#end try

		stylesheet = libxslt.parseStylesheetDoc(styledoc)
		if not stylesheet:
			msg = "Could not compile stylesheet."
			raise ECMDSError(msg)
		#end if

		return stylesheet
	#end function

#end class
