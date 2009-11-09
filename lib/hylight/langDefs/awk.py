# -*- coding: UTF-8 -*-
# (G)AWK script language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''begin break close continue delete do else end exit for 
getline gsub if index length match next print printf return split sprintf sub
substr system tolower toupper while'''

KW_LIST['kwb'] = '''argc argind argv convfmt environ errno fieldwidths filename fnr
fs ignorecase nf nr ofmt ofs ors rlength rs rstart rt subset'''

KW_LIST['kwc'] = "function"

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "#"

IGNORECASE = True

ESCCHAR = "\\ %"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *   + -"
