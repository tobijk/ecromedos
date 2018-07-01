# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

import os
import lxml.etree as etree

class ECMDSDTDResolver(etree.Resolver):

    def resolve(self, url, system_id, context):

        try:
            style_dir = self.config['style_dir']
        except KeyError:
            msg = "Please specify the location of the stylesheets."
            raise ECMDSError(msg)
        #end try

        for name in ["book", "article", "report", "ecromedos"]:
            for version in ["2.0", "3.0"]:
                catalog_url = "http://www.ecromedos.net/dtd/" + version + "/" + name + ".dtd"

                if catalog_url == url:
                    filename = os.path.join(style_dir, "DTD", "ecromedos.dtd")
                    return self.resolve_filename(filename, context)
                #end if
            #end for
        #end for

        return None
    #end function

#end class

