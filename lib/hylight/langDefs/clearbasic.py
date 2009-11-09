# -*- coding: UTF-8 -*-
# ClearBasic language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''and as byref byval case declare dim else elseif end for function
global if me not new next or select set step sub then to type while aix
dodefault false hpux irix linux mac68k macppc macintosh netware nothing null
os2 osf1 pi sco solaris sunos true unix ultrix unixware vms win16 win32
cbabortretryignore cbascending cbbyref cbbyvalue cbclosechildren cbclosemessage
cbdefclosedwindow cbdefclosedwindow cbdescending cbequal cbfirstmessage
cbfrontifup cbgreater cbgreaterorequal cbidabort cbidcancel cbiddiscard
cbidignore cbidno cbidok cbidretry cbidsave cbidyes cbin cbless cblessorequal
cblike cbnodefault cbnotequal cbnotlike cbok cbokcancel cbrefreshmessage
cbretrycancel cbsavediscardcancel cbsoundslike cbyesno cbyesnocancel ebaix
ebabort ebabortretryignore ebapplicationmodal ebarchive ebarray ebback ebbold
ebbolditalic ebboolean ebcfbitmap ebcfdib ebcfmetafile ebcfpalette ebcftext
ebcfunicode ebcancel ebcr ebcrlf ebcritical ebcurrency ebdos ebdataobject
ebdate ebdefaultbutton1 ebdefaultbutton2 ebdefaultbutton3 ebdirectory ebdouble
ebempty eberror ebexclamation ebfirstfourdays ebfirstfullweek ebfirstjan1
ebformfeed ebfriday ebfromunicode ebhpux ebhidden ebhide ebhiragana
ebimealphadbl ebimealphasng ebimedisabled ebimehiragana ebimekatakanadbl
ebimekatakanasng ebimenoop ebimeoff ebimeon ebignore ebinformation ebinteger
ebirix ebitalic ebkatakana eblinux eblandscape ebleftbutton eblf eblong
eblowercase ebmacintosh ebmaximized ebmaximizedfocus ebminimized
ebminimizedfocus ebminimizednofocus ebmonday ebnarrow ebnetware ebno ebnone
ebnormal ebnormalfocus ebnormalnofocus ebnull ebnullchar ebnullstring ebok
ebokcancel ebokonly ebos2 ebosf1 ebobject ebportrait ebpropercase ebquestion
ebreadonly ebregular ebrestored ebretry ebretrycancel ebrightbutton ebsco
ebsaturday ebsingle ebsolaris ebstring ebsunos ebsunday ebsystem ebsystemmodal
ebtab ebthursday ebtuesday ebultrix ebunicode ebunixware ebuppercase ebvms
ebvariant ebverticaltab ebvolume ebwednesday ebwide ebwin16 ebwin32 ebwindows
ebyes ebyesno ebyesnocancel'''

KW_LIST['kwb'] = '''app appmenu basic bool boolean bulkretrieve bulksave clarifydb
clipboard commondialog contextualobject control dde debug err form integer list
long msg net powerquery printer record sqldb screen servicemessage string'''

STRINGDELIMITERS = "\""

SL_COMMENT = "'"

ML_COMMENT = "/* */"

IGNORECASE = True

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"




