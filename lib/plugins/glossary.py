# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the eCromedos document preparation system
# Update:  2008/10/24
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# std includes
import libxml2, sys, locale

# ecmds includes
from error import ECMDSPluginError


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin:

	def __init__(self, config):
		self.__glossary = [];
	#end function


	def __saveNode(self, node):
		"""Stores a reference to the given node."""

		term = node.prop("sortkey")

		child = node.children
		while child:
			if child.type == "element" and child.name == "dt":
				if not term:
					term = child.getContent().strip()
				break
			#end if
			child = child.next
		#end for

		self.__glossary.append([term, node])
		return node
	#end function


	def process(self, node, format):
		"""Saves a glossary entry or sorts and builds the glossary,
		depending on what type of node triggered the plugin."""

		if node.name == "defterm":
			node = self.__saveNode(node)
		elif node.name == "make-glossary":
			node = self.__makeGlossary(node)
		#end if
		return node
	#end function


	def __configuration(self, node):
		"""Read node attributes and build a dictionary holding
		configuration information for the collator"""

		# presets
		properties = {
			"locale": "C",
			"locale_encoding": None,
			"locale_variant": None,
			"alphabet": "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
		}

		# read element attributes
		prop = node.properties
		while prop:
			properties[prop.name] = prop.content
			prop = prop.next
		#end while

		# split locale into locale/encoding/variant
		if '@' in properties['locale']:
			properties['locale'], properties['locale_variant'] = \
				properties['locale'].split('@', 1)
		if '.' in properties['locale']:
			properties['locale'], properties['locale_encoding'] = \
				properties['locale'].split('.', 1)
		#end ifs

		# build list of alphabet characters
		alphabet = []
		for ch in [x.strip() for x in properties['alphabet'].split()]:
			if ch[0] == '[' and ch[-1] == ']':
				properties['symbols'] = ch[1:-1].strip()
			else:
				alphabet.append(ch)
			#end if
		#end for
		properties['alphabet'] = alphabet

		return properties
	#end function


	def __setLocale(self, collate="C", encoding=None, variant=None):
		"""Sets the locale to the specified locale, encoding and locale
		variant."""

		success = False
		for e in [encoding, "UTF8"]:
			if success: break
			for v in [variant, ""]:
				localestring = '.'.join([x for x in [collate, e] if x])
				localestring = '@'.join([x for x in [localestring, v] if x])
				try:
					locale.setlocale(locale.LC_COLLATE, localestring)
					success = True
					break
				except locale.Error: pass
			#end for
		#end for

		if not success:
			msg = "Warning: cannot set locale '%s'." % collate
			sys.stderr.write(msg)
		#end if
	#end function


	def __resetLocale(self):
		"""Resets LC_COLLATE to its default."""
		locale.resetlocale(locale.LC_COLLATE)
	#end function


	def __adaptEncoding(self):
		"""Adapt all sortkeys' encoding to the locale's encoding."""

		localestring, encoding = locale.getlocale(locale.LC_COLLATE)

		if encoding and encoding.replace('-','') != "UTF8":
			i = 0
			while i < len(self.__glossary):
				term, node = self.__glossary[i]
				self.__glossary[i][0] = term.decode("UTF-8").encode(encoding)
				i += 1
			#end for
		#end if
	#end function


	def __sortGlossary(self, config):
		"""Sort glossary terms."""

		# create alphabet nodes
		for ch in config['alphabet']:
			newnode = libxml2.newNode("glsection")
			newnode.setProp("name", ch)
			self.__glossary.append([ch, newnode])
		#end for

		# adapt strings' encoding to locale
		self.__adaptEncoding()

		# comparison function
		def compare(a,b):
			result = locale.strcoll(a[0], b[0])
			y1 = a[1].name
			y2 = b[1].name
			if result != 0:
				return result
			elif y1 == y2:
				return 0
			elif y1 == "glsection":
				return -1
			elif y2 == "glsection":
				return +1
			else:
				return 0
		#end inline

		# sort items
		self.__glossary.sort(compare)
	#end function


	def __buildGlossary(self, node, config):
		"""Build XML DOM structure. self.__glossary is a list of tuples
		of the form (sortkey, node), where node can be a 'glsection' or
		a 'defterm' element."""

		section = libxml2.newNode("glsection")
		try:
			section.setProp("name", config['symbols'])
		except KeyError: pass
		section.addChild(libxml2.newNode("dl"))

		for item in self.__glossary:
			if item[1].name == "glsection":
				node.addChild(section)
				section = item[1]
				section.addChild(libxml2.newNode("dl"))
			else:
				child = item[1].children
				while child:
					next = child.next
					if child.name == "dt" or child.name == "dd":
						child.unlinkNode()
						section.children.addChild(child)
					#end if
					child = next
				#end while
				item[1].unlinkNode()
				item[1].freeNode()
			#end if
		#end for
		node.addChild(section)
		node.setName("glossary")

		return node
	#end function


	def __makeGlossary(self, node):
		"""Read configuration. Sort items. Build glossary. Build XML."""

		if not self.__glossary: return node

		# build configuration
		config = self.__configuration(node)

		# set locale
		self.__setLocale(config['locale'],
			config['locale_encoding'], config['locale_variant'])

		# sort glossary
		self.__sortGlossary(config)

		# reset locale
		self.__resetLocale()

		# build DOM structures
		return self.__buildGlossary(node, config)
	#end function


	def flush(self):
		self.__glossary = []
	#end function

#end class

