# -*- coding: UTF-8 -*-
# Eiffel language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''agent alias all and as assign check class convert create current debug deferred do else elseif end ensure
expanded export external false feature from frozen if implies indexing infix inherit inspect invariant is
like local loop not obsolete old once or prefix precursor pure redefine reference rename require rescue result
retry separate then true tuple undefine'''

KW_LIST['kwb'] = '''integer real double character  boolean'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "--"

IGNORECASE = True

SYMBOLS = "( ) [ ] { } , ; : & | < > ! - + = / * + -"
