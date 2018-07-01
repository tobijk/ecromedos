#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os, sys, getopt

# make ecromedos relocatable
MD2ECML_INSTALL_DIR = os.path.normpath(
        os.path.dirname(
            os.path.realpath(sys.argv[0])
        ) + os.sep + ".." )

sys.path.insert(1, MD2ECML_INSTALL_DIR + os.sep + 'lib')

from net.ecromedos.markdown import MarkdownConverter, MarkdownConverterError
from net.ecromedos.version import VERSION

# exit values
MD2ECML_ERR_INVOCATION = 1
MD2ECML_ERR_PROCESSING = 2
MD2ECML_ERR_UNKNOWN    = 3

def printVersion():
    """Display version information."""

    print("Markdown to ECML converter, version %s" % VERSION                              )
    print("Copyright (C) 2016, Tobias Koch <tobias@tobijk.de>                            ")
#end function

def printUsage():
    """Print usage information."""

    print("                                                                              ")
    print("Usage: md2ecml [OPTIONS] <sourcefile>                                         ")
    print("                                                                              ")
    print("Options:                                                                      ")
    print("                                                                              ")
    print(" --help, -h            Display this help text and exit.                       ")
    print(" --version, -v         Print version information and exit.                    ")
    print("                                                                              ")
    print(" --doctype <type>      Document class, one of article, report (default), book.")
    print(" --bcor <amount>       Binding correction (default: 0cm).                     ")
    print(" --page-div <num>      Page grid resolution (default: 16).                    ")
    print(" --lang <language>     Document language (default: en_US).                    ")
    print(" --papersize <format>  Paper type, one of legal, letter, executive, aX or bX  ")
    print("                       (default: a4)                                          ")
    print(" --parskip <format>    Paragraph skip, one of full, half (default) or off.    ")
    print(" --secnumdepth <lvl>   Number headings down to this section level (default: 5)")
    print(" --secsplitdepth <lvl> Chunk the document to this section level (default: 1)  ")
    print(" --have-lof            Enable list of figures in the table of contents.       ")
    print(" --have-lot            Enable list of tables in the table of contents.        ")
    print(" --have-lol            Enable list of listings in the table of contents.      ")
#end function

def parseCmdLine():
    """Parse and extract arguments of command line options."""

    options = {}

    try:
        opts, args = getopt.getopt(sys.argv[1:], "hv",
            ["help", "version", "doctype=", "bcor=", "page-div=", "lang=",
                "papersize=", "parskip=", "secnumdepth=", "secsplitdepth=",
                "have-lof", "have-lot", "have-lol"]
        )
    except getopt.GetoptError as e:
        msg  = "Error while parsing command line: %s\n" % e.msg
        msg += "Type 'md2ecml --help' for more information."
        raise MarkdownConverterError(msg)
    #end try

    for o, v in opts:
        if o in [ "--help", "-h" ]:
            printVersion()
            printUsage()
            sys.exit(0)
        elif o in ["--version", "-v"]:
            printVersion()
            sys.exit(0)
        elif o == "--doctype":
            if not v in ["article", "report", "book"]:
                raise MarkdownConverterError("Invalid document class '%s'" % v)
            options["document_type"] = v
        elif o == "--bcor":
            options["bcor"] = v
        elif o == "--page-div":
            options["div"] = v
        elif o == "--lang":
            options["lang"] = v
        elif o == "papersize":
            valid_paper_sizes = ["legal", "letter", "executive"]
            for i in [a, b, c, d]:
                for j in range(7):
                    valid_paper_sizes.append(i + str(j) + paper)
                #end for
            #end for
            if not v in valid_paper_sizes:
                msg = "Invalid paper size '%s'" % v
                raise MarkdownConverterError(msg)
            #end if
            options["papersize"] = v
        elif o == "parskip":
            if not v in ["half", "full", "off"]:
                msg = "Invalid parskip '%s'" % v
                raise MarkdownConverterError(msg)
            #end if
            options["parskip"] = v
        elif o == "secnumdepth":
            try:
                if not int(v) in list(range(0,6)):
                    raise ValueError
            except ValueError:
                msg = "Invalid value '%s' for secnumdepth." % v
                raise MarkdownConverterError(msg)
            options["secnumdepth"] = v
        elif o == "secsplitdepth":
            try:
                if not int(v) in list(range(0,6)):
                    raise ValueError
            except ValueError:
                msg = "Invalid value '%s' for secsplitdepth." % v
                raise MarkdownConverterError(msg)
            #end try
            options["secsplitdepth"] = v
        elif o == "have-lof":
            options["have_lof"] = "yes"
        elif o == "have-lot":
            options["have_lot"] = "yes"
        elif o == "have-lol":
            options["have_lol"] = "yes"
        else:
            msg = "Unrecognized option '%s'.\n" % (o,)
            msg += "Type 'ecromedos --help' for more information."
            raise MarkdownConverterError(msg)
        #end ifs
    #end while

    return options, args
#end function

if __name__ == "__main__":
    try:
        # SETUP
        try:
            options, files = parseCmdLine()
            if len(files) < 1:
                msg = "md2ecml: no source file specified"
                raise MarkdownConverterError(msg)
            if not os.path.isfile(files[0]):
                msg = "md2ecml: '%s' does not exist or is not a file "\
                    % files[0]
                raise MarkdownConverterError(msg)
            #end ifs
        except MarkdownConverterError as e:
            sys.stderr.write(str(e) + "\n")
            sys.exit(MD2ECML_ERR_INVOCATION)
        #end try

        # READ FILE
        try:
            with open(files[0], encoding="utf-8") as fp:
                buf = fp.read()
        except Exception as e:
            sys.stderr.write("Error reading input file: %s\n" % str(e))
            sys.exit(MD2ECML_ERR_PROCESSING)
        #end try

        # TRANSFORMATION
        try:
            # SET INSTALLATION PATH
            options.setdefault("install_dir", MD2ECML_INSTALL_DIR)
            options.setdefault("input_dir", os.path.dirname(files[0]))

            # DO DOCUMENT TRANSFORMATION
            print(MarkdownConverter(options).convert(buf))
        except MarkdownConverterError as e:
            sys.stderr.write(str(e) + "\n")
            sys.exit(MD2ECML_ERR_PROCESSING)
    except KeyboardInterrupt:
        sys.stdout.write("\n -> Caught SIGINT, terminating.\n")
#end __main__
