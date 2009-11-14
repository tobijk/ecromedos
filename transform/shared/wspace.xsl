<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Date:    2006/08/21
 - Author:  Tobias Koch (tkoch@ecromedos.net)
 - License: GNU General Public License, version 2
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
 - Elements to be stripped of their all white-space text nodes
-->
<xsl:strip-space elements="
	part
	chapter
	section
	subsection
	subsubsection
	minisection
	preface
	appendix
	glossary
	index
	td
	li
	dd
"/>

</xsl:stylesheet>
