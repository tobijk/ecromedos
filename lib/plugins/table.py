# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the eCromedos document preparation system
# Date:    2007/02/07
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Update:  2007/02/20
#

def getInstance(config):
	'''Returns a plugin instance.'''
	return Plugin(config)
#end function


class Plugin:

	def __init__(self, config):
		pass
	#end function


	def flush(self):
		pass
	#end function


	def process(self, node, format):
		'''Prepare @node for target @format.'''

		# make sure we were given a table
		if not node.name in ['table', 'subtable']: return node

		# look for 'colgroup' element
		child = node.children
		while child.name != "colgroup":
			child = child.next
			if not child:
				msg = "Missing 'colgroup' element in table starting at line '%d'." % node.lineNo()
				raise ECMDSPluginError(msg, "table")
			#end if
		#end while
		colgroup = child

		# build list of refs to all 'col' elements
		columns = []
		child = colgroup.children
		while child:
			if child.type == "element" and child.name == "col":
				columns.append(child)
			#end if
			child = child.next
		#end while

		# number of columns
		num_cols = len(columns)

		# look for 'colsep' in table's 'frame' attribute
		table_frame = node.prop("frame")
		if table_frame and "colsep" in table_frame:
			table_frame = 1
		else:
			table_frame = 0
		#end if

		# goto first row
		row = colgroup.next
		while row and row.type != "element":
			row = row.next
		#end while

		# loop through table rows
		while row:
			# look for 'colsep' in row's 'frame' attribute
			row_frame = row.prop("frame")
			if row_frame and "colsep" in row_frame:
				row_frame = 1
			else:
				row_frame = 0
			#end if

			# goto first table cell
			cur_col = 0
			entry = row.children
			while entry and entry.type != "element":
				entry = entry.next
			#end while

			# loop over table cells
			while entry:
				# determine colspan
				colspan = entry.prop("colspan")
				if colspan: 
					try:
						colspan = int(colspan)
					except ValueError:
						msg = "Invalid number in 'colspan' attribute on line %d." % entry.lineNo()
						raise ECMDSPluginError(msg, "table")
					#end try
				else:
					colspan = 1
				#end if
				cur_col = cur_col + colspan - 1

				# only for n-1 cols
				if cur_col < (num_cols - 1):
					# let's see, if we have to update the corresponding 'col'
					entry_frame = entry.prop("frame")
					if row_frame or table_frame:
						columns[cur_col].setProp("frame", "colsep")
					elif (entry.name == "subtable" and entry_frame and "right" in entry_frame):
						columns[cur_col].setProp("frame", "colsep")
					elif (entry.name != "subtable" and entry_frame and "colsep" in entry_frame):
						columns[cur_col].setProp("frame", "colsep")
					#end if
				#end if

				cur_col += 1
				entry = entry.next
				while entry and entry.type != "element":
					entry = entry.next
				#end while
			#end while

			# if every 'col' has been set, we are done
			num_cols_set = 0
			for col in columns:
				if col.hasProp("frame") and "colsep" in col.prop("frame"):
					num_cols_set += 1
				#end if
			#end for
			if num_cols_set == (num_cols - 1): break

			# else continue in next row
			row = row.next
			while row and row.type != "element":
				row = row.next
			#end while
		#end while

		return node
	#end function

#end class
