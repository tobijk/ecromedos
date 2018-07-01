# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, re
from lxml import etree
import com.lepture.mistune as mistune
from net.ecromedos.configreader import ECMDSConfigReader
from net.ecromedos.dtdresolver  import ECMDSDTDResolver

class ECMLRendererError(Exception):
    pass

class ECMLRenderer(mistune.Renderer):

    def __init__(self, config):
        mistune.Renderer.__init__(self)
        self.section_level = 0
        self.footnotes_map = {}
        self.config = config
    #end if

    # BLOCK ELEMENTS

    def block_code(self, code, language=None):
        if language == None:
            language = "text"

        return """<listing><code syntax="%(lang)s" strip="yes"
                tabspaces="4">%(code)s</code></listing>""" % {
            "lang": language,
            "code": mistune.escape(code)
        }
    #end function

    def block_quote(self, text):
        return "<blockquote>%s</blockquote>" % text

    def block_html(self, ecml):
        return ecml

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

    def list(self, body, ordered=True):
        if ordered:
            return "<ol>%s</ol>" % body
        else:
            return "<ul>%s</ul>" % body
    #end function

    def list_item(self, text):
        return "<li>%s</li>" % text

    def paragraph(self, text):
        return "<p>%s</p>" % text

    def table(self, header, body):
        return """\
        <table print-width="100%%" screen-width="940px" align="left"
            frame="rowsep,colsep" print-rulewidth="1pt" screen-rulewidth="1px"
            rulecolor="#ffffff">
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

    def table_cell(self, content, **flags):
        align = flags['align']
        width = flags.get('width')

        attributes = ""

        if align:
            attributes += ' align="%s"' % align
        if width:
            attributes += ' width="%s"' % width

        return '<td%s>%s</td>' % (attributes, content)
    #end function

    # INLINE ELEMENTS

    def autolink(self, link, is_email=False):
        link = mistune.escape(link)
        href = "mailto:%s" % link if is_email else link
        return '<link url="%s">%s</link>' % (href, link)
    #end function

    def codespan(self, text):
        return "<tt>%s</tt>" % mistune.escape(text)

    def double_emphasis(self, text):
        return "<b>%s</b>" % text

    def emphasis(self, text):
        return "<i>%s</i>" % text

    def image(self, src, title, text):
        src  = mistune.escape_link(src)
        text = mistune.escape(text, quote=True)

        if title:
            title = mistune.escape(title, quote=True)
            ecml = """\
                <figure align="left">
                    <caption>%s</caption>
                    <img src="%s" print-width="100%%" screen-width="940px"/>
                </figure>
            """ % (title, src)
        else:
            ecml = """\
                <figure align="left">
                    <img src="%s" print-width="100%%" screen-width="940px"/>
                </figure>
            """ % (src,)
        #end if

        return ecml
    #end function

    def linebreak(self):
        return "<br/>"

    def newline(self):
        return ""

    def footnote_ref(self, key, index):
        return '<footnote-ref idref="%s"/>' % mistune.escape(key)

    def footnote_item(self, key, text):
        self.footnotes_map[key] = text
        return ""
    #end function

    def footnotes(self, text):
        return ""

    def link(self, link, title, text):
        link = mistune.escape_link(link)
        return '<link url="%s">%s</a>' % (link, text)
    #end function

    def strikethrough(self, text):
        return text

    def text(self, text):
        return mistune.escape(text)

    def inline_html(self, ecml):
        return ecml

#end class

class MarkdownConverterError(Exception):
    pass

class MarkdownConverter(ECMDSDTDResolver, ECMDSConfigReader):

    DOCUMENT_TEMPLATE = """\
<!DOCTYPE %(document_type)s SYSTEM "http://www.ecromedos.net/dtd/3.0/ecromedos.dtd">
<%(document_type)s bcor="%(bcor)s" div="%(div)s" lang="%(lang)s" papersize="%(papersize)s" parskip="%(parskip)s" secnumdepth="%(secnumdepth)s" secsplitdepth="%(secsplitdepth)s">

    %(header)s
    %(legal)s

    <make-toc depth="%(tocdepth)s" lof="%(have_lof)s" lot="%(have_lot)s" lol="%(have_lol)s"/>

    %(contents)s

