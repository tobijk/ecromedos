# -*- coding: UTF-8 -*-
# Javascript language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''abstract break class const continue debugger default
delete enum export extends  finally  instanceof import implements in goto
native package private protected public super   throw throws transient
typeof void false with for this switch try while if do else return null case catch true
 new prototype var function'''

KW_LIST['kwb'] = '''boolean byte char double float int long short static'''

KW_LIST['kwc'] = '''charCodeAt  String substring length split Array charAt Boolean indexOf
fromCharCode push Object Null Number isNaN blur focus click checked defaultChecked
enabled getDate getDay getFullYear getHours getMilliseconds getMinutes getMonth getSeconds
getTime getTimezoneOffset getYear getUTCDate getUTCDay getUTCFullYear getUTCHours
getUTCMilliseconds getUTCMinutes getUTCMonth getUTCSeconds
getUTCTime getUTCYear setDate setFullYear setHours setMilliseconds setMinutes setMonth
setSeconds setTime setYear toGMTString toLocaleString UTC setUTCDate setUTCFullYear
setUTCHours setUTCMilliseconds setUTCMinutes setUTCMonth setUTCSeconds setUTCTime
setUTCYear alinkColor all anchors applets bgColor classes cookie domain embeds fgColor ids
lastModified layers linkColor links location referrer tags title URL vlinkColor clear close getSelection
open onKeyPress onUnLoad onChange onchange encoding method reset submit frames parent self
top window alert confirm clearInterval clearTimeout print prompt setInterval setTimeout onMove
onmove onResize onresize visibility replace hash host href pathname port protocol reload toString
Math E LN10 LN2 PI SQRT1_2 SQRT2 sqrt pow log exp cos sin tan acos asin atan round floor ceil
random min max navigator appCodeName appName appVersion language mimeTypes platform
plugins userAgent javaEnabled Option option defaultSelected index text innerHTML RegExp global
ignoreCase input lastIndex lastMatch lastParen leftContext multiline rightContext source compile
exec test screen availHeight availWidth colorDepth height pixelDepth width options selectedIndex
big blink bold fixed fontColor history current next previous back forward go charCode getElementById
getElementByName document write writeln forms elements value image images Image border complete
height hspace lowsrc name src vspace width className onclick onClick onDblClick ondblclick onMouseOut
onMouseOver Array concat join reverse pop push slice sort unescape target event type top location
unescape break default onBlur onblur onFocus onfocus isNaN handleEvent onAbort onError onKeyPress
onKeyUp onKeyDown onLoad onload handleEvent fontSize indexOf italics lastIndexOf match search
small strike sub substr substring sup toLowerCase toUpperCase'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

SL_COMMENT = "//"

ML_COMMENT = "/* */"

STRINGDELIMITERS = "\" \'"

IGNORECASE = False

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / * %  + - ."
