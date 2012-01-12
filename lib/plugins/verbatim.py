# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# ecmds includes
from ecmds.error import ECMDSPluginError


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

		tab_spaces = 4
		prop = node.properties
		try:
			while prop:
				if prop.name == "tabspaces":
					tab_spaces = int(prop.content)
					break
				#end if
				prop = prop.next
			#end while
		except Exception: pass

		if format.endswith("latex"):
			self.verbatimString = self.LaTeX_verbatimString
		else:
			self.verbatimString = self.XHTML_verbatimString
		#end if

		if node.children:
			for child in node.children:
				if child.type == "text":
					string = self.verbatimString(child.getContent(), tab_spaces)
					if string: child.setContent(string)
				#end if
			#end for
		#end if
		
		return node
	#end function


	def XHTML_verbatimString(self, string, tab_spaces):
		'''Replaces tabs with spaces.'''

		frame_start = 0
		frame_end = 0
		parts = []
		length = len(string)
		while frame_end < length:
			ch = string[frame_end]
			if ch == '\t':
				parts.append(string[frame_start:frame_end])
				parts.append(" " * tab_spaces)
				frame_end += 1
				frame_start = frame_end
			else:
				frame_end += 1
			#end if
		#end while

		if frame_start == 0: return None
		if frame_end > frame_start: parts.append(string[frame_start:frame_end])
		return "".join(parts)
	#end function


	def LaTeX_verbatimString(self, string, tab_spaces):
		'''Replace any character that could have a special meaning in some
		   context in LaTeX with a macro. But don't touch whitespace.'''

		lookup_table = { '['  : "{[}",
		                 ']'  : "{]}",
		                 '{'  : "\\{{}",
		                 '}'  : "\\}{}",
		                 '#'  : "\\#{}",
		                 '&'  : "\\&{}",
		                 '_'  : "\\_{}",
		                 '%'  : "\\%{}",
		                 '$'  : "\\${}",
		                 '^'  : "\\^{}",
		                 '\\' : "\\textbackslash{}",
		                 '~'  : "\\textasciitilde{}",
		                 '-'  : "{}{-}{}",
		                 ':'  : "{}{:}{}",
		                 ';'  : "{}{;}{}",
		                 '!'  : "{}{!}{}",
		                 '?'  : "{}{?}{}",
		                 '"'  : "{}{\"}{}",
		                 '`'  : "{}{`}{}",
		                 '\'' : "{}{'}{}",
		                 '='  : "{}{=}{}",
		                 '\t' : "\t" }

		frame_start = 0
		frame_end = 0
		parts = []
		length = len(string)
		while frame_end < length:
			ch = string[frame_end]
			# look for translation
			try:
				escape_sequence = lookup_table[ch]
			except KeyError:
				escape_sequence = ""
			#end try
			if escape_sequence:
				if frame_end > frame_start:
					parts.append(string[frame_start:frame_end])
				#end if
				if ch == '\t':
					parts.append(" " * tab_spaces)
				else:
					parts.append(escape_sequence)
				#end if
				frame_end += 1
				frame_start = frame_end
			else:
				frame_end += 1
			#end if
		#end while

		if frame_start == 0: return None
		if frame_end > frame_start: parts.append(string[frame_start:frame_end])
		return "".join(parts)
	#end function

#end class
