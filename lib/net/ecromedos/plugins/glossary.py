# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import sys, locale, functools
import lxml.etree as etree
from net.ecromedos.error import ECMDSPluginError

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        self.glossary = [];
        try:
            self.__draft = config['xsl_params']['global.draft']
        except KeyError:
            self.__draft = "'no'"
    #end function

    def process(self, node, format):
        """Saves a glossary entry or sorts and builds the glossary,
        depending on what type of node triggered the plugin."""

        if self.__draft == "'yes'":
            return node

        if node.tag == "defterm":
            node = self.__saveNode(node)
        elif node.tag == "make-glossary":
            node = self.__makeGlossary(node)
        #end if

        return node
    #end function

    def flush(self):
        self.glossary = []
    #end function

    # PRIVATE

    def __saveNode(self, node):
        """Stores a reference to the given node."""

        term = node.attrib.get("sortkey", None)
        if not term:
            dt_node = node.find("./dt")
            if dt_node is not None:
                term = "".join([s for s in dt_node.itertext()])
        #end if

        self.glossary.append([term, node])
        return node
    #end function

    def __makeGlossary(self, node):
        """Read configuration. Sort items. Build glossary. Build XML."""

        if not self.glossary:
            return node

        # build configuration
        config = self.__configuration(node)

        # set locale
        self.__setLocale(config['locale'], config['locale_encoding'],
                config['locale_variant'])

        # sort glossary
        self.__sortGlossary(config)

        # build DOM structures
        glossary = self.__buildGlossary(node, config)

        # reset locale
        self.__resetLocale()

        return glossary
    #end function

    def __configuration(self, node):
        """Read node attributes and build a dictionary holding
        configuration information for the collator."""

        # presets
        properties = {
            "locale": "C",
            "locale_encoding": None,
            "locale_variant": None,
            "alphabet": "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
        }

        # read element attributes
        properties.update(dict(node.items()))

        # split locale into locale/encoding/variant
        if '@' in properties['locale']:
            properties['locale'], properties['locale_variant'] = \
                properties['locale'].split('@', 1)
        if '.' in properties['locale']:
            properties['locale'], properties['locale_encoding'] = \
                properties['locale'].split('.', 1)
        #end ifs

        # parse the alphabet
        alphabet = []
        for ch in [x.strip() for x in properties['alphabet'].split(",")]:
            if ch[0] == '[' and ch[-1] == ']':
                properties['symbols'] = ch[1:-1].strip()
            else:
                alphabet.append(ch)
            #end if
        #end for
        properties['alphabet'] = alphabet

        return properties
    #end function

    def __setLocale(self, collate="C", encoding=None, variant=None):
        """Sets the locale to the specified locale, encoding and locale
        variant."""

        success = False

        for e in [encoding, "UTF-8"]:
            if success:
                break
            for v in [variant, ""]:
                localestring = '.'.join([x for x in [collate,      e] if x])
                localestring = '@'.join([x for x in [localestring, v] if x])
                try:
                    locale.setlocale(locale.LC_COLLATE, localestring)
                    success = True
                    break
                except locale.Error:
                    pass
            #end for
        #end for

        if not success:
            msg = "Warning: cannot set locale '%s'." % collate
            sys.stderr.write(msg)
    #end function

    def __resetLocale(self):
        """Resets LC_COLLATE to its default."""
        locale.resetlocale(locale.LC_COLLATE)
    #end function

    def __sortGlossary(self, config):
        """Sort glossary terms."""

        # create alphabet nodes
        for ch in config['alphabet']:
            newnode = etree.Element("glsection")
            newnode.attrib["name"] = ch
            self.glossary.append([ch, newnode])
        #end for

        # comparison function
        def compare(a,b):
            result = locale.strcoll(a[0], b[0])

            y1 = a[1].tag
            y2 = b[1].tag

            if result != 0:
                return result
            elif y1 == y2:
                return 0
            elif y1 == "glsection":
                return -1
            elif y2 == "glsection":
                return +1
            else:
                return 0
        #end inline

        self.glossary.sort(key=functools.cmp_to_key(compare))
    #end function

    def __buildGlossary(self, node, config):
        """Build XML DOM structure. self.glossary is a list of tuples
        of the form (sortkey, node), where node can be a 'glsection' or
        a 'defterm' element."""

        section = etree.Element("glsection")
        try:
            section.attrib["name"] = config['symbols']
        except KeyError:
            pass

        dl_node = etree.Element("dl")
        section.append(dl_node)

        for item in self.glossary:
            if item[1].tag == "glsection":
                node.append(section)
                section = item[1]
                dl_node = etree.Element("dl")
                section.append(dl_node)
            else: # defterm
                dt_node = item[1].find("./dt")
                dd_node = item[1].find("./dd")
                dl_node.append(dt_node)
                dl_node.append(dd_node)
            #end if
        #end for

        node.append(section)
        node.tag = "glossary"

        return node
    #end function

#end class
