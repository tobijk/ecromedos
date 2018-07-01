# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

from lxml import etree

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        pass
    #end function

    def flush(self):
        pass
    #end function

    def process(self, node, format):
        """Prepare @node for target @format."""
        node.attrib["final"] = "yes"
        return node
    #end function

#end class
