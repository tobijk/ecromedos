# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# std includes
import libxml2

# ecmds includes
from ecmds.error import ECMDSPluginError
from ecmds.highlight.formatter import ECMLFormatter

from pygments import highlight
from pygments.lexers import get_lexer_by_name
from pygments.styles import get_style_by_name
from pygments.util import ClassNotFound as PygmentsClassNotFound

def getInstance(config):
    '''Returns a plugin instance.'''
    return Plugin(config)
#end function

class Plugin(object):

    def __init__(self, config):
        pass
    #end function

    def flush(self):
        pass
    #end function

    def process(self, node, format):
        '''Prepare @node for target @format.'''

        #get properties
        options = {}
        prop = node.properties
        while prop:
            options[prop.name] = prop.content
            prop = prop.next
        #end while

        # does user want highlighting?
        try:
            if not options['syntax']: return node
        except KeyError: return node

        # fetch content and highlight
        string = node.getContent()
        try:
            result = self.highlight(string, options)
        except Exception, e:
            print e
            raise

        # parse result
        doc = libxml2.parseDoc(result)
        root = doc.getRootElement()
        root.unlinkNode()

        # replace original node
        prop = node.properties
        while prop:
            next = prop.next
            prop.unlinkNode()
            if not root.hasProp(prop.name):
                root.addChild(prop)
            else:
                if prop.name == "bgcolor":
                    root.setProp("bgcolor", prop.content)
                #end if
                prop.freeNode()
            #end if
            prop = next
        #end for
        node.replaceNode(root)
        node.freeNode()
        doc.freeDoc()

        return root
    #end function

    def highlight(self, string, options):
        '''Call syntax highlighter.'''

        # output line numbers?
        try:
            self.__startline = int(options["startline"])
            self.__haveLineNumbers = True
        except ValueError:
            msg = "Invalid start line '%s'." % (options["startline"],)
            raise ECMDSPluginError(msg, "highlight")
        except KeyError:
            self.__haveLineNumbers = False
            self.__startline = 1
        #end try

        # increment to add to each line
        try:
            self.__lineStepping = int(options["linestep"])
        except ValueError:
            msg = "Invalid line stepping '%s'." % (options["linestep"],)
            raise ECMDSPluginError(msg, "highlight")
        except KeyError:
            self.__lineStepping = 1
        #end try

        # style to use
        try:
            self.__style = get_style_by_name(options['colorscheme'])
        except PygmentsClassNotFound:
            msg = "No style by name '%s'" % options["colorscheme"]
            raise ECMDSPluginError(msg, "highlight")
        except KeyError:
            self.__style = get_style_by_name("default")
        #end try

        # get a lexer for given syntax
        try:
            lexer = get_lexer_by_name(options["syntax"])
        except PygmentsClassNotFound:
            msg = "No lexer class found for '%s'." % options["syntax"]
            raise ECMDSPluginError(msg, "highlight")
        #end try

        # do the actual highlighting
        formatter = ECMLFormatter(emit_line_numbers=self.__haveLineNumbers,
            startline=self.__startline, line_step=self.__lineStepping,
            encoding='utf-8', style=self.__style)
        
        return highlight(string, lexer, formatter)
    #end function

#end class

