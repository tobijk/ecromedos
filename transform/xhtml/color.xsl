<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the eCromedos document preparation system
 - Date:    2006/03/09
 - Author:  Tobias Koch (tkoch@ecromedos.net)
 - License: GNU General Public License, version 2
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Color your life
-->
<xsl:template match="color">
	<xsl:choose>
		<xsl:when test="@rgb">
			<span style="color:{normalize-space(@rgb)}"><xsl:apply-templates/></span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
