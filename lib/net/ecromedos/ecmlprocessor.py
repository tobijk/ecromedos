# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, sys
import lxml.etree as etree
from net.ecromedos.error import ECMDSError, ECMDSPluginError
from net.ecromedos.configreader import ECMDSConfigReader
from net.ecromedos.dtdresolver  import ECMDSDTDResolver
from net.ecromedos.preprocessor import ECMDSPreprocessor

class ECMLProcessor(ECMDSConfigReader, ECMDSDTDResolver, ECMDSPreprocessor):

    def __init__(self, options={}):
        ECMDSConfigReader.__init__(self)
        ECMDSDTDResolver. __init__(self)
        ECMDSPreprocessor.__init__(self)

        self.readConfig(options)
        self.loadPlugins()
        self.loadStylesheet()
    #end function

    def loadXMLDocument(self, filename):
        """Try to load XML document from @filename."""

        try:
            # create parser
            parser = etree.XMLParser(
                load_dtd=True,
                no_network=True,
                strip_cdata=True,
                remove_comments=True,
                resolve_entities=True
            )

            # register custom resolver
            parser.resolvers.add(self)

            # parse the document
            tree = etree.parse(filename, parser=parser)
        except Exception as e:
            raise ECMDSError(str(e))

        # return document tree
        return tree
    #end function

    def loadStylesheet(self):
        """Load matching stylesheet for desired output format."""

        target_format = self.config['target_format']

        try:
            style_dir = self.config['style_dir']
        except KeyError:
            msg = "Please specify the location of the stylesheets."
            raise ECMDSError(msg)
        #end try

        filename = os.path.join(style_dir, target_format, "ecmds.xsl")
        try:
            tree = self.loadXMLDocument(filename)
        except ECMDSError as e:
            msg = "Could not load stylesheet:\n %s" % (e.msg(),)
            raise ECMDSError(msg)
        #end try

        try:
            self.stylesheet = etree.XSLT(tree)
        except Exception as e:
            raise ECMDSError(str(e))
        #end if

        return self.stylesheet
    #end function

    def validateDocument(self, document):
        """Validate the given document."""

        try:
            style_dir = self.config['style_dir']
        except KeyError:
            msg = "Please specify the location of the stylesheets."
            raise ECMDSError(msg)
        #end try

        # load the DTD
        dtd_filename = os.path.join(style_dir, "DTD", "ecromedos.dtd")
        dtd = etree.DTD(dtd_filename)

        # validate the document
        result = dtd.validate(document)

        if result == False:
            raise ECMDSError(dtd.error_log.last_error)

        return result
    #end function

    def applyStylesheet(self, document):
        """Apply stylesheet to document."""

        params = None
        try:
            params = self.config['xsl_params']
        except KeyError: pass

        try:
            result = self.stylesheet(document, **params)
        except Exception as e:
            msg = "Error transforming document:\n %s." % (str(e),)
            raise ECMDSError(msg)
        #end try

        return result
    #end function

    def process(self, filename, verbose=True):
        """Convert the document stored under filename."""

        def message(msg, verbose):
            if not verbose: return
            sys.stdout.write(" * " + msg)
            sys.stdout.write(" " * (40 - len(msg)))
            sys.stdout.flush()
        #end inline function

        def status(status, verbose):
            if not verbose: return
            sys.stdout.write(status + "\n")
        #end inline function

        # load document
        message("Reading document...", verbose)
        document = self.loadXMLDocument(filename)
        status("DONE", verbose)

        # validate document
        if self.config['do_validate']:
            message("Validating document...", verbose)
            self.validateDocument(document)
            status("VALID", verbose)
        #end if

        # prepare document
        message("Pre-processing document tree...", verbose)
        self.prepareDocument(document)
        status("DONE", verbose)

        # apply stylesheet
        message("Transforming document...", verbose)
        self.applyStylesheet(document)
        status("DONE", verbose)
    #end function

#end class

