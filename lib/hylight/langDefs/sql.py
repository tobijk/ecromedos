# -*- coding: UTF-8 -*-
# SQL language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = """access add as asc begin by check cluster column compress connect current cursor decimal default
desc else elsif end exception exclusive file for from function group having identified if immediate increment
index initial into is level loop maxextents mode modify nocompress nowait of offline on online start
successful synonym table then to trigger uid unique user validate values view whenever where with option
order pctfree privileges procedure public resource return row rowlabel rownum rows session share size
smallint type using not and or in any some all between exists like escape union intersect minus prior
distinct sysdate out alter analyze audit comment commit create delete drop execute explain grant insert lock
noaudit rename revoke rollback savepoint select set truncate update"""

KW_LIST['kwb'] = "boolean char character date float integer long mlslabel number raw rowid varchar varchar2 varray"

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "--"

ML_COMMENT = "/* */"

IGNORECASE = True

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / * %  + -"
