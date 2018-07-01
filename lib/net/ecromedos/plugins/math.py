# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, lxml, io, re, subprocess, tempfile
import lxml.etree as etree
from net.ecromedos.error import ECMDSPluginError

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        # init counter
        self.counter = 1
        self.nodelist = []

        # look for latex executable
        try:
            self.latex_bin = config['latex_bin']
        except KeyError:
            msg = "Location of the 'latex' executable unspecified."
            raise ECMDSPluginError(msg, "math")
        #end try

        if not os.path.isfile(self.latex_bin):
            msg = "Could not find latex executable '%s'." % (self.latex_bin,)
            raise ECMDSPluginError(msg, "math")
        #end if

        # look for conversion tool
        try:
            self.dvipng_bin = ""
            self.dvipng_bin = config['dvipng_bin']
        except KeyError:
            msg  = "Location of the 'dvipng' executable unspecified."
            raise ECMDSPluginError(msg, "math")
        #end try

        if not os.path.isfile(self.dvipng_bin):
            msg = "Could not find 'dvipng' executable '%s'." % (self.dvipng_bin,)
            raise ECMDSPluginError(msg, "math")
        #end if

        # temporary directory
        self.tmp_dir = config['tmp_dir']

        # conversion dpi
        try:
            self.dvipng_dpi = config['dvipng_dpi']
        except KeyError:
            self.dvipng_dpi = "100"
        #end try

        # output document
        self.out = io.StringIO()
    #end function

    def process(self, node, format):
        """Prepare @node for target @format."""

        if format.endswith("latex"):
            result = self.LaTeX_ProcessMath(node)
        else:
            result = self.XHTML_ProcessMath(node)
        #end if

        return result
    #end function

    def flush(self):
        """If target format is XHTML, generate GIFs from formulae."""

        # generate bitmaps of formulae
        if self.out.tell() > 0:
            self.out.write("\\end{document}\n")
            self.__LaTeX2Dvi2Gif()
            self.out.close()
            self.out = io.StringIO()
        #end if

        #reset counter
        self.counter = 1
        self.nodelist = []
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

    def XHTML_ProcessMath(self, node):
        """Call LaTeX and ImageMagick to produce a GIF."""

        if self.out.tell() == 0:
            self.out.write("""\
\\documentclass[12pt]{scrartcl}\\usepackage{courier}
\\usepackage{courier}
\\usepackage{helvet}
\\usepackage{mathpazo}
\\usepackage{amsmath}
\\usepackage[active,displaymath,textmath]{preview}
\\frenchspacing{}
\\usepackage{ucs}
\\usepackage[utf8x]{inputenc}
\\usepackage[T1]{autofe}
\\PrerenderUnicode{äöüß}
\\pagestyle{empty}
\\begin{document}""")
        #end if

        # save TeX markup
        #formula = etree.tostring(node, method="text", encoding="unicode")

        # give each formula one page
        self.out.write("$%s$\n\\clearpage{}\n" % node.text)

        copy_node = etree.Element("copy")
        img_node  = etree.Element("img")

        img_node.attrib["src"]   = "m%06d.gif" % (self.counter,)
        img_node.attrib["alt"]   = "formula"
        img_node.attrib["class"] = "math"

        copy_node.tail = node.tail
        copy_node.append(img_node)
        copy_node.tail = node.tail
        node.getparent().replace(node, copy_node)

        # keep track of images for flush
        self.nodelist.append(img_node)
        self.counter += 1

        return copy_node
    #end function

    # PRIVATE

    def __LaTeX2Dvi2Gif(self):
        """Write formulae to LaTeX file, compile and extract images."""

        # open a temporary file for TeX output
        tmpfp, tmpname = tempfile.mkstemp(suffix=".tex", dir=self.tmp_dir)

        try:
            with os.fdopen(tmpfp, "w", encoding="utf-8") as texfile:
                texfile.write(self.out.getvalue())
        except IOError:
            msg = "Error while writing temporary TeX file."
            raise ECMDSPluginError(msg, "math")
        #end try

        # compile LaTeX file
        with open(os.devnull, "wb") as devnull:
            cmd = [self.latex_bin, "-interaction", "nonstopmode", tmpname]

            # run LaTeX twice
            for i in range(2):
                proc = subprocess.Popen(cmd, stdout=devnull, stderr=devnull,
                        cwd=self.tmp_dir)
                rval = proc.wait()

                # test exit code
                if rval != 0:
                    msg = "Could not compile temporary TeX file."
                    raise ECMDSPluginError(msg, "math")
                #end if
            #end if
        #end with

        # determine dvi file name
        dvifile = self.tmp_dir + os.sep + \
            ''.join(tmpname.split(os.sep)[-1].split('.')[:-1]) + ".dvi"

        # we need to log the output
        logfp, logname = tempfile.mkstemp(suffix=".log", dir=self.tmp_dir)

        # convert dvi file to GIF image
        with os.fdopen(logfp, "w", encoding="utf-8") as dvilog:
            cmd = [self.dvipng_bin, "-D", self.dvipng_dpi, "--depth",
                    "-gif", "-T", "tight", "-o", "m%06d.gif", dvifile]

            proc = subprocess.Popen(cmd, stdout=dvilog, stderr=dvilog)
            rval = proc.wait()

            # test exit code
            if rval != 0:
                msg = "Could not convert dvi file to GIF images."
                raise ECMDSPluginError(msg, "math")
            #end if
        #end with

        # read dvipng's log output
        try:
            with open(logname, "r", encoding="utf-8") as logfp:
                string = logfp.read()
        except IOError:
            msg = "Could not read dvipng's log output from '%s'" % logname
            raise ECMDSPluginError(msg, "math")
        #end try

        # look for [??? depth=???px]
        rexpr = re.compile("\\[[0-9]* depth=[0-9]*\\]")

        # add style property to node
        i = 0
        for match in rexpr.finditer(string):
            align = match.group().split("=")[1].strip(" []")
            node = self.nodelist[i]
            node.attrib["style"] = "vertical-align: -" + align + "px;"
            i += 1
        #end for
    #end function

#end class
