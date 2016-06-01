# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, sys, re
from net.ecromedos.error import ECMDSConfigError

class ECMDSConfigReader():

    def __init__(self):
        self.config = None
        self.pmap = {}
    #end function

    def readConfig(self, options):
        """Read configuration files."""

        self.readConfigFile(options)
        self.readPluginsMap()

        return self.config, self.pmap
    #end function

    def readConfigFile(self, options={}):
        """Read config file and merge with user supplied options."""

        cfile = None

        # path to config file
        if "config_file" in options:
            cfile = os.path.normpath(options["config_file"])
        elif "install_dir" in options:
            syspath = os.path.normpath(options["install_dir"])
            cfile = os.path.join(syspath, "etc", "ecmds.conf")
        #end if

        if not (cfile and os.path.isfile(cfile)):
            msg = "Please specify the location of the config file."
            raise ECMDSConfigError(msg)
        #end if

        # some hard-coded defaults
        config = {
            "target_format" : "xhtml",
            "do_validate"   : True
        }

        # open file
        try:
            with open(cfile, "rt", encoding="utf-8") as fp:
                # parse the file
                lineno = 1
                for line in fp:
                    line = line.strip()
                    if line and not line.startswith('#'):
                        key, value = self.__processConfigLine(line, lineno)
                        config[key] = value
                    #end if
                    lineno += 1
                #end for
            #end with
        except Exception:
            msg = "Error processing config file '%s'." % (cfile,)
            raise ECMDSConfigError(msg)
        #end try

        # merge user supplied parameters
        for key, value in list(options.items()):
            config[key] = value
 
        # expand variables
        self.config = self.__replaceVariables(config)

        # init lib path
        self.__initLibPath()

        return self.config
    #end function

    def readPluginsMap(self):
        """Read plugins map."""

        if not self.config:
            self.readConfigFile()

        cfile = None

        # path to config file
        if "plugins_map" in self.config:
            cfile = os.path.normpath(self.config["plugins_map"])
        elif "install_dir" in self.config:
            syspath = os.path.normpath(self.config["install_dir"])
            cfile = os.path.join(syspath, "etc", "plugins.conf")
        #end if

        if not (cfile and os.path.isfile(cfile)):
            sys.stderr.write("Warning: plugins map not found..\n")
            return False
        #end if

        pmap = {}

        # open file
        try:
            with open(cfile, "rt", encoding="utf-8") as fp:
                lineno = 1
                for line in fp:
                    line = line.strip()
                    if line and not line.startswith("#"):
                        key, value = self.__processPluginsMapLine(line, lineno)
                        pmap[key] = value
                    #end if
                    lineno += 1
                #end for
            #end with
        except Exception:
            msg = "Error processing plugins map file '%s'." % (pmap,)
            raise ECMDSConfigError(msg)
        #end try

        self.pmap = pmap
    #end function

    # PRIVATE

    def __processConfigLine(self, line, lineno):
        """Extract key, value from line."""

        try:
            key, value = [entry.strip() for entry in line.split('=', 1)]
        except Exception:
            msg = "Formatting error in config file on line %d" % (lineno,)
            raise ECMDSConfigError(msg)
        #end try

        return key, value
    #end function

    def __processPluginsMapLine(self, line, lineno):
        """extract node name and plugins list from line."""

        try:
            nname, plugins = line.split(":")
            nname = nname.strip()
            plugins = [p.strip() for p in plugins.split(",")]
        except Exception:
            msg = "Formatting error in plugins map on line %d" % (lineno,)
            raise ECMDSConfigError(msg)
        #end try

        return nname, plugins
    #end function

    def __replaceVariables(self, config):
        """Replace variables in config file definitions."""

        # if there is nothing, do nothing
        if not config: return config

        # create rexpr $param1|param2|...
        expr = "|".join([r"\$" + re.escape(key) for key in list(config.keys())])
        rexpr = re.compile(expr)

        def sub(match):
            return config[match.group()[1:]]
        #end inline function

        while True:
            # continue until there are no more substitutions
            subst_performed = False

            for key, value in list(config.items()):
                if type(value) == str:
                    config[key] = rexpr.sub(sub, value)
                    if value != config[key]:
                        subst_performed = True
                #end if
            #end for

            if not subst_performed:
                break
        #end while

        return config
    #end function

    def __normPaths(self, config):
        """Normalize all path names for current platform."""

        for key, value in list(config.items()):
            if key.endswith("_bin") or key.endswith("_dir"):
                config[key] = os.path.normpath(value)
        #end for

        return config
    #end function

    def __initLibPath(self):
        """Initialize library path."""

        try:
            lib_dir = self.config['lib_dir']
        except KeyError:
            return

        if not lib_dir in sys.path:
            sys.path.insert(1, lib_dir)
        #end if
    #end function

#end class

