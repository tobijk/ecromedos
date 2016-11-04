#!/usr/bin/env python3
#-*- encoding: utf-8 -*-

import os, sys, unittest
import lxml.etree as etree

ECMDS_INSTALL_DIR = os.path.normpath(os.path.join(
    os.path.dirname(os.path.realpath(sys.argv[0])),
    "..", ".."
))

sys.path.insert(1, ECMDS_INSTALL_DIR + os.sep + 'lib')

from net.ecromedos.error import ECMDSPluginError
import net.ecromedos.plugins.highlight as highlight

class UTTestPluginHighlight(unittest.TestCase):

    def test_highlightCCode(self):
        expected_result = b'<root>\n    <code bgcolor="#fafafa" syntax="c" startline="13" linestep="3" colorscheme="default"><b>0013</b> <color rgb="#999999"><i><b>#</b></i></color><color rgb="#999999"><i><b>include</b></i></color> <color rgb="#999988"><i>&lt;stdlib.h&gt;</i></color><color rgb="#999999"><i><b>\n</b></i></color><b>0016</b> <color rgb="#999999"><i><b>#</b></i></color><color rgb="#999999"><i><b>include</b></i></color> <color rgb="#999988"><i>&lt;stdio.h&gt;</i></color><color rgb="#999999"><i><b>\n</b></i></color><b>0019</b> \n<b>0022</b> <color rgb="#445588"><b>int</b></color> <color rgb="#990000"><b>main</b></color>(<color rgb="#445588"><b>int</b></color> argc, <color rgb="#445588"><b>char</b></color> <color rgb="#000000"><b>*</b></color>argv[])\n<b>0025</b> {\n<b>0028</b>     printf(<color rgb="#dd1144">"</color><color rgb="#dd1144">Hello World!</color>\n<b>0031</b> <color rgb="#dd1144">"</color><color rgb="#dd1144">);</color>\n<b>0034</b>     <color rgb="#000000"><b>return</b></color> <color rgb="#009999">0</color>;\n<b>0037</b> }\n<b>0040</b>     \n</code>\n</root>'

        code = """
<root>
    <code syntax="c" startline="13" linestep="3" colorscheme="default"><![CDATA[
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("Hello World!\n");
    return 0;
}
    ]]></code>
</root>
        """

        root = etree.fromstring(code)
        tree = etree.ElementTree(element=root)

        plugin = highlight.getInstance({})
        plugin.process(root.find("./code"), "xhtml")

        result = etree.tostring(tree, encoding="utf-8", method="xml")

        self.assertEqual(result, expected_result)
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
