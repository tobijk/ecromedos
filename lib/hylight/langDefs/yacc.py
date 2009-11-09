# -*- coding: UTF-8 -*-
# BISON language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''error YYABORT YYACCEPT YYBACKUP YYERROR YYERROR_VERBOSE YYINITDEPTH YYLEX_PARAM 
YYLTYPE yyltype YYMAXDEPTH YYPARSE_PARAM YYRECOVERING YYSTACK_USE_ALLOCA YYSTYPE
yychar yyclearin yydebug yyerrok yyerror yylex yylval yylloc yynerrs yyparse'''

KW_RE['kwb'] = "regex(%\\S+)"

ML_COMMENT = "/* */"

IGNORECASE = False

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / * + -"
