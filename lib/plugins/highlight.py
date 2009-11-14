# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2006/03/09
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# std includes
import libxml2

# ecmds includes
from error import ECMDSPluginError

# hylight
from hylight.ecmdsgenerator import ECMDSGenerator
from hylight.error import HLError


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin(ECMDSGenerator):

	def __init__(self, config):
		ECMDSGenerator.__init__(self)
	#end function


	def flush(self):
		pass
	#end function


	def process(self, node, format):
		'''Prepare @node for target @format.'''

		#get properties
		options = {}
		prop = node.properties
		while prop:
			options[prop.name] = prop.content
			prop = prop.next
		#end while

		# does user want highlighting?
		try:
			if not options['syntax']: return node
		except KeyError: return node

		# fetch content and highlight
		string = node.getContent()
		result = self.highlight(string, options)

		# parse result
		doc = libxml2.parseDoc(result)
		root = doc.getRootElement()
		root.unlinkNode()
	
		# replace original node
		prop = node.properties
		while prop:
			next = prop.next
			prop.unlinkNode()
			if not root.hasProp(prop.name):
				root.addChild(prop)
			else:
				if prop.name == "bgcolor":
					root.setProp("bgcolor", prop.content)
				#end if
				prop.freeNode()
			#end if
			prop = next
		#end for
		node.replaceNode(root)
		node.freeNode()
		doc.freeDoc()

		return root
	#end function


	def highlight(self, string, options):
		'''Call syntax highlighter.'''

		try:
			try:
				startline = int(options["startline"])
				self.lineNumbers(True)
			except ValueError:
				msg = "Invalid start line '%s'." % (options["startline"],)
				raise ECMDSPluginError(msg, "highlight")
			except KeyError:
				self.lineNumbers(False)
				startline = 1
			#end try
			try:
				stepping = int(options["linestep"])
				self.lineStepping(stepping)
			except ValueError:
				msg = "Invalid line stepping '%s'." % (options["linestep"],)
				raise ECMDSPluginError(msg, "highlight")
			except KeyError:
				self.lineStepping(1)
			#end try
			try:
				result = self.highlightString(string,
					options['syntax'], startline, options['colorscheme'], True)
			except KeyError:
				result = self.highlightString(string,
					options['syntax'], startline, "print", True)
			#end try
		except HLError, e:
			raise ECMDSPluginError(str(e), "highlight")
		#end try

		return result
	#end function

#end class
