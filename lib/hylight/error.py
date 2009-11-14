# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2006/03/09
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

class HLError(Exception):
	'''Generic base class.'''

	def __init__(self, value):
		self.value = value
	#end function

	def __str__(self):
		if isinstance(self.value, str):
			return self.value
		else:
			return repr(self.value)
	#end function

	def msg(self):
		return self.__str__()
	#end function

#end class
