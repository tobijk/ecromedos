# -*- coding: UTF-8 -*-
# Pascal/Object Pascal language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''absolute abstract and array as asm assembler automated begin case
cdecl class const constructor destructor dispid dispinterface div do downto
dynamic else end except export exports external far file finalization finally
for forward function goto if implementation in initialization inherited inline
interface is label library message mod near nil not object of or out override
packed pascal private procedure program property protected public published
raise record register repeat resourcestring safecall set shl shr stdcall string
then threadvar to try type unit until uses var virtual while with xor'''

KW_LIST['kwb'] = '''boolean char integer pointer real text
true false cardinal longint byte word single double int64'''

KW_LIST['kwc'] = '''if else then downto do for repeat while to until with'''

KW_RE['kwd']="regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS="\" \'"

SL_COMMENT="//"

ML_COMMENT="{ } (* *)"

IGNORECASE=True

SYMBOLS="( ) [ ] , ; : & | < > !  = / * %  + - @"

ESCCHAR="#"
