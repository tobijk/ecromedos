# -*- coding: UTF-8 -*-
# Agda language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''abstract case concrete data do in interface let module mutual of open native 
package postulate private public sig struct type use set type'''

KW_LIST['kwb'] = '''integer int float double bool char'''

STRINGDELIMITERS="\" \'"

SL_COMMENT = "--"

ML_COMMENT = "{- -}"

IGNORECASE = True

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
