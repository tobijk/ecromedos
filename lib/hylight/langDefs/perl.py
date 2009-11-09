# -*- coding: UTF-8 -*-
# Perl language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''and cmp continue else elsif eq for foreach ge goto gt if last
le lt do ne next not or package return sub switch unless until use while xor'''

KW_LIST['kwc'] = '''my local'''

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "#"

IGNORECASE = False

ESCCHAR = "\\"

ALLOWEXTESCAPE = True

KW_RE['kwb'] = "regex([$@%]\\w+)"

KW_RE['kwc'] = "regex((?<=\\$\\{)(\\w+)(?=\\}))"

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / * + - $"
