# -*- coding: UTF-8 -*-
# Icon language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''by case  create default do else every if initial next of repeat then to until while
break  end fail global invocable link local procedure record return static suspend'''
			
KW_LIST['kwb'] = '''co-expression cset tfile integer list null real set string table window'''
			
STRINGDELIMITERS = "\" \'"

SL_COMMENT = "#"

IGNORECASE = False

ESCCHAR = "\\"

KW_RE['kwa'] = "regex(\\&\\w+)"
KW_RE['kwb'] = "regex(\\$\\w+)"

SYMBOLS = "( ) [ ] { } , ; :  | < > ! - + = / * + -"
