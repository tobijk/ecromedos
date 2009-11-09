# -*- coding: UTF-8 -*-
# AppleScript language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''and as at beginning considering contain contains does div else end
equal error every exit first from get global greater if ignoring in is last local
me mod my not of on or property reopen repeat return script set tell than the then
to transaction try with without which while whose'''

KW_LIST['kwc'] = '''AppleScript access activate after alias application  ascending ASCII at
attached before box button buttons case cell cells character characters  choose class
close column columns content contents control controls copy count  current data date
day default delay delete delimiter descending desktop dialog  display document
documents domain duplicate enabled ends eof equal entry  entries exists false field
fields file files folder folders for icon icons indicator  indicators item items
length list load location localized make matrix menu menus  missing month months name
new number offset open order panel panels path popup  print process progress
properties quit read response row rows scroll select  selected selection sheet size
sort sorted source specification start starting  stop string table text title true
Unicode update user value visible view views  window windows write year years'''

STRINGDELIMITERS = "\""

SL_COMMENT = "--"

ML_COMMENT = "(* *)"

ALLOWNESTEDCOMMENTS = False

IGNORECASE = False

ESCCHAR = "\\"
