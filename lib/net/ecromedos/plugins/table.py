# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

from net.ecromedos.error import ECMDSPluginError

def getInstance(config):
    """Returns a plugin instance."""
    return Plugin(config)
#end function

class Plugin():

    def __init__(self, config):
        pass
    #end function

    def process(self, node, format):
        """Prepare @node for target @format."""

        # look for 'colgroup' element
        colgroup = node.find("./colgroup")
        if colgroup is None:
            msg = "Missing 'colgroup' element in table starting at line '%d'."\
                    % node.sourceline
            raise ECMDSPluginError(msg, "table")
        #end if

        # build list of all 'col' elements
        columns = []
        for child in colgroup.iterchildren():
            if child.tag == "col":
                columns.append(child)
        #end for

        # number of columns
        num_cols = len(columns)

        # look for 'colsep' in table's 'frame' attribute
        table_frame = node.attrib.get("frame", None)

        if table_frame and "colsep" in table_frame:
            table_frame = 1
        else:
            table_frame = 0
        #end if

        # goto first row
        row = colgroup.getnext()

        # loop through table rows
        while row is not None:
            # look for 'colsep' in row's 'frame' attribute
            row_frame = row.attrib.get("frame", None)

            if row_frame and "colsep" in row_frame:
                row_frame = 1
            else:
                row_frame = 0
            #end if

            # goto first table cell
            cur_col = 0
            entry = row[0] if len(row) else None

            # loop over table cells
            while entry is not None:
                colspan = entry.attrib.get("colspan", None)

                if colspan: 
                    try:
                        colspan = int(colspan)
                    except ValueError:
                        msg = "Invalid number in 'colspan' attribute on line %d."\
                                % entry.sourceline
                        raise ECMDSPluginError(msg, "table")
                    #end try
                else:
                    colspan = 1
                #end if

                cur_col = cur_col + colspan - 1

                # only for n-1 cols
                if cur_col < (num_cols - 1):
                    # let's see, if we have to update the corresponding 'col'
                    entry_frame = entry.attrib.get("frame", None)

                    if row_frame or table_frame:
                        columns[cur_col].attrib["frame"] = "colsep"
                    elif entry.tag == "subtable" and entry_frame and "right" in entry_frame:
                        columns[cur_col].attrib["frame"] = "colsep"
                    elif entry.tag != "subtable" and entry_frame and "colsep" in entry_frame:
                        columns[cur_col].attrib["frame"] = "colsep"
                    #end if
                #end if

                cur_col += 1
                entry = entry.getnext()
            #end while

            # count how many columns have colsep set
            num_cols_set = 0
            for col in columns:
                if col.attrib.get("frame") and "colsep" in col.attrib["frame"]:
                    num_cols_set += 1
            #end for

            # if every 'col' has been set, we can spare ourselves the rest
            if num_cols_set == (num_cols - 1):
                break

            # else continue in next row
            row = row.getnext()
        #end while

        return node
    #end function

    def flush(self):
        pass
    #end function

#end class
