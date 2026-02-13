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
import net.ecromedos.plugins.math as math

class UTTestPluginMath(unittest.TestCase):

    def test_handleMathNodeLatex(self):
        root = etree.fromstring("<root><m>Formula Here</m></root>")

        config = {
            "target_format": "lualatex"
        }

        plugin = math.getInstance(config)
        plugin.process(root.find("./m"), "lualatex")

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree, encoding="utf-8", method="xml")

        expected_result = b'<root><m><copy>Formula Here</copy></m></root>'
        self.assertEqual(result, expected_result)
    #end function

    def test_handleMathNodeHTML(self):
        root = etree.fromstring("<root><p><m>Formula Here</m></p></root>")

        config = {
            "target_format": "html"
        }

        plugin = math.getInstance(config)
        plugin.process(root.find(".//m"), "html")

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree, encoding="utf-8", method="xml")

        expected_result = b'<root katex="yes"><p><copy>\\(Formula Here\\)</copy></p></root>'
        self.assertEqual(result, expected_result)
    #end function

    def test_handleMathNodeHTMLBlock(self):
        root = etree.fromstring(
            "<root><equation><m>E = mc^2</m></equation></root>"
        )

        config = {
            "target_format": "html"
        }

        plugin = math.getInstance(config)
        plugin.process(root.find(".//m"), "html")

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree, encoding="utf-8", method="xml")

        expected_result = b'<root katex="yes"><equation><copy>\\[E = mc^2\\]</copy></equation></root>'
        self.assertEqual(result, expected_result)
    #end function

    def test_htmlModeNoLatexRequired(self):
        """Verify that HTML mode does not require latex or dvipng binaries."""
        config = {
            "target_format": "html"
        }

        plugin = math.getInstance(config)
        self.assertIsNotNone(plugin)
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
