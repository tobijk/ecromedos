# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import re
from lxml import etree
import com.lepture.mistune as mistune

class ECMLRendererError(Exception):
    pass

class ECMLRenderer(mistune.Renderer):

    def __init__(self):
        mistune.Renderer.__init__(self)
        self.section_level = 0
    #end if

    # BLOCK ELEMENTS

    def block_code(self, code, language=None):
        if language == None:
            language = "none"

        return """<listing><code syntax="%(lang)s" strip="yes"
                tabspaces="4">%(code)s</code></listing>""" % {
            "lang": language,
            "code": mistune.escape(code)
        }
    #end function

    def block_quote(self, text):
        return "<blockquote>%s</blockquote>" % text
    #end function

    def block_html(self, ecml):
        return ecml
    #end function

    def header(self, text, level, raw=None):
        retval = ""

        diff = level - self.section_level

        if diff > 1:
            msg = "Heading '%s' skips a section level." % text
            raise ECMLRendererError(msg)
        else:
            sign = int(diff > 0) - int(diff < 0)
            diff = sign * diff

            # we close until we reach the new level
            if sign <= 0:
                for i in range(diff+1):
                    retval += "</section>"
            #end if
        #end if

        retval += '<section level="%d">' % level
        retval += '<title>%s</title>'    % text

        self.section_level = level
        return retval
    #end function

    def hrule(self):
        return ""
    #end function

    def list(self, body, ordered=True):
        if ordered:
            return "<ol>%s</ol>" % body
        else:
            return "<ul>%s</ul>" % body
    #end function

    def list_item(self, text):
        return "<li>%s</li>" % text
    #end function

    def paragraph(self, text):
        return "<p>%s</p>" % text
    #end function

    def table(self, header, body):
        return """\
        <table print-width="100%%" screen-width="800px">
            <thead>
                %s
            </thead>
            <tbody>
                %s
            </tbody>
        </table>""" % (header, body)
    #end function

    def table_row(self, content):
        return '<tr valign="top">%s</tr>' % content
    #end function

    def table_cell(self, content, **flags):
        align = flags['align']
        if not align:
            return '<td>%s</td>' % content
        return '<td align="%s">%s</td>' % (align, content)
    #end function

    # INLINE ELEMENTS

    def autolink(self, link, is_email=False):
        text = link = mistune.escape(link)
        if is_email:
            link = "mailto:%s" % link
        return '<link url="%s">%s</link>' % (link, link)
    #end function

    def codespan(self, text):
        return "<tt>%s</tt>" % mistune.escape(text)
    #end function

    def double_emphasis(self, text):
        return "<b>%s</b>" % text
    #end function

    def emphasis(self, text):
        return "<i>%s</i>" % text
    #end function

    def image(self, src, title, text):
        src  = escape_link(src, quote=True)
        text = escape(text, quote=True)

        if title:
            title = escape(title, quote=True)
            ecml = """\
                <figure>
                    <caption>%s</caption>
                    <img src="%s" print-width="100%" screen-width="600px"/>
                </figure>
            """ % (title, src)
        else:
            ecml = """\
                <figure>
                    <img src="%s" print-width="100%" screen-width="600px"/>
                </figure>
            """ % (src,)
        #end if

        return ecml
    #end function

    def linebreak(self):
        return "<br/>"
    #end function

    def newline(self):
        return ""
    #end function

    def link(self, link, title, text):
        link = escape_link(link, quote=True)
        return '<link url="%s">%s</a>' % (link, text)
    #end function

    def strikethrough(self, text):
        return text
    #end function

    def text(self, text):
        return mistune.escape(text)
    #end function

    def inline_html(self, ecml):
        return ecml
    #end function

#end class

class MarkdownConverterError(Exception):
    pass

class MarkdownConverter():

    DOCUMENT_TEMPLATE = """\
<!DOCTYPE report SYSTEM "http://www.ecromedos.net/dtd/3.0/ecromedos.dtd">
<%(document_type)s bcor="%(bcor)s" div="%(div)s" lang="%(lang)s" papersize="%(papersize)s" parskip="%(parskip)s" secnumdepth="%(secnumdepth)s" secsplitdepth="%(secsplitdepth)s">

    %(header)s

    <make-toc depth="%(tocdepth)s" lof="%(have_lof)s" lot="%(have_lot)s" lol="%(have_lol)s"/>

    %(contents)s

</%(document_type)s>
    """

    def __init__(self, options):
        self.config = {
            "document_type": "report",
            "bcor": "0cm",
            "div": "16",
            "lang": "en_US",
            "papersize": "a4",
            "parskip": "half",
            "secnumdepth": "2",
            "secsplitdepth": "1",
            "header": "",
            "tocdepth": "5",
            "have_lof": "no",
            "have_lot": "no",
            "have_lol": "no",
            "contents": ""
        }
        self.config.update(options)
    #end function

    def convert(self, string):
        renderer = ECMLRenderer()
        markdown = mistune.Markdown(renderer=renderer)

        contents = self.parse_preamble(string)
        header   = self.generate_header(self.config)
        contents = markdown(contents)

        for i in range(renderer.section_level):
            contents += "</section>"

        self.config["header"]   = header
        self.config["contents"] = contents
        contents = MarkdownConverter.DOCUMENT_TEMPLATE % self.config

        parser = etree.XMLParser(remove_blank_text=True)
        tree = etree.fromstring(contents, parser=parser)

        print(etree.tostring(tree, pretty_print=True, encoding="unicode"))
    #end function

    def parse_preamble(self, string):
        config = {}

        m = re.match(r"\A---+\s*?$.*?^---+\s*?$", string, flags=re.MULTILINE|re.DOTALL)

        if not m:
            return string

        m = m.group(0)

        for line in m.strip("-").splitlines():
            if not line.strip():
                continue

            try:
                k, v = [x.strip() for x in line.split(":", 1)]
                k = k.replace("-", "_")
            except:
                continue

            if k != "author":
                config[k] = v
            else:
                config.setdefault(k, []).append(v)
            #end if
        #end for

        self.validate_config(config)
        self.config.update(config)

        return string[len(m):]
    #end function

    def generate_header(self, config):
        header_elements = [
            "subject",
            "title",
            "subtitle",
            "author",
            "date",
            "publisher",
            "dedication"
        ]

        header = ""

        for element_name in header_elements:
            if element_name == "title":
                header += "<title>%s</title>\n" % config.get("title", "")
            elif element_name == "author":
                for author in config.get("author", []):
                    header += "<author>%s</author>\n" % author
            else:
                element_text = config.get(element_name, "")
                if element_text:
                    header += "<%s>%s</%s>\n" % \
                            (element_name, element_text , element_name)
                #end if
            #end ifs
        #end for

        return "<head>\n%s</head>" % header
    #end function

    def validate_config(self, config):
        pass
    #end function

#end class
