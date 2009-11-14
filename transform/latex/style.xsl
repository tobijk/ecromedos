<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Date:    2009/11/15
 - Author:  Tobias Koch (tkoch@ecromedos.net)
 - License: GNU General Public License, version 2
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Load style definitions from external stylesheet.
-->
<xsl:param name="global.stylesheet" select="document('style.xml')"/>

<!--
  - Set font of individual text elements (captions, labels, ...).
-->
<xsl:template name="style.elements">
	<xsl:variable name="documentclass" select="name(/*[1])"/>

	<!-- section titles -->
	<xsl:text>\setkomafont{sectioning}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/sectioning-title"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{part}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/part-title"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:if test="$documentclass != 'article'">
		<xsl:text>\setkomafont{chapter}{</xsl:text>
			<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/chapter-title"/>
		<xsl:text>}&#x0a;</xsl:text>
	</xsl:if>
	<xsl:text>\setkomafont{section}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/section-title"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{subsection}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/subsection-title"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{subsubsection}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/subsubsection-title"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{paragraph}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/paragraph-title"/>
	<xsl:text>}&#x0a;&#x0a;</xsl:text>

	<!-- document title -->
	<xsl:text>\setkomafont{title}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/document-title"/>
	<xsl:text>}&#x0a;&#x0a;</xsl:text>

	<!-- page head -->
	<xsl:text>\setkomafont{pagehead}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/page-head"/>
	<xsl:text>}&#x0a;&#x0a;</xsl:text>

	<!-- labels, footnotes, ... -->
	<xsl:text>\setkomafont{descriptionlabel}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/description-label"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{footnote}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/footnote"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{footnotelabel}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/footnote-label"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{footnotereference}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/footnote-reference"/>
	<xsl:text>}&#x0a;&#x0a;</xsl:text>

	<!-- page number, part number, ... -->
	<xsl:text>\setkomafont{pagenumber}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/page-number"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\setkomafont{partnumber}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/part-number"/>
	<xsl:text>}&#x0a;&#x0a;</xsl:text>

</xsl:template>

<!--
  - Set header and footer layout.
-->
<xsl:template name="style.pagestyle">
	<xsl:variable name="documentclass" select="name(/*[1])"/>

	<xsl:text>\renewcommand*{\partpagestyle}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/partpage-style"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:if test="$documentclass != 'article'">
		<xsl:text>\renewcommand*{\chapterpagestyle}{</xsl:text>
			<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/chapterpage-style"/>
		<xsl:text>}&#x0a;</xsl:text>
	</xsl:if>
	<xsl:text>\renewcommand*{\indexpagestyle}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/indexpage-style"/>
	<xsl:text>}&#x0a;</xsl:text>
	<xsl:text>\renewcommand*{\titlepagestyle}{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/titlepage-style"/>
	<xsl:text>}&#x0a;&#x0a;</xsl:text>

	<!-- page head/foot -->
	<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/page-head-fields"/>
</xsl:template>

<!--
  - Entry point for loading the styles.
-->
<xsl:template name="style.document">
	<xsl:variable name="documentclass" select="name(/*[1])"/>

	<!-- document font family -->
	<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/document-font"/>
	<xsl:text>&#x0a;&#x0a;</xsl:text>

	<xsl:call-template name="style.pagestyle"/>
	<xsl:call-template name="style.elements"/>

	<!-- default page style -->
	<xsl:text>\pagestyle{</xsl:text>
		<xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/page-style"/>
	<xsl:text>}&#x0a;</xsl:text>

</xsl:template>

</xsl:stylesheet>
