# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, shutil
from net.ecromedos.error import ECMDSPluginError

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        try:
            self.data_dir = config['data_dir']
        except KeyError:
            msg = "Path to data directory not specified."
            raise ECMDSPluginError(msg, "data")
        #end try

        # check if directory exists
        if not os.path.isdir(self.data_dir):
            msg = "Data directory '%s' does not exist." % self.data_dir
            raise ECMDSPluginError(msg, "data")
        #end if

        self.__filelist = []
    #end function

    def process(self, node, format):
        """Prepare node for target format."""

        if format == "xhtml" and node.attrib.get("secsplitdepth", '0') != '0':
            self.__filelist = ["next.gif", "prev.gif", "up.gif"]
        #end if

        return node
    #end function

    def flush(self):
        """Copy static assets, such as the icons, to output directory."""

        for fname in self.__filelist:
            src = None
            dst = None
            try:
                try:
                    src = open(os.path.join(self.data_dir, fname), "rb")
                    dst = open(fname, "wb+")
                    shutil.copyfileobj(src, dst)
                finally:
                    if src: src.close()
                    if dst: dst.close()
                #end try
            except Exception:
                msg = "Error while copying file '%s' to output directory." % fname
                raise ECMDSPluginError(msg, "data")
            #end try
        #end for

        self.__filelist = []
    #end function

#end class
