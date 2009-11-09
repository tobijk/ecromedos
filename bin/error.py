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
import sys, libxml2


def parserErrorHandler(xmlparser, msg, severity, reserved):
	'''Custom error handler for libxml2 parser context.'''

	err = libxml2.lastError()
	sys.stderr.write("Error while parsing file %s on line %d\n" % (err.file(), err.line()))
	sys.stderr.write("Message: \"%s\".\n\n" % (msg.strip(),))

#end function


def validateErrorHandler(msg, validator):
	'''Custom error handler for libxml2 validation context.'''

	err = libxml2.lastError()
	sys.stderr.write("Validation error in file %s on line %d:\n" % (err.file(), err.line()))
	sys.stderr.write("Message: \"%s\".\n\n" % (msg.strip(),))

#end function


class ECMDSError(Exception):
	'''Generic base class.'''

	def __init__(self, value):
		self.value = value
	#end function

	def repr(self, arg):
		if isinstance(arg, str):
			return arg
		else:
			return repr(arg)
	#end function

	def __str__(self):
		return self.repr(self.value)
	#end function

	def msg(self):
		return self.__str__()
	#end function

#end class

class ECMDSPluginError(ECMDSError):

	def __init__(self, value, plugin_name):
		ECMDSError.__init__(self, value)
		self.plugin_name = plugin_name
	#end function

	def pluginName(self):
		return self.repr(self.plugin_name)
	#end function

#end class
