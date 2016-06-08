<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
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
    <pre class="listing">
        <xsl:if test="@bgcolor">
            <xsl:attribute name="style">
                <xsl:text>background-color: </xsl:text>
                <xsl:value-of select="@bgcolor"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </pre>
</xsl:template>

</xsl:stylesheet>
