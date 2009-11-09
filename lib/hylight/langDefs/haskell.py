# -*- coding: UTF-8 -*-
# Haskell language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''case class data default deriving do else import in infix infixl
infixr instance let module newtype of then type where as qualified hiding True
False'''

KW_LIST['kwb'] = '''Int Float Double Bool Char'''

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "--"

ML_COMMENT = "{- -}"

IGNORECASE = False

SYMBOLS = "( ) [ ]  , ; : & | < > ! = / * % + -"
