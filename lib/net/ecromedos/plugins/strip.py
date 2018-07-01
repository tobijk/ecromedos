# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        pass
    #end function

    def process(self, node, format):
        """Strip leading and trailing white-space from node content."""

        default_nodes = [
            "p",
            "subject",
            "title",
            "author",
            "date",
            "publisher",
            "dedication",
            "caption",
            "dt",
            "dd",
            "equation",
            "td",
            "li"
        ]

        if node.tag in default_nodes:
            do_strip = True
        elif node.attrib.get("strip", "no").lower() in ["yes", "true"]:
            do_strip = True
        else:
            do_strip = False
        #end if

        if not do_strip:
            return node

        self.__lstrip(node)
        self.__rstrip(node)

        return node
    #end function

    def flush(self):
        pass
    #end function

    # PRIVATE

    def __lstrip(self, node):
        hard_nodes = [
            "counter",
            "ref",
            "idref",
            "cite",
            "entity"
        ]

        n = node

        while True:
            if n.tag in hard_nodes:
                return

            if n.text:
                n.text = n.text.lstrip()
                if n.text:
                    return
            #end if

            if len(n):
                n = n[0]
                continue
            elif n == node:
                return

            while True:
                if n.tail:
                    n.tail = n.tail.lstrip()
                    if n.tail:
                        return
                #end if

                following_sibling = n.getnext()

                if following_sibling is not None:
                    n = following_sibling
                    break
                else:
                    n = n.getparent()
                    if n == node:
                        return
                #end if
            #end while
        #end while
    #end function

    def __rstrip(self, node):
        hard_nodes = [
            "counter",
            "ref",
            "idref",
            "cite",
            "entity"
        ]

        if len(node) == 0:
            if node.text:
                node.text = node.text.rstrip()
                if node.text:
                    return
            else:
                return
        #end if

        n = node[-1]

        while True:
            if n.tail:
                n.tail = n.tail.rstrip()
                if n.tail:
                    return
            #end if

            if n.tag in hard_nodes:
                return

            if len(n):
                n = n[-1]
                continue

            while True:
                if n.text:
                    n.text = n.text.rstrip()
                    if n.text:
                        return
                #end if

                previous_sibling = n.getprevious()

                if previous_sibling is not None:
                    n = previous_sibling
                    break
                else:
                    n = n.getparent()
                    if n == node:
                        return
                #end if
            #end if
        #end while
    #end function

#end class
