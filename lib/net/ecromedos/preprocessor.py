# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, sys, imp
from net.ecromedos.error import ECMDSError, ECMDSPluginError

class ECMDSPreprocessor():

    def __init__(self):
        self.plugins = {}
    #end function

    def loadPlugins(self):
        """Import everything from the plugin directory."""

        try:
            plugin_dir = self.config['plugin_dir']
        except KeyError:
            msg = "No plugins directory specified. Not loading plugins."
            sys.stderr.write(msg)
            return
        #end try

        def genList():
            filelist = []
            for filename in os.listdir(plugin_dir):
                abspath = os.path.join(plugin_dir, filename)
                if os.path.isfile(abspath) and not os.path.islink(abspath):
                    if filename.endswith(".py"):
                        filelist.append(filename[:-3])
                #end if
            #end for
            return filelist
        #end inline function

        try:
            plugins_list = genList()
        except IOError:
            msg = "IO-error while scanning plugins directory."
            raise ECMDSError(msg)
        #end try

        self.plugins = {}
        for name in plugins_list:
            try:
                fp, path, desc = imp.find_module(name, [plugin_dir])
                try:
                    module = imp.load_module(name, fp, path, desc)
                finally:
                    if fp: fp.close()
                #got'cha
                self.plugins[name] = module.getInstance(self.config)
            except AttributeError:
                msg = "Warning: '%s' is not a plugin." % (name,)
                sys.stderr.write(msg + "\n")
                continue
            except Exception as e:
                msg = "Warning: could not load module '%s': " % (name,)
                msg += str(e) + "\n"
                sys.stderr.write(msg + "\n")
                continue
            #end try
        #end for
    #end function

    def prepareDocument(self, document):
        """Prepare document tree for transformation."""

        target_format = self.config['target_format']
        node = document.getroot()

        while node is not None:
            node = self.__processNode(node, target_format)

            if node.tag == "copy" or node.attrib.get("final", "no") == "yes":
                is_final = True
            else:
                is_final = False
            #end if

            if not is_final and node.text:
                node.text = self.__processNode(node.text, target_format)

            if not is_final and len(node) != 0:
                node = node[0]
                continue

            while node is not None:
                if node.tail:
                    node.tail = self.__processNode(node.tail, target_format)

                following_sibling = node.getnext()

                if following_sibling is not None:
                    node = following_sibling
                    break

                node = node.getparent()
            #end while
        #end while

        # call post-actions
        self.__flushPlugins()

        return document
    #end function

    # PRIVATE

    def __processNode(self, node, format):
        """Check if there is a filter registered for node."""

        if isinstance(node, str):
            plist = self.pmap.get("@text", [])
        else:
            plist = self.pmap.get(node.tag, [])
        #end if

        # pass node through plugins
        for pname in plist:
            try:
                plugin = self.plugins[pname]
            except KeyError:
                msg = "Warning: no plugin named '%s' registered." % (pname,)
                sys.stderr.write(msg + "\n")
            #end try
            try:
                node = plugin.process(node, format)
            except ECMDSPluginError:
                raise # caught in __main__
            except Exception as e:
                msg = "Plugin '%s' caused an exception: %s" % (pname, str(e))
                raise ECMDSError(msg)
            #end try
        #end for

        return node
    #end function

    def __flushPlugins(self):
        """Call flush function of all registered plugins."""
        for pname, plugin in self.plugins.items():
            plugin.flush()
    #end function

#end class

