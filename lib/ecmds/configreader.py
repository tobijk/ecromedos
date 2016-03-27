# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Date:    2009/11/15
#

# std includes
import os, sys, re

# ecmds includes
from ecmds.error import ECMDSError

class ECMDSCfgFileReader(object):

    def __init__(self):
        self.config = None
    #end function

    def __readLine(self, line, lineno):
        '''Extract key, value from line.'''

        try:
            key, value = line.split('=', 1)
            key   = key.strip()
            value = value.strip()
        except Exception:
            msg = "Formatting error in config file on line %d" % (lineno,)
            raise ECMDSError(msg)
        #end try

        return key, value
    #end function

    def __replaceVariables(self, config):
        '''Replace variables in config file definitions.'''

        # if there is nothing, do nothing
        if not config: return config

        # create rexpr $param1|param2|...
        expr = "|".join([r"\$" + re.escape(key) for key in config.keys()])
        rexpr = re.compile(expr)

        def sub(match):
            return config[match.group()[1:]]
        #end inline function

        while True:
            # continue until there are no more substitutions
            subst_performed = False

            for key, value in config.iteritems():
                if type(value) == str:
                    config[key] = rexpr.sub(sub, value)
                    if value != config[key]:
                        subst_performed = True
                #end if
            #end for

            if not subst_performed: break
        #end while
        
        return config
    #end function

    def __normPaths(self, config):
        '''Normalize all path names for current platform.'''

        for key, value in config.iteritems():
            if key.endswith("_bin") or key.endswith("_dir"):
                config[key] = os.path.normpath(value)
        #end for
        
        return config
    #end function

    def updateConfig(self, config, options):
        '''Merge user supplied configuration.'''

        for key, value in options.iteritems():
            config[key] = value
        #end for
        
        return config
    #end function

    def initLibPath(self):
        '''Initialize library path.'''
        
        try:
            lib_dir = self.config['lib_dir']
        except KeyError: return
        
        if not lib_dir in sys.path:
            sys.path.insert(1, lib_dir)
        #end if
    #end function

    def readConfigFile(self, options):
        '''Read config file and merge with user supplied options.'''

        # path to config file
        try:
            cfile = os.path.normpath(options['config_file'])
        except KeyError:
            syspath = os.path.normpath(sys.path[0])
            cfile = os.sep.join(["..", "etc", "ecmds.conf"])
            cfile = os.path.join(syspath, cfile)
            if not os.path.isfile(cfile):
                msg = "Please specify the location of the config file."
                raise ECMDSError(msg)
            #end if
        #end try

        # open file
        try:
            fp = file(cfile)
        except Exception:
            msg = "Could not open config file '%s'." % (cfile,)
            raise ECMDSError(msg)
        #end try

        # some hard-coded defaults
        config = {
            "target_format" : "xhtml",
            "do_validate"   : "yes"  }

        # parse the file
        lineno = 1
        for line in fp:
            line = line.strip()
            if line and not line.startswith('#'):
                key, value = self.__readLine(line, lineno)
                config[key] = value
            #end if
            lineno += 1
        #end for

        # merge user supplied parameters
        self.config = self.__normPaths(self.updateConfig(config, options))

        # expand variables
        config = self.__replaceVariables(config)

        # init lib path
        self.initLibPath()
    #end function

#end class

class ECMDSPluginsMapReader(object):

    def __init__(self):
        self.pmap = {}
    #end function

    def __readLine(self, line, lineno):
        '''extract node name and plugins list from line.'''

        try:
            nname, plugins = line.split(":")
            nname = nname.strip()
            plugins = [p.strip() for p in plugins.split(",")]
        except Exception:
            msg = "Formatting error in plugins map on line %d" % (lineno,)
            raise ECMDSError(msg)
        #end try
        
        return nname, plugins
    #end function

    def readPluginsMap(self, config):
        '''Read plugins map.'''
        
        # path to plugins map
        try:
            pmap = os.path.normpath(config['plugins_map'])
        except KeyError:
            syspath = os.path.normpath(sys.path[0])
            pmap = os.sep.join(["..", "etc", "plugins.conf"])
            pmap = os.path.join(syspath, pmap)
            if not os.path.isfile(pmap):
                msg = "Warning: plugins map not found."
                sys.stderr.write(msg + "\n")
                return False
            #end if
        #end try

        # open file
        try:
            fp = file(pmap)
        except Exception:
            msg = "Could not open plugins map file '%s'." % (pmap,)
            raise ECMDSError(msg)
        #end try

        pmap = {}
        lineno = 1
        for line in fp:
            line = line.strip()
            if line and not line.startswith("#"):
                key, value = self.__readLine(line, lineno)
                pmap[key] = value
            #end if
            lineno += 1
        #end for
        
        self.pmap = pmap
    #end function    

#end class

class ECMDSCfgManager(ECMDSCfgFileReader, ECMDSPluginsMapReader):

    def __init__(self):
        ECMDSCfgFileReader.__init__(self)
        ECMDSPluginsMapReader.__init__(self)
    #end function    

    def readConfig(self, options):
        '''Read configuration files.'''

        if self.config:
            self.updateConfig(options)
        else:
            self.readConfigFile(options)
        #end if

        if not self.pmap:
            self.readPluginsMap(self.config)
        #end if

    #end function

#end class

