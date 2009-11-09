# -*- coding: UTF-8 -*-
# C# language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''return value add remove get set readonly break case default else
if switch catch checked finally throw try unchecked abstract base class
delegate event explicit implicit interface internal new operator override
private protected public sealed static this virtual false null true
namespace using break continue do for foreach while'''

KW_LIST['kwb'] = '''object bool byte char const decimal double enum float int long
sbyte short string struct uint ulong ushort void'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "//"

ML_COMMENT = "/* */"

IGNORECASE = False

ESCCHAR = "\\"

DIRECTIVE = "#"

RAWSTRINGPREFIX = "@"

SYMBOLS = "( ) [ ] { } , ; . : & | < > !  = / *  %  + -"

CONTINUATIONSYMBOL = "\\"
