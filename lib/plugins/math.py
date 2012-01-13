# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#

# std includes
import os, libxml2, cStringIO, re, subprocess, tempfile

# ecmds includes
from ecmds.error import ECMDSPluginError


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function

class Plugin(object):

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
			self.dvipng_dpi = 100
		#end try

		# output document
		self.out = cStringIO.StringIO()
	#end function


	def flush(self):
		'''If target format is XHTML, generate GIFs from formulae.'''

		# generate bitmaps of formulae
		if self.out.tell() > 0:
			self.out.write("\\end{document}\n")
			self.__LaTeX2DVI2GIF()
			self.out.close()
			self.out = cStringIO.StringIO()
		#end if
		
		#reset counter
		self.counter = 1
		self.nodelist = []
	#end function


	def process(self, node, format):
		'''Prepare @node for target @format.'''

		if format.endswith("latex"):
			result = self.LaTeX_ProcessMath(node)
		else:
			result = self.XHTML_ProcessMath(node)
		#end if
		
		return result
	#end function
	
	
	def LaTeX_ProcessMath(self, node):
		'''Mark node, to be copied 1:1 to output document.'''

		# enclose text in copy node
		copy_node = libxml2.newNode("copy")
		for child in node.children:
			child.unlinkNode()
			copy_node.addChild(child)
		#end for
		math_node = libxml2.newNode("m")
		math_node.addChild(copy_node)

		# replace old math node
		node.replaceNode(math_node)
		node.freeNode()
		return math_node
	#end function


	def __LaTeX2DVI2GIF(self):
		'''Write formulae to LaTeX file, compile and extract images.'''

		# open a temporary file for TeX output
		tmpfp, tmpname = tempfile.mkstemp(suffix=".tex", dir=self.tmp_dir)
		texfile = os.fdopen(tmpfp, "wb")

		# open a handle to 'null' device
		devnull = file(os.devnull, "wb")

		# flush memory buffer
		try:
			texfile.write(self.out.getvalue())
			texfile.close()
		except IOError:
			msg = "Error while writing temporary TeX file."
			raise ECMDSPluginError(msg, "math")
		#end try

		# compile LaTeX file
		cmd = [self.latex_bin, "-interaction", "nonstopmode", tmpname]

		# run LaTeX twice
		for i in range(2):
			proc = subprocess.Popen(cmd, stdout=devnull, stderr=devnull, cwd=self.tmp_dir)
			rval = proc.wait()

			# test exit code
			if rval != 0:
				msg = "Could not compile temporary TeX file."
				raise ECMDSPluginError(msg, "math")
			#end if
		#end if

		# determine dvi file name and close TeX file
		dvifile = self.tmp_dir + os.sep + ''.join(tmpname.split(os.sep)[-1].split('.')[:-1]) + ".dvi"

		# close 'null' device
		devnull.close()

		# convert dvi file to GIF image
		cmd = [self.dvipng_bin, "-D", self.dvipng_dpi, "--depth",
		        "-gif", "-T", "tight", "-o", "m%06d.gif", dvifile]

		# we need to log the output
		dvifp, dviname = tempfile.mkstemp(suffix=".log", dir=self.tmp_dir)
		dvilog = os.fdopen(dvifp, "wb")
		proc = subprocess.Popen(cmd, stdout=dvilog, stderr=dvilog)
		rval = proc.wait()
		dvilog.close()

		# check exit code
		if rval != 0:
			msg = "Could not convert dvi file to GIF images."
			raise ECMDSPluginError(msg, "math")
		#end if

		# adjust images' baselines
		self.__alignImages(dviname)
	#end function


	def __alignImages(self, dvilog):
		'''Add style tag to each bitmap for correct baseline alignment.'''

		# read dvipng's log output
		try:
			dvifp = file(dvilog, "rb")
			string = dvifp.read()
			dvifp.close()
		except IOError:
			msg = "Could not read dvipng's log output from '%s'" % dvilog
			raise ECMDSPluginError(msg, "math")
		#end try

		# look for [??? depth=???px]
		rexpr = re.compile("\\[[0-9]* depth=[0-9]*\\]")

		# add style property to node
		i = 0
		for match in rexpr.finditer(string):
			align = match.group().split("=")[1].strip(" []")
			node = self.nodelist[i]
			node.newProp("style", "vertical-align: -" + align + "px;")
			i += 1
		#end for
	#end function


	def XHTML_ProcessMath(self, node):
		'''Call LaTeX and ImageMagick to produce a GIF.'''

		if self.out.tell() == 0:
			# write latex preamble
			self.out.write("\\documentclass[12pt]{scrartcl}\n")
			self.out.write("\\usepackage{courier}\n")
			self.out.write("\\usepackage{helvet}\n")
			self.out.write("\\usepackage{mathpazo}\n")
			self.out.write("\\usepackage{amsmath}\n")
			self.out.write("\\usepackage[active,displaymath,textmath]{preview}\n")
			self.out.write("\\frenchspacing{}\n")
			self.out.write("\\usepackage{ucs}\n")
			self.out.write("\\usepackage[utf8x]{inputenc}\n")
			self.out.write("\\usepackage[T1]{autofe}\n")
			self.out.write("\\PrerenderUnicode{äöüß}\n")
			self.out.write("\\pagestyle{empty}\n")
			self.out.write("\\begin{document}\n")
		#end if

		# save TeX markup
		formula = node.getContent()

		# give each formula one page
		self.out.write("$%s$\n\\clearpage{}\n" % formula)

		# replace node
		copy_node = libxml2.newNode("copy")
		img_node = libxml2.newNode("img")
		img_node.newProp("src", "m%06d.gif" % (self.counter,))
		img_node.newProp("alt", "formula")
		img_node.newProp("class", "math")
		copy_node.addChild(img_node)
		node.replaceNode(copy_node)
		node.freeNode()

		# keep track of images for flush
		self.nodelist.append(img_node)
		self.counter += 1
		return copy_node
	#end function

#end class
