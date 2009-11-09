# -*- coding: UTF-8 -*-
# IO language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''activate activeCoroCount and block break catch
chedulerSleepSeconds clone collectGarbage compileString continue do doFile
doMessage doString else elseif exit for foreach forward getSlot getenv hasSlot
if ifFalse ifNil ifTrue isActive isNil list message method or parent pass
pause perform performWithArgList print proto raise removeSlot resend resume
return self sender setSchedulerSleepSeconds setSlot shallowCopy slotNames
super system then thisBlock thisContext thisMessage try type uniqueId
updateSlot wait write yield'''

KW_LIST['kwb'] = '''Array AudioDevice AudioMixer Block Box Buffer CFunction CGI
Color Curses DBM DNSResolver DOConnection DOProxy DOServer Date Directory
Duration DynLib Error Exception FFT File Fnmatch Font Future GL GLE GLScissor
GLU GLUCylinder GLUQuadric GLUSphere GLUT Host Image Importer LinkList List
Lobby Locals MD5 MP3Decoder MP3Encoder Map Message Movie NULL Nil Nop
Notification Number Object OpenGL Point Protos Regex SGMLTag SQLite Server
ShowMessage SleepyCat SleepyCatCursor Socket SocketManager Sound Soup Store
String Tree UDPSender UPDReceiver URL User Warning WeakLink'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS = "\"\"\" \'\'\' \" \'"

SL_COMMENT = "# //"

ML_COMMENT = "/* */"

ALLOWNESTEDCOMMENTS = False

IGNORECASE = False

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / * %  + - ^ @ ."
