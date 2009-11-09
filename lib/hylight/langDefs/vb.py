# -*- coding: UTF-8 -*-
# Visual Basic language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa']='''and as begin case call continue do each else elseif end erase
error event exit false for function get gosub goto if implement in load loop
lset me mid new next not nothing on or property raiseevent resume return rset
select set stop sub then to true unload until wend while with withevents
attribute alias as  byref  byval  compare   declare explicit friend global let
lib  module object option optional preserve private property public redim  type
dim const'''

KW_LIST['kwb']='''boolean  byte  currency date decimal  double enum integer  long
single static string variant'''

KW_RE['kwd']="regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS="\""

KW_RE['kwb']="regex(\\$\\S+?)"

SL_COMMENT="\' rem REM Rem"

IGNORECASE=True

SYMBOLS="( ) [ ] { } , ; : & | < > !  = / * %  + -"
