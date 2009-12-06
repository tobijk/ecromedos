# -*- coding: UTF-8 -*-
# XML language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

TAG_DELIM = {}
KW_RE = {}

TAG_DELIM['kwa'] = "< >"

KW_RE['kwc'] = "regex(\"[^\"]*?\")(?=[^<]*>)"

KW_RE['kwa'] = "regex([-a-zA-Z0-9]+\\s*=(?=[^<]*>))"

KW_RE['kwd'] = "regex(\\&\\w+;)"

ML_COMMENT = "<!-- -->"

IGNORECASE = True

IDENTIFIER = "regex(\\<\\!\\[CDATA\\[(.|\\s)*?\\]\\]\\>)"

DIGIT = ""

SYMBOLS = ""
