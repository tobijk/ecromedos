# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

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
		'''Strip leading and trailing white-space from node content.'''

		default_nodes = [
			"p",
			"subject",
			"title",
			"author",
			"date",
			"publisher",
			"dedication",
			"caption",
			"dt",
			"equation",
			"td",
			"li"]

		hard_nodes = [
			"counter",
			"ref",
			"idref",
			"cite",
			"entity"
		]

		phantom_nodes = [
			"idxterm",
			"defterm"
		]

		if node.name in default_nodes:
			do_strip = True
		else:
			do_strip = False
			prop = node.properties
			while prop:
				if prop.name == "strip":
					if prop.content.lower() == "yes": do_strip = True
					break
				#end if
				prop = prop.next
			#end while
		#end if

		if not do_strip: return node

		# lstrip
		child = node.children
		while child:
			if child.name in phantom_nodes:
				child = child.next
				continue
			elif child.name in hard_nodes:
				break
			elif child.type == "text":
				string = child.getContent()
				stripped = string.lstrip()
				if not stripped:
					child.setContent("")
				elif len(stripped) < len(string):
					child.setContent(stripped)
					break
				else:
					break
				#end if
			#end if
			if child.children:
				child = child.children
			else:
				child = child.next
			#end if
		#end for

		# rstrip
		child = node.last
		while child:
			if child.name in phantom_nodes:
				child = child.prev
				continue
			elif child.name in hard_nodes:
				break
			elif child.type == "text":
				string = child.getContent()
				stripped = string.rstrip()
				if not stripped:
					child.setContent("")
				elif len(stripped) < len(string):
					child.setContent(stripped)
					break
				else:
					break
				#end if
			#end if
			if child.children:
				child = child.last
			else:
				child = child.prev
			#end if
		#end while

		return node
	#end function

#end class
