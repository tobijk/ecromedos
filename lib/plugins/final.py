# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# std includes
import libxml2


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin:

	def __init__(self, config):
		pass
	#end function


	def flush(self):
		pass
	#end function


	def process(self, node, format):
		'''Prepare @node for target @format.'''

		node.setProp("final", "yes")
		return node
	#end function

#end class
