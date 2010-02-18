# -*- coding: UTF-8 -*-
# Python language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

# Keywords taken from the VIM-Syntaxfile of Neil Schemenauer

KW_LIST['kwa'] = '''global lambda class nextgroup pythonfunction skipwhite
contained  chr cmp coerce compile complex delattr dir divmod eval execfile
filter float getattr globals hasattr hash hex id input  int intern isinstance
issubclass  len list locals long map max min  oct open ord pow range raw_input 
reduce reload repr round setattr  slice str tuple type vars xrange 
arithmeticerror assertionerror  attributeerror eoferror environmenterror 
exception floatingpointerror ioerror  importerror indexerror keyerror 
keyboardinterrupt lookuperror memoryerror nameerror notimplementederror 
oserror overflowerror runtimeerror  standarderror syntaxerror systemerror
systemexit typeerror valueerror zerodivisionerror'''

KW_LIST['kwb'] = '''break continue del except exec finally pass print raise return
try assert def for while if elif  else and in is not or'''

KW_LIST['kwc'] = '''import from abs apply callable self None'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS="\"\"\" \'\'\' \" \'" 

RAWSTRINGPREFIX = "r"

SL_COMMENT = "#"

IGNORECASE = True

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; . : & | < > !  = / * %  + -"
