# -*- coding: UTF-8 -*-
# Felix language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}

KW_LIST['kwa'] = '''all and as body call case class code const define elif else endif
endmatch except export fork fun function functor goto header if in inf
interface lambda let match module NaN  not of open or proc procedure raise read
regexp regmatch return struct then to todo type typedef union use val var when
with header body code open  use endl print include true false not and or lnot
land lor pow eol'''

KW_LIST['kwb'] = '''tiny short int long vlong utiny ushort uint ulong uvlong int8
int16 int32 int64 uint8 uint16 uint32 uint64 float double ldouble  float32
float64 float80 char wchar uchar string wstring ustring void unit bool any
address byte'''

STRINGDELIMITERS = "\"\"\" \'\'\' \" \'"

SL_COMMENT = "//"

ML_COMMENT = "/* */"

ALLOWNESTEDCOMMENTS = True

IGNORECASE = False

RAWSTRINGPREFIX = "r"

ESCCHAR = "\\"

DIRECTIVE = "#"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
