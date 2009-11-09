# -*- coding: UTF-8 -*-
# DOS Batch script language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''do else end errorlevel exist exit for goto if not pause return
say select then when'''

KW_LIST['kwb'] = '''ansi append assign attrib autofail backup basedev boot break
buffers cache call cd chcp chdir chkdsk choice cls cmd codepage command comp
copy country date ddinstal debug del detach device devicehigh devinfo dir
diskcoache diskcomp diskcopy doskey dpath dumpprocess eautil endlocal erase
exit_vdm extproc fcbs fdisk fdiskpm files find format fsaccess fsfilter
graftabl iopl join keyb keys label lastdrive libpath lh loadhigh makeini
maxwait md mem memman mkdir mode move net patch path pauseonerror picview
pmrexx print printmonbufsize priority priority_disk_io prompt protectonly
protshell pstat rd recover reipl ren rename replace restore rmdir rmsize run
set setboot setlocal shell shift sort spool start subst suppresspopups swappath
syslevel syslog threads time timeslice trace tracebuf tracefmt trapdump tree
type undelete unpack use ver verify view vmdisk vol xcopy xcopy32 xdfcopy'''

STRINGDELIMITERS = "\""

SL_COMMENT = "rem REM Rem"

IGNORECASE = True

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
