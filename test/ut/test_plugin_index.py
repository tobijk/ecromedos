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
import net.ecromedos.plugins.index as index

class UTTestPluginIndex(unittest.TestCase):

    def test_collectIdxtermsAndBuildIndex(self):
        idxterms = [
"""
<root>
<idxterm>
    <item>Z Item</item>
        <subitem>A ab</subitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>A Item</item>
        <subitem>A Item 1 Sub</subitem>
            <subsubitem>A Item 1 Sub I Subb</subsubitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>AA Item</item>
        <subitem>AA Item 2 Sub</subitem>
            <subsubitem>AA Item 2 Sub I Subb</subsubitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>X Item</item>
        <subitem>X Item 1 Sub</subitem>
            <subsubitem>X Item 1 Sub I Subb</subsubitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>Z Item</item>
        <subitem>A aa</subitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>A Item</item>
        <subitem>A Item 1 Sub</subitem>
            <subsubitem>A Item 1 Sub I Subb</subsubitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>Y Item</item>
        <subitem>Y Item 1 Sub</subitem>
</idxterm>
</root>
""",
"""
<root>
<idxterm>
    <item>Z Item</item>
</idxterm>
</root>
""",
        ]

        plugin = index.getInstance({})

        for term in idxterms:
            idxterm_root = etree.fromstring(term)
            plugin.process(idxterm_root.find("./idxterm"), "xhtml")
        #end for

        index_node = etree.fromstring('''<make-index
                alphabet="[S y m b o l e],A,B,C,G,Z"
                locale="de_DE.UTF-8"/>''')
        plugin.process(index_node, "xhtml")

        tree = etree.ElementTree(element=index_node)
        result = etree.tostring(tree, pretty_print=True, encoding="unicode")

        expected_result = """
<index alphabet="[S y m b o l e],A,B,C,G,Z" locale="de_DE.UTF-8" columns="2">
  <idxsection name="S y m b o l e"/>
  <idxsection name="A">
    <item>AA Item</item>
    <subitem>AA Item 2 Sub</subitem>
    <subsubitem>AA Item 2 Sub I Subb <idxref idref="idx:item000002"/></subsubitem>
    <item>A Item</item>
    <subitem>A Item 1 Sub</subitem>
    <subsubitem>A Item 1 Sub I Subb <idxref idref="idx:item000001"/>, <idxref idref="idx:item000005"/></subsubitem>
  </idxsection>
  <idxsection name="B"/>
  <idxsection name="C"/>
  <idxsection name="G">
    <item>X Item</item>
    <subitem>X Item 1 Sub</subitem>
    <subsubitem>X Item 1 Sub I Subb <idxref idref="idx:item000003"/></subsubitem>
    <item>Y Item</item>
    <subitem>Y Item 1 Sub <idxref idref="idx:item000006"/></subitem>
  </idxsection>
  <idxsection name="Z">
    <item>Z Item <idxref idref="idx:item000007"/></item>
    <subitem>A aa <idxref idref="idx:item000004"/></subitem>
    <subitem>A ab <idxref idref="idx:item000000"/></subitem>
  </idxsection>
</index>
"""
        self.assertEqual(result.strip(), expected_result.strip())
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
