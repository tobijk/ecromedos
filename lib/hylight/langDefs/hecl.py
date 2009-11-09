# -*- coding: UTF-8 -*-
# Hecl language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''append break catch continue eq eval filter for foreach global hash if
incr intro join lappend lindex list llen lset proc puts return search set sindex slen
sort source split time append upeval  while'''

KW_RE['kwb'] = "regex(\\$\\w+)"

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "#"

ALLOWNESTEDCOMMENTS = False

IGNORECASE = False

ESCCHAR = "\\"

SYMBOLS = "( ) { } [ ] , ; . : & | < > !  = / *  %  + -"
