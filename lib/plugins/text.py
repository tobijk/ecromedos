# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# ecmds includes
from error import ECMDSPluginError


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin:

	def __init__(self, config):
		self.lstrip = False
	#end function


	def flush(self):
		pass
	#end function


	def process(self, node, format):
		'''Prepare @node for target @format.'''
		
		if format.endswith("latex"):
			string = self.LaTeX_sanitizeString(node.getContent())
			if string: node.setContent(string)
		#end if

		return node
	#end function


	def LaTeX_sanitizeString(self, string):
		'''Replace any character that could have a special
		   meaning in some context in LaTeX with a macro.'''

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
		                 '-'  : "{}{\string-}{}",
		                 ':'  : "{}{\string:}{}",
		                 ';'  : "{}{\string;}{}",
		                 '!'  : "{}{\string!}{}",
		                 '?'  : "{}{\string?}{}",
		                 '"'  : "{}{\string\"}{}",
		                 '`'  : "{}{\string`}{}",
		                 '\'' : "{}{\string'}{}",
		                 '='  : "{}{\string=}{}",
		                 '\n' : "\n" }

		frame_start = 0
		frame_end = 0
		parts = []
		length = len(string)
		
		# lstrip if needed
		if self.lstrip:
			while frame_end < length:
				ch = string[frame_end]
				if not ch.isspace():
					self.lstrip = False
					break
				#end if
				frame_end += 1
				if ch == '\n':
					frame_start = frame_end
				#end if
			#end while
			if frame_end > frame_start:
				parts.append(string[frame_start:frame_end])
				frame_start = frame_end
			#end if
		#end if
		
		# replace special chars
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
				if ch == '\n': # cut multiple linebreaks
					if not self.lstrip:
						parts.append(ch)
						self.lstrip = True
					#end if
					frame_end += 1
					frame_start = frame_end
					while frame_end < length:
						ch = string[frame_end]
						if not ch.isspace():
							self.lstrip = False
							break
						#end if
						frame_end += 1
						if ch == '\n':
							frame_start = frame_end
						#end if
					#end while
					if frame_end > frame_start:
						parts.append(string[frame_start:frame_end])
						frame_start = frame_end
					#end if
				else:
					parts.append(escape_sequence)
					frame_end += 1
					frame_start = frame_end
				#end if
			else:
				frame_end += 1
			#end if
		#end while

		if frame_start == 0: return None
		if frame_end > frame_start: parts.append(string[frame_start:frame_end])
		return "".join(parts)
	#end function

#end class
