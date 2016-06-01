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
import net.ecromedos.plugins.final as final

class UTTestPluginFinal(unittest.TestCase):

    def test_markNodeAsFinal(self):
        expected_result = b'<root>\n    <p final="yes">Bla bla bla</p>\n</root>'

        code = """
<root>
    <p>Bla bla bla</p>
</root>
        """
        root = etree.fromstring(code)
        tree = etree.ElementTree(element=root)
        
        plugin = final.getInstance({})
        plugin.process(root.find("./p"), "xhtml")

        result = etree.tostring(tree, encoding="utf-8", method="xml")
        self.assertEqual(result, expected_result)
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
