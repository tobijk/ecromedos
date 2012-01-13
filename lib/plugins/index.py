# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# std includes
import libxml2, sys, locale

# ecmds includes
from ecmds.error import ECMDSPluginError


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin(object):

	def __init__(self, config):
		self.__index = {}
		self.__counter = 0
		try:
			self.__draft = config['xsl_params']['global.draft']
		except KeyError:
			self.__draft = "'no'"
	#end function


	def __saveNode(self, node):
		"""Substitutes a 'defterm' node with a label and stores a reference
		to the node for later when the index is to be built."""

		sortkey = node.prop("sortkey")
		group = node.prop("group")
		if not group: group = "default"

		item = None
		subitem = None
		subsubitem = None

		# read idxterm items
		child = node.children
		while child:
			if child.type == "element":
				if child.name == "item":
					item = child.getContent().strip()
				elif child.name == "subitem":
					subitem = child.getContent().strip()
				elif child.name == "subsubitem":
					subsubitem = child.getContent().strip()
				#end if
			#end if
			child = child.next
		#end for

		# create new 'label' node
		label_node = libxml2.newNode("label")
		label_id   = "idx:item%06d" % self.__counter
		label_node.setProp("id", label_id)

		# substitute the label for the idxterm
		node.replaceNode(label_node)
		node.freeNode()

		# at least 'item' must exist
		if item != None:
			index = self.__index.setdefault(group, [group, {}, [], None])
			for x in [item, subitem, subsubitem, None]:
				if not x:
					index[2].append(label_id)
					index[3] = sortkey
					break
				#end if
				index = index[1].setdefault(x, [x, {}, [], None])
			#end for
		#end if

		self.__counter += 1
		return label_node
	#end function


	def process(self, node, format):
		"""Either saves a glossary entry or sorts and builds the glossary,
		depending on which node triggered the plugin."""

		# skip if in draft mode
		if self.__draft == "'yes'": return node

		if node.name == "idxterm":
			node = self.__saveNode(node)
		elif node.name == "make-index":
			node = self.__makeIndex(node)
		#end if
		return node
	#end function


	def __configuration(self, node):
		"""Read node attributes and build a dictionary holding
		configuration information for the collator"""

		# presets
		properties = {
			"alphabet" : "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z",
			"locale"   : "C",
			"locale_encoding": None,
			"locale_variant": None,
			"columns"  : "2",
			"group"    : "default",
			"separator": ", "
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


	def __adaptEncoding(self, itemlist, encoding):
		"""Adapt all sortkeys' encoding to the locale's encoding."""

		if encoding and encoding.replace('-','') != "UTF8":
			i = 0
			while i < len(itemlist):
				values = itemlist[i]
				values[-1] = values[-1].decode("UTF-8").encode(encoding)
				i += 1
			#end for
		#end if
	#end function


	def __sortIndex(self, index, level="item", config=None, encoding=None):
		"""Sort index terms."""

		# stop recursion
		if not index: return index

		# recursive sortkey evaluation
		itemlist = []
		for v in index.itervalues():
			# set sortkey
			if not v[-1]: v[-1] = v[0]
			# recursion
			v[1]  = self.__sortIndex(v[1], "sub"+level, config, encoding)
			itemlist.append(v)
		#end for

		# insert alphabet
		if level == "item":
			for ch in config['alphabet']:
				newnode = libxml2.newNode("idxsection")
				newnode.setProp("name", ch)
				itemlist.append(["idxsection", newnode, ch])
			#end for
		#end if

		# adapt strings' encoding to locale
		self.__adaptEncoding(itemlist, encoding)

		# comparison function
		def compare(a,b):
			result = locale.strcoll(a[-1], b[-1])
			y1 = a[1]
			y2 = b[1]
			if result != 0:
				return result
			elif isinstance(y1, libxml2.xmlNode) \
					and isinstance(y2, libxml2.xmlNode):
				return 0
			elif isinstance(y1, libxml2.xmlNode):
				return -1
			elif isinstance(y2, libxml2.xmlNode):
				return +1
			else:
				return 0
		#end inline

		# sort index
		itemlist.sort(compare)
		return itemlist
	#end function


	def __buildIndexHelper(self, section, index, level, separator):
		"""Build index recursively from nested lists structure."""

		# stop recursion
		if not index: return index

		for item in index:
			term = item[0]
			item_node = libxml2.newNode(level)
			item_node.addChild(libxml2.newText(term))
			# build referrer node
			i = 0
			references = item[2]
			num_ref = len(references)
			while i < num_ref:
				ref = references[i]
				# add single space
				if i == 0:
					item_node.addChild(libxml2.newText(" "))
				# add reference to list
				idxref_node = libxml2.newNode("idxref")
				idxref_node.setProp("idref", ref)
				item_node.addChild(idxref_node)
				# add separator (this should be configurable)
				if i < num_ref - 1:
					item_node.addChild(libxml2.newText(separator))
				i += 1
			#end while
			section.addChild(item_node)
			# recursion
			self.__buildIndexHelper(section, item[1], "sub"+level, separator)
		#end for
	#end function


	def __buildIndex(self, node, config):
		"""Build XML DOM structure."""

		# detect group name
		group = node.prop("group")
		if not group: group = "default"

		# load group
		try:
			index = self.__index[group][1]
		except:
			return node
		#end try

		# sort index
		localestring, encoding = locale.getlocale(locale.LC_COLLATE)
		index = self.__sortIndex(index, level="item",
			config=config, encoding=encoding)

		# build base node
		index_node = libxml2.newNode("index")
		for prop_name in ["columns", "title", "tocentry"]:
			try:
				index_node.setProp(prop_name, config[prop_name])
			except KeyError: pass
		#end for		

		# start building index...
		section = libxml2.newNode("idxsection")
		try:
			section.setProp("name", config['symbols'])
		except KeyError: pass

		separator = config["separator"]

		for item in index:
			if isinstance(item[1], libxml2.xmlNode):
				index_node.addChild(section)
				section = item[1]
			else:
				term = item[0]
				item_node = libxml2.newNode("item")
				item_node.addChild(libxml2.newText(term))
				# build referrer node
				i = 0
				references = item[2]
				num_ref = len(references)
				while i < num_ref:
					ref = references[i]
					# add single space
					if i == 0:
						item_node.addChild(libxml2.newText(" "))
					# add reference to list
					idxref_node = libxml2.newNode("idxref")
					idxref_node.setProp("idref", ref)
					item_node.addChild(idxref_node)
					# add separator (this should be configurable)
					if i < num_ref - 1:
						item_node.addChild(libxml2.newText(separator))
					i += 1
				#end while
				section.addChild(item_node)
				# recursion
				self.__buildIndexHelper(section, item[1], "subitem", separator)
			#end if
		#end for
		index_node.addChild(section)

		# clean up and return new node
		node.replaceNode(index_node)
		node.freeNode()

		return index_node
	#end function


	def __makeIndex(self, node):
		"""Read configuration. Sort items. Build index. Build XML."""

		# read node attributes and build configuration
		config = self.__configuration(node)

		# set locale
		self.__setLocale(config['locale'],
			config['locale_encoding'], config['locale_variant'])

		# build DOM structures
		index = self.__buildIndex(node, config)

		# reset locale
		self.__resetLocale()

		return index
	#end function


	def flush(self):
		self.__index = {}
		self.__counter = 0
	#end function

#end class