</%(document_type)s>
    """

    def __init__(self, options):
        ECMDSConfigReader.__init__(self)
        ECMDSDTDResolver. __init__(self)

        self.readConfig(options)
        self.document_settings = {
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
            "contents": "",
            "legal": ""
        }
        self.user_settings = options
    #end function

    def convert(self, string):
        # initial conversion happening here
        renderer  = ECMLRenderer(self.config)
        markdown  = mistune.Markdown(renderer=renderer)
        contents  = markdown(self.parse_preamble(string))
        footnotes = renderer.footnotes_map

        def inline_markdown(s_):
            t_ = etree.fromstring(markdown(s_))

            # Maybe there can be a more elegant solution for this?
            v_ = etree.tostring(t_, pretty_print=True,
                    encoding="unicode")
            v_ = re.sub(r"^\<p\>|\</p\>$", "", v_,
                    flags=re.MULTILINE)

            return v_.strip()
        #end inline function

        for k, v in self.document_settings.items():
            if not v or isinstance(v, str) and not v.strip():
                continue

            if k == "legal":
                self.document_settings["legal"] = \
                    "<legal>" + \
                        markdown(v) + \
                    "</legal>"
            elif k == "author":
                for i in range(len(v)):
                    v[i] = inline_markdown(v[i])
            else:
                v = re.sub(r"\s+", " ", v, flags=re.MULTILINE).strip()
                self.document_settings[k] = inline_markdown(v)
        #end if

        header = self.generate_header(self.document_settings)

        # close all open sections
        for i in range(renderer.section_level):
            contents += "</section>"

        self.document_settings["header"] = header
        self.document_settings["contents"] = contents
        self.document_settings["footnotes"] = footnotes

        contents = MarkdownConverter.DOCUMENT_TEMPLATE % self.document_settings

        # parse XML to do post-processing
        parser = etree.XMLParser(
            load_dtd=True,
            remove_blank_text=True
        )
        parser.resolvers.add(self)
        tree = etree.fromstring(contents, parser=parser)

        # fix footnotes, tables, section names...
        tree = self.post_process(tree)

        # return pretty-printed result
        return etree.tostring(tree, pretty_print=True, encoding="unicode")
    #end function

    def parse_preamble(self, string):
        document_settings = {}

        m = re.match(r"\A---+\s*?$.*?^---+\s*?$", string,
                flags=re.MULTILINE|re.DOTALL)

        if not m:
            return string

        m = m.group(0)
        k = ""
        v = ""

        for line in m.strip("-").splitlines(True):
            if re.match(r"^\S+.*:.*$", line):
                k, v = line.split(":", 1)

                if k != "author":
                    document_settings[k] = v
                else:
                    document_settings.setdefault(k, []).append(v)
            elif k:
                if k != "author":
                    document_settings[k] += line
                else:
                    document_settings[k][-1] += line
            #end if
        #end for

        self.document_settings.update(document_settings)
        self.document_settings.update(self.user_settings)
        self.validate_settings(self.document_settings)

        return string[len(m):]
    #end function

    def generate_header(self, settings):
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
                header += "<title>%s</title>\n" % settings.get("title", "")
            elif element_name == "author":
                for author in settings.get("author", []):
                    header += "<author>%s</author>\n" % author
            else:
                element_text = settings.get(element_name, "")
                if element_text:
                    header += "<%s>%s</%s>\n" % \
                            (element_name, element_text , element_name)
                #end if
            #end ifs
        #end for

        return "<head>\n%s</head>" % header
    #end function

    def validate_settings(self, settings):
        pass

    def post_process(self, root_node):

        node = root_node

        while node is not None:
            if node.tag == "footnote-ref":
                node = self.__fix_footnote(node)
            elif node.tag == "section":
                node = self.__fix_section(node)
            elif node.tag == "table":
                node = self.__fix_table(node)
            elif node.tag == "thead":
                node = self.__fix_thead(node)
            elif node.tag == "tbody":
                node = self.__fix_tbody(node)
            elif node.tag == "figure":
                node = self.__fix_figure(node)
            elif node.tag == "img":
                node = self.__fix_img(node)
            #end if

            if len(node) != 0:
                node = node[0]
                continue

            while node is not None:
                following_sibling = node.getnext()

                if following_sibling is not None:
                    node = following_sibling
                    break

                node = node.getparent()
            #end while
        #end while

        return root_node
    #end function

    # PRIVATE

    def __fix_footnote(self, ref_node):
        footnotes    = self.document_settings["footnotes"]
        footnote_ref = ref_node.get("idref", None)
        footnote_def = footnotes.get(footnote_ref, None)

        if footnote_def == None:
            raise MarkdownConverterError(
                "Unresolved footnote reference '%s'" % footnote_ref)
        #end if

        try:
            footnote = etree.fromstring(footnote_def)
        except etree.XMLSyntaxError as e:
            raise MarkdownConverterError(
                "Footnote '%s' is not a valid XML fragment." % footnote_ref)
        #end try

        if footnote.tag != "p":
            raise MarkdownConverterError(
                "Footnote '%s' is an invalid block element." % footnote_ref)
        #end if

        footnote.tag  = "footnote"
        footnote.tail = ref_node.tail
        ref_node.getparent().replace(ref_node, footnote)

        return footnote
    #end function

    def __fix_section(self, section_node):
        document_type = self.document_settings["document_type"]

        if document_type == "article":
            section_names = [
                "section",
                "subsection",
                "subsubsection",
                "minisection"
            ]
        else:
            section_names = [
                "chapter",
                "section",
                "subsection",
                "subsubsection",
                "minisection"
            ]
        #end if

        level = int(section_node.attrib["level"]) - 1
        section_node.tag = section_names[level]
        del section_node.attrib["level"]

        return section_node
    #end function

    def __fix_table(self, table_node):
        if table_node.xpath("colgroup"):
            return table_node

        header_cells = table_node.xpath("thead/tr/td")

        widths       = [int(c.attrib["width"]) for c in header_cells]
        total_width  = sum(widths)
        widths       = [w * 100.0 / float(total_width) for w in widths]
        total_width += len(widths) - 1

        print_width  = int(total_width /  80.0 * 100.0)
        screen_width = int(940.0 * print_width / 100.0)

        table_node.attrib["print-width"]  = str(print_width)  + "%"
        table_node.attrib["screen-width"] = str(screen_width) + "px"

        colgroup_node = etree.Element("colgroup")

        for i, cell in enumerate(header_cells):
            # create a col entry for each column
            col_node = etree.Element("col")
            col_node.attrib["width"] = str(widths[i]) + "%"
            colgroup_node.append(col_node)

            # wrap the content in a <b> tag
            cell.tag = "b"
            new_td_element = etree.Element("td")
            cell.getparent().replace(cell, new_td_element)
            new_td_element.append(cell)

            # copy attributes
            for k, v in cell.attrib.items():
                if k == "width":
                    continue
                new_td_element.set(k, v)
            cell.attrib.clear()

            # set the background color of table header
            new_td_element.attrib["color"] = "#bbbbbb"
        #end for

        body_cells = table_node.xpath("tbody/tr/td")

        # set background color of table body cells
        for cell in body_cells:
            cell.attrib["color"] = "#ddeeff"

        # insert the newly-created colgroup element
        table_node.insert(0, colgroup_node)

        return table_node
    #end function

    def __fix_thead(self, thead_node):
        header_row = thead_node.xpath("tr")[0]
        header_row.tag = "th"
        thead_node.getparent().replace(thead_node, header_row)
        return header_row
    #end function

    def __fix_tbody(self, tbody_node):
        table_node = tbody_node.getparent()
        body_rows  = tbody_node.xpath("tr")

        for row in body_rows:
            table_node.append(row)

        table_node.remove(tbody_node)

        return body_rows[0]
    #end function

    def __fix_figure(self, figure_node):
        section_elements = {
            "chapter":       1,
            "section":       1,
            "subsection":    1,
            "subsubsection": 1,
            "minisection":   1,
            "preface":       1,
            "abstract":      1,
            "appendix":      1
        }

        parent      = figure_node.getparent()
        grandparent = parent.getparent()

        if not section_elements.get(grandparent.tag, None):
            raise MarkdownConverterError("The parent or grandparent of image "\
                "'%s' is not a sectioning element." % figure_node.get("alt"))

        if etree.tostring(parent, method="text", encoding="unicode")\
                .strip() == "":
            grandparent.replace(parent, figure_node)
        else:
            figure_node.attrib["align"] = "left"
            img_node = figure_node.xpath("img")[0]
            img_node.attrib["print-width"] = "50%"
            img_node.attrib["screen-width"] = "460px"
        #end if

        return figure_node
    #end function

    def __fix_img(self, img_node):
        src = img_node.attrib["src"]

        if os.path.isabs(src) or os.path.isfile(src):
            return img_node
        if not "input_dir" in self.config:
            return img_node

        input_dir = self.config["input_dir"]
        img_node.attrib["src"] = os.path.normpath(os.path.join(input_dir, src))

        return img_node
    #end function

#end class
