#!/usr/bin/env python3
#-*- encoding: utf-8 -*-

import os, sys, unittest

ECMDS_INSTALL_DIR = os.path.normpath(os.path.join(
    os.path.dirname(os.path.realpath(sys.argv[0])),
    "..", ".."
))

sys.path.insert(1, ECMDS_INSTALL_DIR + os.sep + 'lib')

from net.ecromedos.configreader import ECMDSConfigReader
from net.ecromedos.error import ECMDSConfigError

class UTTestConfigReader(unittest.TestCase):

    def test_loadNonFromNonExistentInstallDir(self):
        options = {
            "install_dir": "/no/such/directory"
        }

        try:
            config, pmap = ECMDSConfigReader().readConfig(options)
        except ECMDSConfigError as e:
            self.assertEqual(e.msg(), "Please specify the location of the config file.")
        else:
            self.assertTrue(False)
    #end function

    def test_loadConfigurationAndCheckResult(self):
        expected_config = {
            'base_dir': ECMDS_INSTALL_DIR,
            'convert_bin': '/usr/bin/convert',
            'convert_dpi': '300',
            'data_dir': ECMDS_INSTALL_DIR + '/data',
            'do_validate': True,
            'dvipng_bin': '/usr/bin/dvipng',
            'dvipng_dpi': '100',
            'identify_bin': '/usr/bin/identify',
            'install_dir': ECMDS_INSTALL_DIR + '',
            'latex_bin': '/usr/bin/latex',
            'lib_dir': ECMDS_INSTALL_DIR + '/lib',
            'plugin_dir': ECMDS_INSTALL_DIR + '/lib/net/ecromedos/plugins',
            'style_dir': ECMDS_INSTALL_DIR + '/xslt',
            'target_format': 'html',
            'pygments_default_colorscheme': 'default'
        }

        expected_pmap = {  
            '@text': ['text'],
            'article': ['data'],
            'author': ['strip'],
            'book': ['data'],
            'caption': ['strip'],
            'code': ['strip', 'highlight', 'verbatim', 'final'],
            'date': ['strip'],
            'dd': ['strip'],
            'dedication': ['strip'],
            'defterm': ['glossary', 'final'],
            'dt': ['strip'],
            'equation': ['strip'],
            'idxterm': ['index', 'final'],
            'img': ['picture'],
            'li': ['strip'],
            'm': ['math'],
            'make-glossary': ['glossary'],
            'make-index': ['index'],
            'p': ['strip'],
            'publisher': ['strip'],
            'report': ['data'],
            'subject': ['strip'],
            'subtable': ['table'],
            'table': ['table'],
            'td': ['strip'],
            'title': ['strip'],
            'verbatim': ['strip', 'verbatim', 'final']
        }

        options = {
            "install_dir": ECMDS_INSTALL_DIR
        }

        config, pmap = ECMDSConfigReader().readConfig(options)

        self.assertEqual(config, expected_config)
        self.assertEqual(pmap, expected_pmap)
    #end function

#end class

if __name__ == "__main__":
    unittest.main()
