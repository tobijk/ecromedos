# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Date:    2009/11/15
#

# std includes
import os, sys, imp

# ecmds includes
from error import ECMDSError, ECMDSPluginError


class ECMDSPreproc:

	def __init__(self):
		self.plugins = {}
	#end function


	def loadPlugins(self):
		'''Import everything from the plugin directory.'''

		if self.plugins: return

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
					if filename.endswith(".py"): filelist.append(filename[:-3])
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
			except Exception, e:
				msg = "Warning: could not load module '%s': " % (name,)
				msg += str(e) + "\n"
				sys.stderr.write(msg + "\n")
				continue
			#end try
		#end for
	#end function


	def __processNode(self, node, format):
		'''Check if there is a filter registered for node.'''

		if node.type == "text":
			plist = self.pmap.get("@text", [])
		else:
			plist = self.pmap.get(node.name, [])
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
			except Exception, e:
				msg = "Plugin '%s' caused an exception: %s" % (pname, str(e))
				raise ECMDSError(msg)
		#end for

		return node
	#end function


	def __flushPlugins(self):
		'''Call flush function of all registered plugins.'''
		
		for pname, plugin in self.plugins.iteritems():
			plugin.flush()
		#end for
	#end function


	def prepareDocument(self, document):
		'''Prepare document tree for transformation.'''

		format = self.config['target_format']
		node = document.getRootElement()
		while True:
			# call plugin
			if node.name != "copy" and node.prop("final") != "yes":
				node = self.__processNode(node, format)
			# find successor node
			if node.children and node.name != "copy" and node.prop("final") != "yes":
				node = node.children
			else:
				while node.parent.type != "document_xml":
					if node.next:
						node = node.next
						break
					else:
						node = node.parent
					#end if
				#end while
			#end if
			if node.parent.type == "document_xml": break
		#end while

		# terminate plugins
		self.__flushPlugins()

		return document
	#end function

#end class
