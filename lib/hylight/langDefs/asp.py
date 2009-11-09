# -*- coding: UTF-8 -*-
# ASP language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''and response write case select continue date dim server 
createobject do if else end empty then next set 
default movenext open close activeconnection false true BOF 
eof each for sub function len cstr include 
cdbl cdate is null object redirect request querystring exit 
clng redim session form not nothing loop while'''

STRINGDELIMITERS = "\""

SL_COMMENT = "'"

IGNORECASE = True

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
