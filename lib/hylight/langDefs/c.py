# -*- coding: UTF-8 -*-
# C/C++ language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''goto break return continue asm case default if else switch while for do sizeof
typeof  stdcall cdecl const_cast delete dynamic_cast   goto  namespace new  pascal
reinterpret_cast  static_cast  this throw try catch using true false bitand and bitor or xor
compl and_eq or_eq xor_eq not not_eq'''

KW_LIST['kwb'] = '''int long short char void signed unsigned float double size_t wchar_t
ptrdiff_t  sig_atomic_t fpos_t clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t static
const bool struct union enum size_t wchar_t ptrdiff_t sig_atomic_t fpos_t clock_t time_t
va_list jmp_buf FILE DIR div_t ldiv_t mbstate_t wctrans_t wint_t wctype_t bool complex
int8_t int16_t int32_t int64_t uint8_t uint16_t uint32_t uint64_t int_least8_t int_least16_t
int_least32_t int_least64_t uint_least8_t uint_least16_t uint_least32_t uint_least64_t
int_fast8_t int_fast16_t int_fast32_t int_fast64_t uint_fast8_t uint_fast16_t uint_fast32_t
uint_fast64_t intptr_t uintptr_t intmax_t uintmax_t'''

KW_LIST['kwc'] = '''typedef inline auto class explicit extern friend inline mutable operator
register template private protected public typeid virtual volatile'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS="\" '"

SL_COMMENT="//"

ML_COMMENT="/* */"

ALLOWNESTEDCOMMENTS = True

IGNORECASE = False

DIRECTIVE = "#"

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; . : & | < > !  = / *  %  + - ~"

CONTINUATIONSYMBOL = "\\"
