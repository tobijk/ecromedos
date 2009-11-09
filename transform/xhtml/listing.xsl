<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the eCromedos document preparation system
 - Date:    2006/03/09
 - Author:  Tobias Koch (tkoch@ecromedos.net)
 - License: GNU General Public License, version 2
 - URL:     http://www.ecromedos.net
 - Update:  2006/12/31
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Set program listing
-->
<xsl:template match="listing">

	<xsl:variable name="prefix">
		<xsl:call-template name="element.prefix">
			<xsl:with-param name="element" select="'listing'"/>
		</xsl:call-template>
	</xsl:variable>

	<div class="listing">
		<xsl:if test="caption">
			<div class="listing-caption">
				<!-- label -->
				<a name="{generate-id()}" id="{generate-id()}"></a>
				<!-- caption -->
				<span class="caption">
					<span class="caption-counter">
						<xsl:call-template name="i18n.print">
							<xsl:with-param name="key" select="'listing'"/>
							<xsl:with-param name="number" select="$prefix"/>
							<xsl:with-param name="context" select="'caption'"/>
						</xsl:call-template>
						<xsl:text>: </xsl:text>
					</span>
					<xsl:apply-templates select="caption"/>
				</span>
			</div>
		</xsl:if>
		<xsl:apply-templates select=".//code"/>
	</div>
</xsl:template>

<!--
  - Set program listing helper
-->
<xsl:template match="code">
	<xsl:variable name="bgcolor">
		<xsl:choose>
			<xsl:when test="@bgcolor">
				<xsl:value-of select="normalize-space(@bgcolor)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>#eeeeee</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- program listing -->
	<pre class="listing" style="background-color: {$bgcolor}">
		<xsl:apply-templates/>
	</pre>
</xsl:template>

</xsl:stylesheet>
