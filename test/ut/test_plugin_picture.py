#!/usr/bin/env python3
#-*- encoding: utf-8 -*-

import os, sys, tempfile, unittest
import lxml.etree as etree

ECMDS_INSTALL_DIR = os.path.normpath(os.path.join(
    os.path.dirname(os.path.realpath(sys.argv[0])),
    "..", ".."
))

ECMDS_TEST_DATA_DIR = os.path.join(
        ECMDS_INSTALL_DIR,
        "test",
        "ut",
        "data",
        "plugin_picture"
)

sys.path.insert(1, ECMDS_INSTALL_DIR + os.sep + 'lib')

from net.ecromedos.error import ECMDSPluginError
import net.ecromedos.plugins.picture as picture

class UTTestPluginPicture(unittest.TestCase):

    def test_gracefulFailOnFileNotFound(self):
        tree = etree.parse(ECMDS_TEST_DATA_DIR + os.sep + "no_such_img_file.xml")
        root = tree.getroot()

        with tempfile.TemporaryDirectory() as tmpdir:
            config = {
                "latex_bin":    "/usr/bin/latex",
                "dvipng_bin":   "/usr/bin/dvipng",
                "convert_bin":  "/usr/bin/convert",
                "identify_bin": "/usr/bin/identify",
                "tmp_dir":      tmpdir
            }

            plugin = picture.getInstance(config)

            try:
                plugin.process(root.find("./img"), "xhtml")
            except ECMDSPluginError as e:
                self.assertTrue(e.msg().startswith(
                    "Could not find bitmap file at location"))
        #end with
    #end function

    def test_targetPDFLatexEPStoPDF(self):
        tree = etree.parse(ECMDS_TEST_DATA_DIR + os.sep + "ecromedos_eps.xml")
        root = tree.getroot()

        with tempfile.TemporaryDirectory() as tmpdir:
            config = {
                "latex_bin":    "/usr/bin/latex",
                "dvipng_bin":   "/usr/bin/dvipng",
                "convert_bin":  "/usr/bin/convert",
                "identify_bin": "/usr/bin/identify",
                "tmp_dir":      tmpdir
            }

            plugin = picture.getInstance(config)
            plugin.process(root.find("./img"), "pdflatex")
            plugin.flush()
        #end with

        os.unlink("img000001.pdf")
    #end function

    def test_targetLatexIMGtoEPS(self):
        tree = etree.parse(ECMDS_TEST_DATA_DIR + os.sep + "ecromedos_png.xml")
        root = tree.getroot()

        with tempfile.TemporaryDirectory() as tmpdir:
            config = {
                "latex_bin":    "/usr/bin/latex",
                "dvipng_bin":   "/usr/bin/dvipng",
                "convert_bin":  "/usr/bin/convert",
                "identify_bin": "/usr/bin/identify",
                "tmp_dir":      tmpdir
            }

            plugin = picture.getInstance(config)
            plugin.process(root.find("./img"), "latex")
            plugin.flush()
        #end with

        os.unlink("img000001.eps")
    #end function

    def test_targetXHTMLSetScreenWidth(self):
        tree = etree.parse(ECMDS_TEST_DATA_DIR + os.sep + "ecromedos_png_explicit_width.xml")
        root = tree.getroot()

        with tempfile.TemporaryDirectory() as tmpdir:
            config = {
                "latex_bin":    "/usr/bin/latex",
                "dvipng_bin":   "/usr/bin/dvipng",
                "convert_bin":  "/usr/bin/convert",
                "identify_bin": "/usr/bin/identify",
                "tmp_dir":      tmpdir
            }

            plugin = picture.getInstance(config)
            plugin.process(root.find("./img"), "xhtml")
            plugin.flush()
        #end with

        os.unlink("img000001.png")
    #end function

    def test_targetXHTMLIdentifyWidth(self):
        tree = etree.parse(ECMDS_TEST_DATA_DIR + os.sep + "ecromedos_png.xml")
        root = tree.getroot()

        with tempfile.TemporaryDirectory() as tmpdir:
            config = {
                "latex_bin":    "/usr/bin/latex",
                "dvipng_bin":   "/usr/bin/dvipng",
                "convert_bin":  "/usr/bin/convert",
                "identify_bin": "/usr/bin/identify",
                "tmp_dir":      tmpdir
            }

            plugin = picture.getInstance(config)
            plugin.process(root.find("./img"), "xhtml")
            plugin.flush()
        #end with

        os.unlink("img000001.png")
    #end function

    def test_targetXHTMLEPStoIMG(self):
        tree = etree.parse(ECMDS_TEST_DATA_DIR + os.sep + "ecromedos_eps.xml")
        root = tree.getroot()

        with tempfile.TemporaryDirectory() as tmpdir:
            config = {
                "latex_bin":    "/usr/bin/latex",
                "dvipng_bin":   "/usr/bin/dvipng",
                "convert_bin":  "/usr/bin/convert",
                "identify_bin": "/usr/bin/identify",
                "tmp_dir":      tmpdir
            }

            plugin = picture.getInstance(config)
            plugin.process(root.find("./img"), "xhtml")
            plugin.flush()
        #end with

        os.unlink("img000001.jpg")
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
