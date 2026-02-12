#!/usr/bin/env python3
#-*- encoding: utf-8 -*-

import os, sys, tempfile, unittest
import lxml.etree as etree

ECMDS_INSTALL_DIR = os.path.normpath(os.path.join(
    os.path.dirname(os.path.realpath(sys.argv[0])),
    "..", ".."
))

sys.path.insert(1, ECMDS_INSTALL_DIR + os.sep + 'lib')

from net.ecromedos.error import ECMDSPluginError
import net.ecromedos.plugins.verbatim as verbatim

class UTTestPluginText(unittest.TestCase):

    def test_processVerbatimTagHTML(self):
        content = """
<root>
    <verbatim><![CDATA[
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
\tprintf("Hello World!\n");
}
    ]]></verbatim>
</root>
"""
        root = etree.fromstring(content)

        plugin = verbatim.getInstance({})
        plugin.process(root.find('./verbatim'), "html")
        plugin.flush()

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree)

        expected_result = b'<root>\n    <verbatim>\n#include &lt;stdlib.h&gt;\n#include &lt;stdio.h&gt;\n\nint main(int argc, char *argv[])\n{\n    printf("Hello World!\n");\n}\n    </verbatim>\n</root>'

        self.assertEqual(result, expected_result)
    #end function

    def test_processVerbatimTagLatex(self):
        content = """
<root>
    <verbatim><![CDATA[
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
\tprintf("Hello World!\n");
}
    ]]></verbatim>
</root>
"""
        root = etree.fromstring(content)

        plugin = verbatim.getInstance({})
        plugin.process(root.find('./verbatim'), "latex")
        plugin.flush()

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree)

        expected_result = b'<root>\n    <verbatim>\n\\#{}include &lt;stdlib.h&gt;\n\\#{}include &lt;stdio.h&gt;\n\nint main(int argc, char *argv{[}{]})\n\\{{}\n    printf({}{"}{}Hello World{}{!}{}\n{}{"}{}){}{;}{}\n\\}{}\n    </verbatim>\n</root>'

        self.assertEqual(result, expected_result)
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
