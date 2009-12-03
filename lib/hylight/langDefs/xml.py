# -*- coding: UTF-8 -*-
# XML language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

TAG_DELIM = {}
KW_RE = {}

TAG_DELIM['kwa'] = "< >"

KW_RE['kwb'] = "regex(\\&\\w+;)"

KW_RE['kwc'] = "regex([-a-zA-Z0-9]+=(?=[^<]*>))"

KW_RE['kwd'] = "regex((?<==)\"[^\"]*?\")(?=[^<]*>)"

ML_COMMENT = "<!-- --> <![CDATA[ ]]>"

IGNORECASE = True

IDENTIFIER = ""

DIGIT = ""

SYMBOLS = ""
