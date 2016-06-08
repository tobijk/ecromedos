<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
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
