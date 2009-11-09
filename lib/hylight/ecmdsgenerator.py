# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the eCromedos document preparation system
# Date:    2006/03/09
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# import base class
from codegenerator import CodeGenerator


class ECMDSGenerator(CodeGenerator):

	def __init__(self):
		CodeGenerator.__init__(self)
	#end function


	def writeOpenTags(self, style="defaultcolor", group=None):
		'''Print opening tags.'''

		if group:
			r, g, b, fmt = self.theme[style][group]
		else:
			r, g, b, fmt = self.theme[style]
		#end if
		color = 0 + (r << 16) + (g << 8) + b
		self.out.write("<color rgb=\"#%06x\">" % (color,))
		if fmt:
			if "underline" in fmt:
				self.out.write("<u>")
			if "italic" in fmt:
				self.out.write("<i>")
			if "bold" in fmt:
				self.out.write("<b>")
			#end ifs
		#end if
	#end function


	def writeCloseTags(self, style="defaultcolor", group=None):
		'''Print closing tags.'''

		if group:		
			fmt = self.theme[style][group][3]
		else:
			fmt = self.theme[style][3]
		#end if
		if fmt:
			if "bold" in fmt:
				self.out.write("</b>")
			if "italic" in fmt:
				self.out.write("</i>")
			if "underline" in fmt:
				self.out.write("</u>")
			#end ifs
		#end if
		self.out.write("</color>")
	#end function


	def printLineNumber(self, number):
		'''Print current line number.'''
		self.writeOpenTags("line")
		self.out.write("%04d " % (number,))
		self.writeCloseTags("line")
	#end function


	def header(self, fragment=False):
		'''Print eCromedos header.'''

		r, g, b, fmt = self.theme['bgcolor']
		bgcolor = 0 + (r << 16) + (g << 8) + b

		if not fragment:
			self.out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
			self.out.write("<article>\n")
			self.out.write("  <head>\n")
			self.out.write("  </head>\n")
			self.out.write("  <section>\n")
			self.out.write("    <title></title>")
			self.out.write("    <listing>")
		#end if
		self.out.write("<code bgcolor=\"#%06x\">" % (bgcolor,))
	#end function
	
	
	def footer(self, fragment=False):
		'''Close eCromedos document.'''

		self.out.write("</code>\n")
		if not fragment:
			self.out.write("    </listing>")
			self.out.write("  </section>\n")
			self.out.write("</article>\n")
		#end if
	#end function


	def openTag(self, state, group):
		'''Print an opening tag corresponding to the parser state.'''

		if state == CodeGenerator.KEYWORD:
			self.writeOpenTags("keyword", group)
		elif state == CodeGenerator.TAG:
			self.writeOpenTags("keyword", group)
		elif state == CodeGenerator.SYMBOL:
			self.writeOpenTags("symbol")
		elif state == CodeGenerator.NUMBER:
			self.writeOpenTags("number")
		elif state == CodeGenerator.SL_COMMENT:
			self.writeOpenTags("comment")
		elif state == CodeGenerator.DIRECTIVE:
			self.writeOpenTags("directive")
		elif state == CodeGenerator.ML_COMMENT:
			self.writeOpenTags("comment")
		elif state == CodeGenerator.STRING:
			self.writeOpenTags("string")
		elif state == CodeGenerator.IDENTIFIER:
			self.writeOpenTags()
		elif state == CodeGenerator.UNKNOWN:
			pass
		elif state == CodeGenerator.SPACE:
			pass
		#end if
	#end function


	def closeTag(self, state, group):
		'''Print a closing tag corresponding to the parser state.'''

		if state == CodeGenerator.KEYWORD:
			self.writeCloseTags("keyword", group)
		elif state == CodeGenerator.TAG:
			self.writeCloseTags("keyword", group)
		elif state == CodeGenerator.SYMBOL:
			self.writeCloseTags("symbol")
		elif state == CodeGenerator.NUMBER:
			self.writeCloseTags("number")
		elif state == CodeGenerator.SL_COMMENT:
			self.writeCloseTags("comment")
		elif state == CodeGenerator.DIRECTIVE:
			self.writeCloseTags("directive")
		elif state == CodeGenerator.ML_COMMENT:
			self.writeCloseTags("comment")
		elif state == CodeGenerator.STRING:
			self.writeCloseTags("string")
		elif state == CodeGenerator.IDENTIFIER:
			self.writeCloseTags()
		elif state == CodeGenerator.UNKNOWN:
			pass
		elif state == CodeGenerator.SPACE:
			pass
		#end if
	#end function


	def printOut(self, num_chars):
		'''Copy next @num_chars characters from buffer to output.'''
		
		i = 0
		while i < num_chars:
			if self.char == '<':
				self.out.write("&lt;")
			elif self.char == '>':
				self.out.write("&gt;")
			elif self.char == '"':
				self.out.write("&quot;")
			elif self.char == '&':
				self.out.write("&amp;")
			else:
				self.out.write(self.char)
			#end if
			self.char = self.nextChar()
			i += 1
		#end while
	#end function

#end class
