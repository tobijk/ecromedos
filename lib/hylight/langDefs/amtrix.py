# -*- coding: UTF-8 -*-
# AMTrix language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''argument amtrix_logid and append arg_list arg_opt argumentcount arraysize as
assignment  begin binary bit_and bit_not bit_or bit_shift bit_xor block bounded break by
call case catch center char charset close comments commit composite conditional constant
constants continue control convert copy count currentdate data database date debug declare
delete destination dir_close dir_open dir_read dir_rewind edi edi_charset edi_read_charset
edi_read_interchange edi_truncate element else error exec execute exit export expressions
file float for format from from_iso8859 function getopt group if import include input
insert integer into left lock log logid loop mandatory module move ndec nolog on open
optdta_read optdta_write optional or order others output pragma print raw_close raw_flush
raw_open raw_read raw_seek raw_tell raw_write read readtag receive regexp relation release
repeat reserved return right rollback scan segment select send sequence set sleep source
sourcefile sourceline sourcemodule sourceprocedure split sql statement str_field
str_fields str_lower str_upper strcnv strfield strfields string strlen strmid sub switch
system table text throw to to_iso8859 trunc truncate try type types unbounded unique_id
unique_name unlock update values variable variables while when where work writetag'''

STRINGDELIMITERS = "\""

SL_COMMENT = "#"

ML_COMMENT = "/* */"

IGNORECASE = True

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
