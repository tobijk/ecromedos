# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, shutil
import lxml.etree as etree
from net.ecromedos.error import ECMDSPluginError

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        self.target_format = config.get('target_format', 'html')
        self.data_dir = config.get('data_dir', '')
        self.has_math = False
    #end function

    def process(self, node, format):
        """Prepare @node for target @format."""

        if format.endswith("latex"):
            result = self.LaTeX_ProcessMath(node)
        else:
            result = self.HTML_ProcessMath(node)
        #end if

        return result
    #end function

    def flush(self):
        """Copy KaTeX files to output directory for HTML."""

        if self.has_math and not self.target_format.endswith("latex"):
            self.__copyKaTeXFiles()
        #end if

        self.has_math = False
    #end function

    def LaTeX_ProcessMath(self, node):
        """Mark node, to be copied 1:1 to output document."""

        math_node = etree.Element("m")

        parent = node.getparent()
        math_node.tail = node.tail
        parent.replace(node, math_node)

        node.tag = "copy"
        node.tail = ""
        math_node.append(node)

        return math_node
    #end function

    def HTML_ProcessMath(self, node):
        """Wrap formula in KaTeX delimiters for client-side rendering."""

        if not self.has_math:
            self.has_math = True
            root = node.getroottree().getroot()
            root.attrib["katex"] = "yes"
        #end if

        formula = node.text or ""
        parent = node.getparent()
        is_block = (parent is not None and parent.tag == "equation")

        if is_block:
            delimited = "\\[" + formula + "\\]"
        else:
            delimited = "\\(" + formula + "\\)"
        #end if

        copy_node = etree.Element("copy")
        copy_node.text = delimited
        copy_node.tail = node.tail
        parent.replace(node, copy_node)

        return copy_node
    #end function

    # PRIVATE

    def __copyKaTeXFiles(self):
        """Copy bundled KaTeX files to output directory."""

        katex_src = os.path.join(self.data_dir, "katex")
        katex_dst = "katex"

        if not os.path.isdir(katex_src):
            return
        #end if

        if os.path.isdir(katex_dst):
            shutil.rmtree(katex_dst)
        #end if

        shutil.copytree(katex_src, katex_dst)
    #end function

#end class
