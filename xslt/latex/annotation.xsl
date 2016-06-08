<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Side note
-->
<xsl:template match="marginal">
    <xsl:text>\marginpar{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
</xsl:template>

<!--
  - Footnotes
-->
<xsl:template match="footnote">
    <xsl:choose>
        <xsl:when test="ancestor::table | ancestor::ul | ancestor::ol | ancestor::dl | ancestor::biblio | ancestor::u">
            <xsl:text>\footnotemark{}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\footnote{</xsl:text>
                <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Footnotes in lists, tables, etc.
-->
<xsl:template name="footnotetext">
    <xsl:variable name="counter" select="count(descendant::footnote)"/>
    <xsl:if test="$counter > 1">
        <xsl:text>\addtocounter{footnote}{-</xsl:text>
        <xsl:value-of select="string($counter - 1)"/>
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:for-each select="descendant::footnote">
        <xsl:text>\footnotetext{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() &lt; $counter">
            <xsl:text>\stepcounter{footnote}</xsl:text>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<!--
  - Hyperlinks
-->
<xsl:template match="link">
    <xsl:choose>
        <xsl:when test="$global.hyperref = 'yes'">
            <xsl:choose>
                <xsl:when test="@url">
                    <xsl:text>\href{</xsl:text>
                        <xsl:value-of select="@url"/>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@idref">
                    <xsl:text>\hyperref[</xsl:text>
                        <xsl:value-of select="@idref"/>
                    <xsl:text>]</xsl:text>
                </xsl:when>
            </xsl:choose>
            <!-- link text -->
            <xsl:text>{</xsl:text>
                <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
