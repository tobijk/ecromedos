# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Date:    2009/11/15
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
#


# std includes
import os, libxml2, shutil, re, subprocess, tempfile

# ecmds includes
from ecmds.error import ECMDSPluginError


def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin:

	def __init__(self, config):

		# set counter
		self.counter = 1
		self.imgmap = {}
		self.imgwidth = {}

		# look for conversion tool
		try:
			self.convert_bin = ""
			self.convert_bin = config['convert_bin']
		except KeyError:
			msg  = "Location of the 'convert' executable not specified."
			raise ECMDSPluginError(msg, "picture")
		#end try
		if not os.path.isfile(self.convert_bin):
			msg = "Could not find 'convert' executable '%s'." % (self.convert_bin,)
			raise ECMDSPluginError(msg, "picture")
		#end if

		# look for identify tool
		try:
			self.identify_bin = ""
			self.identify_bin = config['identify_bin']
		except KeyError:
			msg  = "Location of the 'identify' executable not specified."
			raise ECMDSPluginError(msg, "picture")
		#end try
		if not os.path.isfile(self.identify_bin):
			msg = "Could not find 'identify' executable '%s'." % (self.identify_bin,)
			raise ECMDSPluginError(msg, "picture")
		#end if

		# temporary directory
		self.tmp_dir = config['tmp_dir']

		# conversion dpi
		try:
			self.convert_dpi = config['convert_dpi']
		except KeyError:
			self.convert_dpi = 100
		#end try
	#end function


	def flush(self):
		# reset counter
		self.counter = 1
		self.imgmap = {}
		self.imgwidth = {}
	#end function


	def __imgSrc(self, node):

		# location of image
		try:
			src = ""
			for prop in node.properties:
				if prop.name == "src":
					src = prop.content
					break
				#end if
			#end for
		except Exception: pass

		# if src is a relative path, prepend doc's location
		if src and not os.path.isabs(src):
			root = node.parent
			while root.parent: root = root.parent
			loc = os.path.dirname(os.path.normpath(root.name))
			src = os.path.join(loc, os.path.normpath(src))
		#end if

		if not src:
			msg  = "Emtpy or missing 'src' attribute in 'img' tag "
			msg += "on line '%d'." % (node.lineNo(),)
			raise ECMDSPluginError(msg, "picture")
		#end if
		
		if not os.path.isfile(src):
			msg  = "Could not find bitmap file at location '%s' " % (src,)
			msg += "as specified in 'img' tag on line '%d'." % (node.lineNo(),)
			raise ECMDSPluginError(msg, "picture")
		#end if

		return src
	#end function


	def __copyFile(self, src, dst):

		# fast copy from 'src' to 'dst'
		srcfp = None
		dstfp = None
		try:
			try:
				srcfp = file(src, "rb")
				dstfp = file(dst, "wb+")
				shutil.copyfileobj(srcfp, dstfp)
			finally:
				if srcfp: srcfp.close()
				if dstfp: dstfp.close()
			#end try
		except Exception:
			msg = "Error while copying file '%s'." % (src,)
			raise ECMDSPluginError(msg, "picture")
		#end try
	#end function


	def __convertImg(self, src, dst, width=None):

		# build command line
		if width:
			cmd = [self.convert_bin, "-antialias",
			        "-density", self.convert_dpi, "-scale", width+"x", src, dst]
		else:
			cmd = [self.convert_bin, "-antialias",
			        "-density", self.convert_dpi, src, dst]
		#end if

		# execute
		devnull = file(os.devnull, "wb")
		proc = subprocess.Popen(cmd, stdout=devnull, stderr=devnull)
		rval = proc.wait()
		devnull.close()

		# test exit status
		if rval != 0:
			msg = "Could not convert graphics file '%s'." % (src,)
			raise ECMDSPluginError(msg, "picture")
		#end if
	#end function


	def __eps2pdf(self, src, dst):

		# determine extension
		ext = '.' + src.strip().split('.')[-1]

		# look for bounding box
		rexpr = re.compile(r"(^%%BoundingBox:)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)")

		try:
			# open source file and temporary output
			infile = file(src, "rb")
			tmpfd, tmpname = tempfile.mkstemp(suffix=".eps", dir=self.tmp_dir)
			outfile = os.fdopen(tmpfd, "wb")

			# Look for bounding box and adjust
			done = False
			for line in infile:
				m = rexpr.match(line)
				if not done and m:
					llx = int(m.group(2))
					lly = int(m.group(3))
					urx = int(m.group(4))
					ury = int(m.group(5))
					width, height = (urx - llx, ury - lly)
					xoff, yoff = (-llx, -lly)
					outfile.write("%%%%BoundingBox: 0 0 %d %d\n" % (width, height))
					outfile.write("<< /PageSize [%d %d] >> setpagedevice\n" % (width, height))
					outfile.write("gsave %d %d translate\n" % (xoff, yoff));
					done = True
				else:
					outfile.write(line)
				#end if
			#end for

			# done adjusting, close files
			infile.close()
			outfile.close()

			# carry out conversion
			self.__convertImg(tmpname, dst)

		except IOError:
			msg = "Could not convert EPS file '%s'" % src
			raise ECMDSPluginError(msg, "picture")
		#end try
	#end function


	def LaTeX_prepareImg(self, node, format="eps"):

		# get image src path
		src = self.__imgSrc(node)
		
		# check if we used this image before
		try:
			dst = self.imgmap[src][0]
		except KeyError:
			dst = "img%06d.%s" % (self.counter, format)
			self.counter += 1
			if not src.endswith(format):
				if src.endswith(".eps") and format == "pdf":
					self.__eps2pdf(src, dst)
				else:
					self.__convertImg(src, dst)
				#end if
			else:
				self.__copyFile(src, dst)
			#end if
			self.imgmap[src] = [dst]
		#end try

		# set src attribute to new file
		for prop in node.properties:
			if prop.name == "src":
				prop.setContent(dst)
				break
			#end if
		#end for
	#end function


	def __identifyWidth(self, src):

		width = ""
	
		cmd = [ self.identify_bin, src ]
		proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
		result = proc.stdout.read()
		if result.startswith("identify:"):
			msg = "Could not determine bitmap's dimensions:\n  '%s'." % (result,)
			raise ECMDSPluginError(msg, "picture")
		#end if

		result = result.split()
		rexpr = re.compile("[0-9]+x[0-9]+")
		for value in result:
			if rexpr.match(value):
				width = value.split('x')[0]
				break
			#end if
		#end for

		if not width:
			msg = "Could not determine bitmap's dimensions:\n  '%s'." % (src,)
			raise ECMDSPluginError(msg, "picture")
		#end if

		return width
	#end function


	def XHTML_prepareImg(self, node):

		# get image src path
		src = self.__imgSrc(node)
		dst = ""

		width = ""
		for prop in node.properties:
			if prop.name == "screen-width":
				width = prop.getContent()
				width = re.match("[1-9][0-9]*", width).group()
				break
			#end if
		#end for

		# try running 'identify' on pic
		if not width: width = self.__identifyWidth(src)

		try:
			imglist = self.imgmap[src]
			for img in imglist:
				img_width = self.imgwidth[img]
				if width == img_width:
					dst = img
					break
				#end if
			#end for
		except KeyError: pass
		
		if not dst:
			# check image format
			ext = src.strip().split('.')[-1]
		
			if ext.lower() in ["jpg", "gif", "png"]:
				dst = "img%06d.%s" % (self.counter, ext.lower())
				self.__convertImg(src, dst, width)
			else:
				dst = "img%06d.jpg" % (self.counter,)
				self.__convertImg(src, dst, width)
			#end if
			self.imgwidth[dst] = width
			self.imgmap.setdefault(src, []).append(dst)
			self.counter += 1
		#end if

		# set src attribute to new file
		for prop in node.properties:
			if prop.name == "src":
				prop.setContent(dst)
				break
			#end if
		#end for
	#end function


	def process(self, node, format):
		'''Prepare @node for target @format.'''

		if format == "latex":
			self.LaTeX_prepareImg(node)
		elif format.endswith("latex"):
			self.LaTeX_prepareImg(node, "pdf")
		else:
			self.XHTML_prepareImg(node)
		#end if

		return node
	#end function

#end class
