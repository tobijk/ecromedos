# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import re

from pygments.formatter import Formatter
from xml.sax.saxutils import escape as xmlescape

class ECMLPygmentsFormatter(Formatter):

    def __init__(self, **options):
        Formatter.__init__(self, **options)
        self.__tstyle = dict(options['style'])
        try:
            self.__bgcolor = options['style'].background_color
        except AttributeError:
            self.__bgcolor = None
        #end try
        self.__emit_line_numbers = options['emit_line_numbers']
        self.__line_no = options['startline']
        self.__line_step = options['line_step']
        self.__output_format = options["output_format"]
        self.__new_line = True
    #end function

    def format(self, tokensource, outfile):
        if self.__bgcolor:
            outfile.write("<code bgcolor=\"#%s\">" % self.__bgcolor\
                .lower().lstrip('#'))
        else:
            outfile.write('<code>')
        #end if

        for ttype, tvalue in tokensource:
            while ttype not in self.__tstyle:
                ttype = ttype.parent
            #end while

            self.writeToken(ttype, tvalue, outfile)
        #end for

        outfile.write('</code>')
    #end function

    def writeToken(self, ttype, tvalue, outfile):
        if self.__emit_line_numbers or self.__output_format.endswith("latex"):
            lines = tvalue.splitlines(True)

            for line in lines:
                if self.__emit_line_numbers:
                    self.writeLineNo(self.__line_no, outfile)
                self.writeOpeningTags(ttype, outfile)
                outfile.write(xmlescape(line))
                self.writeClosingTags(ttype, outfile)

                if re.search(r"\r|(?:\r)?\n$", line):
                    self.__line_no += self.__line_step
                    self.__new_line = True
                #end if
            #end for
        else:
            self.writeOpeningTags(ttype, outfile)
            outfile.write(xmlescape(tvalue))
            self.writeClosingTags(ttype, outfile)
        #end if
    #end function

    def writeLineNo(self, line_no, outfile):
        if self.__new_line:
            outfile.write('<b>%04d</b> ' % line_no)
            self.__new_line = False
        #end if
    #end function

    def writeOpeningTags(self, ttype, outfile):
        style = self.__tstyle[ttype]

        if style['color']:
            outfile.write("<color rgb=\"#%s\">" % style['color']\
                .lower().lstrip('#'))
        if style['underline']:
            outfile.write('<u>')
        if style['italic']:
            outfile.write('<i>')
        if style['bold']:
            outfile.write('<b>')
    #end function

    def writeClosingTags(self, ttype, outfile):
        style = self.__tstyle[ttype]

        if style['bold']:
            outfile.write('</b>')
        if style['italic']:
            outfile.write('</i>')
        if style['underline']:
            outfile.write('</u>')
        if style['color']:
            outfile.write('</color>')
    #end function

#end class

