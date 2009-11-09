# -*- coding: UTF-8 -*-
# Coldfusion MX language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}
TAG_DELIM = {}

KW_LIST['kwa'] = '''3Dcfabort cfapplet cfapplication cfargument cfassociate cfbreak cfcache
cfcase cfcatch cfchart cfchartdata cfchartseries cfcol cfcollection  cfcomponent
cfcontent cfcookie cfdefaultcase cfdirectory cfdump cfelse cfelseif cferror cfexecute
cfexit cffile cfflush cfform cfftp cffunction cfgrid cfgridcolumn cfgridrow
cfgridupdate cfheader cfhtmlhead cfhttp cfhttpparam= cfif cfimport cfinclude cfindex
cfinput cfinsert cfinvoke cfinvokeargument cfldap cflocation cflock cflog cflogin
cfloginuser cflogout cfloop cfmail  cfmailparam cfmailpart cfmodule cfobject
cfobjectcache cfoutput cfparam cfpop cfprocessingdirective cfprocparam cfprocresult
cfproperty cfquery cfqueryparam cfregistry cfreport cfrethrow cfreturn cfsavecontent
cfschedule cfscript cfsearch cfselect cfset cfsetting cfsilent cfslider cfstoredproc
cfswitch cftable cftextinput cfthrow cftrace cftransaction cftree cftreeitem cftry
cfupdate cfwddx cfxml'''

STRINGDELIMITERS = "\" \'"

IGNORECASE = True

ALLOWNESTEDCOMMENTS = True

ML_COMMENT = "<!--- --->"

SL_COMMENT = "//"

TAG_DELIM['kwa'] = "< >"

KW_RE['kwb'] = "regex(#\\w+)"

SYMBOLS = "( ) [ ] { } , ; : & | !  = / *  %  + -"
