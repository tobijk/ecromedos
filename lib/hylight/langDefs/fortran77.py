# -*- coding: UTF-8 -*-
# Fortran 77 language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

IGNORECASE = True

STRINGDELIMITERS = "\" \'"

SL_COMMENT = "regex(^[cC].*)"

IDENTIFIER = "regex([a-zA-Z_][\\w\\d\\*]*)"

KW_LIST['kwb'] = '''character  complex  double  precision  real  real*8  integer  common  logical
implicit  dimension  external  parameter'''

KW_LIST['kwa'] = '''break  common  continue  date  default  dimension  do  else  enddo  endif  for
goto  go  to  if  then  return  end  format  write  read  subroutine  function  switch
program  call  while'''

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
