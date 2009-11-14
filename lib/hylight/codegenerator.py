# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

#standard includes
import re
from StringIO import StringIO

# error handling
from error import HLError


class CodeGenerator:

	# parser states
	UNKNOWN    =  0
	DEFAULT    =  1	
	SPACE      =  2
	KEYWORD    =  3
	NUMBER     =  4
	SYMBOL     =  5
	IDENTIFIER =  6
	SL_COMMENT =  7
	ML_COMMENT =  8
	DIRECTIVE  =  9
	STRING     = 10
	TAG        = 11


	def __init__(self):
		self.rules = {}
		self.statedict = None
		self.linenumbers = False
		self.linestepping = 1
	#end function


	def init(self, lang):
		'''Setup up parser for given programming/markup language.'''
		
		try:
			self.statedict = self.rules[lang]
		except KeyError:
			self.statedict = self.initLang(lang)
			self.rules[lang] = self.statedict
		#end try

	#end function


	def initLang(self, lang):
		'''Setup rules for parsing the given programming/markup language.'''

		statedict = {}
		symbols = ""
		
		# LOAD LANGUAGE
		module = None
		try:
			languages = __import__("langDefs", globals(), locals(), [lang])
			module = getattr(languages, lang)
		except ImportError:
			msg = "Could not find language definition modules."
			raise HLError(msg)
		except AttributeError:
			msg = "Could not find definitions for language '%s'." % (lang,)
			raise HLError(msg)
		#end try

		# list of strings of regular expressions
		rexprlist = []

		# WHITESPACE
		rexprlist.append("(?P<space>(\\s+|\\Z))")
		statedict['space'] = {}
		statedict['space']['id'] = CodeGenerator.SPACE
		statedict['space']['function'] = self.processDefault

		# STRING OF SYMBOLS
		if hasattr(module, "SYMBOLS"):
			symbols = ''.join(module.SYMBOLS.split())
		#end if

		# COMPILER DIRECTIVE
		if hasattr(module, "DIRECTIVE"):
			directive = module.DIRECTIVE.strip()
			if directive.startswith("regex("):
				expr = self.extractRexpr(directive)
			else:
				directive = re.escape(directive)
				if hasattr(module, "CONTINUATIONSYMBOL"):
					contsym = re.escape(module.CONTINUATIONSYMBOL.strip())
					expr = "%s(%s\\s+|.)*(?=(\n|\\Z))" % (directive, contsym)
				else:
					expr = "%s.*(?=(\n|\\Z))"
				#end if
			#end if
			rexprlist.append("(?P<directive>%s)" % (expr,))
			statedict['directive'] = {}
			statedict['directive']['id'] = CodeGenerator.DIRECTIVE
			statedict['directive']['function'] = self.processDefault
		#end if

		# SINGLE LINE COMMENTS
		if hasattr(module, "SL_COMMENT"):
			if module.SL_COMMENT.startswith("regex("):
				expr = self.extractRexpr(module.SL_COMMENT)
			else:
				comments = module.SL_COMMENT.split()
				exprlist = []
				for expr in comments:
					exprlist.append("%s.*(?=(\n|\\Z))" % (expr,))
				#end for
				expr = '|'.join(exprlist)
			#end if
			rexprlist.append("(?P<sl_comment>%s)" % (expr,))
			statedict['sl_comment'] = {}
			statedict['sl_comment']['id'] = CodeGenerator.SL_COMMENT
			statedict['sl_comment']['function'] = self.processDefault
		#end if

		# MULTI LINE COMMENTS
		if hasattr(module, "ML_COMMENT"):
			commentlist = module.ML_COMMENT.split()
			allownestedcomments = False
			if hasattr(module, "ALLOWNESTEDCOMMENTS"):
				allownestedcomments = module.ALLOWNESTEDCOMMENTS
			#end if
			startlist = []
			stoplist  = []
			for i in range(0, len(commentlist) / 2):
				startlist.append(commentlist[2*i])
				stoplist.append(commentlist[2*i+1])
			#end for
			rexprlist.append("(?P<ml_comment_start>%s)" % ( '|'.join(map(re.escape, startlist)),))
			statedict['ml_comment_start'] = {}
			statedict['ml_comment_start']['id'] = CodeGenerator.ML_COMMENT
			statedict['ml_comment_start']['function'] = self.processMLComment
			statedict['ml_comment_start']['rexpr'] = {}
			for start, stop in zip(startlist, stoplist):
				exprlist = []
				if allownestedcomments:
					exprlist.append("(?P<ml_comment_start>%s)" % (re.escape(start),))
				#end if
				exprlist.append("(?P<ml_comment_stop>%s)" % (re.escape(stop),))
				statedict['ml_comment_start']['rexpr'][start] = re.compile('|'.join(exprlist))
			#end for
		#end if
		
		# TAG DELIMITERS
		if hasattr(module, "TAG_DELIM"):
			key = module.TAG_DELIM.keys()[0]
			starttag, stoptag = module.TAG_DELIM[key].split()[:2]
			rexprlist.append("(?P<tag_start>%s)" % (starttag,))
			statedict['tag_start'] = {}
			statedict['tag_start']['id'] = CodeGenerator.TAG
			statedict['tag_start']['function'] = self.processTagStart
			statedict['tag_start']['group'] = key
			rexprlist.append("(?P<tag_stop>%s)" % (stoptag,))
			statedict['tag_stop'] = {}
			statedict['tag_stop']['id'] = CodeGenerator.TAG
			statedict['tag_stop']['function'] = self.processTagStop
			statedict['tag_stop']['group'] = key
		#end if

		# ESCAPE CHARACTERS
		escchar = ""
		if hasattr(module, "ESCCHAR"):
			if module.ESCCHAR.startswith("regex("):
				escchar = self.extractRexpr(module.ESCCHAR)
			else:
				escchar = "%s." % (re.escape(module.ESCCHAR.strip()),)
			#end if
		#end if
		
		# STRINGS
		if hasattr(module, "STRINGDELIMITERS"):
			delimiterlist = module.STRINGDELIMITERS.split()
			rawprefix = ""
			if hasattr(module, "RAWSTRINGPREFIX"):
				rawprefix = module.RAWSTRINGPREFIX
			#end if
			startlist = []
			stoplist  = []
			for delimiter in delimiterlist:
				startlist.append(delimiter)
				stoplist.append(delimiter)
			#end for
			rexprlist.append("(?P<string_start>%s)" % ('|'.join(map(re.escape, startlist)),))
			statedict['string_start'] = {}
			statedict['string_start']['id'] = CodeGenerator.STRING
			statedict['string_start']['function'] = self.processString
			statedict['string_start']['rexpr'] = {}
			for start, stop in zip(startlist, stoplist):
				exprlist = []
				if escchar:
					exprlist.append("(?P<escchar>%s)" % (escchar,))
				#end if
				exprlist.append("(?P<string_stop>%s)" % (re.escape(stop),))
				statedict['string_start']['rexpr'][start] = re.compile('|'.join(exprlist))
			#end for
			if rawprefix:
				statedict['raw_string_start'] = {}
				statedict['raw_string_start']['id'] = CodeGenerator.STRING
				statedict['raw_string_start']['function'] = self.processRawString
				statedict['raw_string_start']['rexpr'] = {}
				exprlist = []
				for start in startlist:
					exprlist.append("%s%s" % (rawprefix, start))
				#end for
				rexprlist.append("(?P<raw_string_start>%s)" % ('|'.join(map(re.escape, exprlist)),))
				for start, stop in zip(exprlist, stoplist):
					expr = "(?P<string_stop>%s)" % (re.escape(stop),)
					statedict['raw_string_start']['rexpr'][start] = re.compile(expr)
				#end for
			#end if
		#end if

		# KEYWORDS
		exprdict = {}
		if hasattr(module, 'KW_LIST'):
			for group in module.KW_LIST.keys():
				wordlist = module.KW_LIST[group].split()
				expr = "|".join([re.escape(word) for word in wordlist])
				if symbols:
					expr = "((%s)(?=(\\s+|[%s]|\\Z)))" % (expr, re.escape(symbols))
				else:
					expr = "((%s)(?=(\\s+|\\Z)))" % (expr,)
				#end if
				exprdict.setdefault(group, []).append(expr)
			#end for
		#end if
		if hasattr(module, 'KW_RE'):
			for group, expr in module.KW_RE.iteritems():
				exprdict.setdefault(group, []).append(("(%s)") % (self.extractRexpr(expr),))
			#end for
			for group, exprlist in exprdict.iteritems():
				expr = '|'.join(exprlist)
				rexprlist.append("(?P<%s>%s)" % (group, expr))
				statedict[group] = {}
				statedict[group]['id'] = CodeGenerator.KEYWORD
				statedict[group]['function'] = self.processDefault
			#end for
		#end if

		# IDENTIFIERS
		if hasattr(module, 'IDENTIFIER'):
			if module.IDENTIFIER:
				expr = self.extractRexpr(module.IDENTIFIER)
				rexprlist.append("(?P<identifier>%s)" % (expr,))
			#end if
		else:
			expr = "[a-zA-Z_]\\w*"
			rexprlist.append("(?P<identifier>%s)" % (expr,))
		#end if
		statedict['identifier'] = {}
		statedict['identifier']['id'] = CodeGenerator.IDENTIFIER
		statedict['identifier']['function'] = self.processDefault

		# NUMBERS
		if hasattr(module, "DIGIT"):
			if module.DIGIT:
				expr = self.extractRexpr(module.DIGIT)
				rexprlist.append("(?P<number>%s)" % (expr,))
			#end if
		else:
			expr = "(?:0x|0X)[0-9a-fA-F]+|\\d*[\\.]?\\d+(?:[eE][\\-\\+]\\d+)?[lLuU]?"
			rexprlist.append("(?P<number>%s)" % (expr,))
		#end if
		statedict['number'] = {}
		statedict['number']['id'] = CodeGenerator.NUMBER
		statedict['number']['function'] = self.processDefault

		# SYMBOLS
		if symbols:
			rexprlist.append("(?P<symbol>[%s]+)" % (re.escape(symbols),))
			statedict['symbol'] = {}
			statedict['symbol']['id'] = CodeGenerator.SYMBOL
			statedict['symbol']['function'] = self.processDefault
		#end if

		# CASE IN/SENSITIVE
		ignorecase = False
		if hasattr(module, "IGNORECASE"): ignorecase = module.IGNORECASE

		# COMPILE MASSIVE REGULAR EXPRESSION
		flags = re.MULTILINE
		if ignorecase: flags += re.IGNORECASE
		statedict['default'] = {}
		statedict['default']['id'] = -1
		statedict['default']['rexpr'] = re.compile('|'.join(rexprlist), flags)

		return statedict
	#end function


	def lineNumbers(self, boolean):
		'''Toggle printing of line numbers.'''
		self.linenumbers = boolean
	#end function


	def lineStepping(self, stepping=1):
		'''If line-numbering is on, determines the step width.'''
		self.linestepping = stepping
	#end function


	def extractRexpr(self, string):
		'''Extract expression from a string of the form "regex(expr)"'''
		
		l = string.find("(")
		r = string.rfind(")")
		if (l < 0) or (r < 0):
			msg = "Could not extract regular expression from string '%s'." % (string,)
			raise HLError(msg)
		#end if

		return string[l+1:r]
	#end function


	def nextChar(self):
		'''Fetch next character from buffer.'''

		if self.char == '\n':
			self.line += 1
			if self.linenumbers:
				for state, group in self.state[::-1]:
					self.closeTag(state, group)
				#end for
				self.printLineNumber(self.line * self.linestepping)
				for state, group in self.state[::+1]:
					self.openTag(state, group)
				#end for
		#end if

		self.position += 1
		try:
			return self.buf[self.position]
		except IndexError:
			return None
		#end try
	#end function


	def loadTheme(self, theme):
		'''Load specified theme.'''
		
		# load theme
		module = None
		try:
			languages = __import__("themes", globals(), locals(), [theme])
			module = getattr(languages, theme)
		except ImportError:
			msg = "Could not find theme modules."
			raise HLError(msg)
		except AttributeError:
			msg = "Could not find theme '%s'." % (theme,)
			raise HLError(msg)
		#end try

		self.theme = {}
		try:
			self.theme['defaultcolor'] = module.DEFAULTCOLOUR
		except AttributeError:
			self.theme['defaultcolor'] = [0x00, 0x00, 0x00, ""]
		#end try
		try:
			self.theme['bgcolor'] = module.BGCOLOUR
		except AttributeError:
			self.theme['bgcolor'] = [0xff, 0xff, 0xff, ""]
		#end try
		if hasattr(module, "KW_GROUP"):
			self.theme['keyword'] = {}
			for group, value in module.KW_GROUP.iteritems():
				self.theme['keyword'][group] = value
			#end for
		#end if
		try:
			self.theme['number'] = module.NUMBER
		except AttributeError:
			self.theme['number'] = self.theme['defaultcolor']
		#end try
		try:
			self.theme['string'] = module.STRING
		except AttributeError:
			self.theme['string'] = self.theme['defaultcolor']
		#end try
		try:
			self.theme['comment'] = module.COMMENT
		except AttributeError:
			self.theme['comment'] = self.theme['defaultcolor']
		#end try
		try:
			self.theme['directive'] = module.DIRECTIVE
		except AttributeError:
			self.theme['directive'] = self.theme['defaultcolor']
		#end try
		try:
			self.theme['symbol'] = module.SYMBOL
		except AttributeError:
			self.theme['symbol'] = self.theme['defaultcolor']
		#end try
		try:
			self.theme['line'] = module.LINE
		except AttributeError:
			self.theme['line'] = self.theme['defaultcolor']
		#end try

	#end function


	def highlightString(self, string, lang, startline=1, theme="ide-eclipse", fragment=False):
		'''Apply syntax-highlighting to string and return result as string.'''

		# initialize
		self.init(lang)
		self.loadTheme(theme)
		
		# initialize properties
		self.position = 0
		self.buf      = string
		self.out      = StringIO()
		self.line     = startline
		self.state    = [[CodeGenerator.UNKNOWN, ""]]

		try:
			self.char = self.buf[0]
		except IndexError: pass
		
		# document preamble
		self.header(fragment)

		# print first line number
		if self.linenumbers: self.printLineNumber(self.line * self.linestepping)

		# loop with rexpr over string
		rexpr = self.statedict['default']['rexpr']
		iterator = rexpr.finditer(self.buf, self.position)
		try:
			match = iterator.next()
			while match:
				if match.start() > self.position:
					self.writeOpenTags()
					self.printOut(match.start() - self.position)
					self.writeCloseTags()
				#end if
				self.statedict[match.lastgroup]['function'](match)
				#end if
				if match.end() < self.position:
					rexpr = self.statedict['default']['rexpr']
					iterator = rexpr.finditer(self.buf, self.position)
				#end if
				match = iterator.next()
			#end while
		except StopIteration: pass

		# close document
		self.footer(fragment)

		# fetch result
		result = self.out.getvalue()
		self.out.close()

		return result
	#end function


	def processDefault(self, match):
		'''Copy matched token to output stream.'''

		group = match.lastgroup
		state = self.statedict[group]['id']

		self.state.append([state, group])
		self.openTag(state, group)
		self.printOut(match.end() - match.start())
		self.closeTag(state, group)
		self.state.pop()
	#end function


	def processMLComment(self, match, print_tags = True):
		'''Parse a multiline comment.'''

		start = match.group()
		state = self.statedict[match.lastgroup]['id']
		
		if print_tags:
			self.openTag(state, start)
			self.state.append([state, start])
		#end if
		self.printOut(match.end() - match.start())

		rexpr = self.statedict['ml_comment_start']['rexpr'][start]
		iterator = rexpr.finditer(self.buf, self.position)
		try:
			match = iterator.next()
			while match:
				if match.start() > self.position:
					self.printOut(match.start() - self.position)
				#end if
				if match.lastgroup == 'ml_comment_stop':
					self.printOut(match.end() - match.start())
					break
				elif match.lastgroup == 'ml_comment_start':
					self.processMLComment(match, False)
				#end if
				if match.end() < self.position:
					rexpr = self.statedict['default']['rexpr']
					iterator = rexpr.finditer(self.buf, self.position)
				#end if
				match = iterator.next()
			#end while
		except StopIteration: pass

		if print_tags:
			self.closeTag(state, start)
			self.state.pop()
		#end if
	#end function	


	def processTagStart(self, match):
		'''Process tag start.'''

		group = self.statedict['tag_start']['group']
		state = self.statedict[match.lastgroup]['id']

		self.openTag(state, group)
		self.state.append([state, group])
		self.printOut(match.end() - match.start())

		# loop with rexpr over string
		rexpr = self.statedict['default']['rexpr']
		iterator = rexpr.finditer(self.buf, self.position)
		try:
			match = iterator.next()
			while match:
				if match.start() > self.position:
					self.printOut(match.start() - self.position)
				#end if
				if match.lastgroup == "string_start":
					self.statedict[match.lastgroup]['function'](match)
				elif match.lastgroup == "tag_stop":
					self.processTagStop(match)
					break
				else:
					self.printOut(match.start() - self.position)
				#end if
				if match.end() < self.position:
					rexpr = self.statedict['default']['rexpr']
					iterator = rexpr.finditer(self.buf, self.position)
				#end if
				match = iterator.next()
			#end while
		except StopIteration: pass

	#end function	


	def processTagStop(self, match):
		'''Process tag stop.'''

		group = self.statedict['tag_stop']['group']
		state = self.statedict[match.lastgroup]['id']

		self.printOut(match.end() - match.start())
		self.closeTag(state, group)
		self.state.pop()
	#end function	


	def processString(self, match):
		'''Parse a string.'''

		start = match.group()
		state = self.statedict[match.lastgroup]['id']
		
		self.state.append([state, start])
		self.openTag(state, start)
		self.printOut(match.end() - match.start())

		rexpr = self.statedict['string_start']['rexpr'][start]
		iterator = rexpr.finditer(self.buf, self.position)
		try:
			match = iterator.next()
			while match:
				if match.start() > self.position:
					self.printOut(match.start() - self.position)
				#end if
				if match.lastgroup == 'string_stop':
					self.printOut(match.end() - match.start())
					break
				elif match.lastgroup == 'escchar':
					self.printOut(match.end() - match.start())
				#end if
				if match.end() < self.position:
					rexpr = self.statedict['default']['rexpr']
					iterator = rexpr.finditer(self.buf, self.position)
				#end if
				match = iterator.next()
			#end while
		except StopIteration: pass
		self.closeTag(state, start)
		self.state.pop()
	#end function


	def processRawString(self, match):
		'''Process a raw string.'''

		start = match.group()
		state = self.statedict[match.lastgroup]['id']
		
		self.state.append([state, start])
		self.openTag(state, start)
		self.printOut(match.end() - match.start())

		rexpr = self.statedict['raw_string_start']['rexpr'][start]
		iterator = rexpr.finditer(self.buf, self.position)
		try:
			match = iterator.next()
			while match:
				if match.start() > self.position:
					self.printOut(match.start() - self.position)
				#end if
				self.printOut(match.end() - match.start())
				break
			#end while
		except StopIteration: pass
		self.closeTag(state, start)
		self.state.pop()
	#end function

#end class
