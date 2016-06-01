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
import net.ecromedos.plugins.table as table

class UTTestPluginTable(unittest.TestCase):

    def test_setColSepOnColSpec(self):
        content = """
<table frame="top,bottom">
    <colgroup>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
    </colgroup>
    <tr>
        <td>13</td><td>14</td><td>15</td><td>16</td>
    </tr>
</table>
"""
        for col in range(4):
            root = etree.fromstring(content)

            root.find("./tr")[col].attrib["frame"] = "colsep"

            plugin = table.getInstance({})
            plugin.process(root, "xhtml")
            plugin.flush()

            tree = etree.ElementTree(element=root)
            result = etree.tostring(tree, encoding="utf-8").decode("utf-8")

            for i in range(4):
                frame = root.find("./colgroup")[i].attrib.get("frame", "")

                if i == col and i != 3:
                    self.assertTrue("colsep" in frame)
                else:
                    self.assertTrue("colsep" not in frame)
                #end if
            #end for
        #end for
    #end function

    def test_setColSepOnCellWithColspan(self):
        content = """
<table frame="top,bottom">
    <colgroup>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
    </colgroup>
    <tr>
        <td>13</td><td colspan="2" frame="colsep">15</td><td>16</td>
    </tr>
</table>
"""
        root = etree.fromstring(content)

        plugin = table.getInstance({})
        plugin.process(root, "xhtml")
        plugin.flush()

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree, encoding="utf-8").decode("utf-8")

        for i in range(4):
            frame = root.find("./colgroup")[i].attrib.get("frame", "")

            if i == 2:
                self.assertTrue("colsep" in frame)
            else:
                self.assertTrue("colsep" not in frame)
            #end if
        #end for
    #end function

    def test_setColSepOnRowWithColspan(self):
        content = """
<table frame="top,bottom">
    <colgroup>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
    </colgroup>
    <tr frame="colsep">
        <td>13</td><td colspan="2">15</td><td>16</td>
    </tr>
</table>
"""
        root = etree.fromstring(content)

        plugin = table.getInstance({})
        plugin.process(root, "xhtml")
        plugin.flush()

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree, encoding="utf-8").decode("utf-8")

        for i in range(4):
            frame = root.find("./colgroup")[i].attrib.get("frame", "")

            if i in [0, 2]:
                self.assertTrue("colsep" in frame)
            else:
                self.assertTrue("colsep" not in frame)
            #end if
        #end for
    #end function

    def test_setColSepOnTable(self):
        content = """
<table frame="top,bottom,colsep">
    <colgroup>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
    </colgroup>
    <tr>
        <td>13</td><td colspan="2">15</td><td>16</td>
    </tr>
</table>
"""
        root = etree.fromstring(content)

        plugin = table.getInstance({})
        plugin.process(root, "xhtml")
        plugin.flush()

        tree = etree.ElementTree(element=root)
        result = etree.tostring(tree, encoding="utf-8").decode("utf-8")

        for i in range(4):
            frame = root.find("./colgroup")[i].attrib.get("frame", "")

            if i in [0, 2]:
                self.assertTrue("colsep" in frame)
            else:
                self.assertTrue("colsep" not in frame)
            #end if
        #end for
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
