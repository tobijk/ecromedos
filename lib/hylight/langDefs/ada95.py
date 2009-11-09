# -*- coding: UTF-8 -*-
# ADA 95 language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}


KW_LIST['kwa'] = '''abort else new return abs elsif not reverse abstract end null
accept entry select access exception  separate  aliased exit of  subtype  all
or  and  for  others tagged  array function out task  at terminate generic
package then  begin goto pragma type  body private if procedure case in 
protected   until  constant is  use raise declare   range when  delay limited
record while  delta loop rem  with digits renames do mod  requeue xor'''

KW_LIST['kwb'] = '''boolean integer natural positive float character 
string duration short_integer long_integer short_float long_float'''

KW_LIST['kwc'] = '''wide_character wide_string short_short_integer long_long_integer 
short_short_float long_long_float'''

STRINGDELIMITERS = "\""

SL_COMMENT = "--"

IGNORECASE = True

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + - '"
