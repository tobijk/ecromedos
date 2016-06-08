<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Set an inline math node
-->
<xsl:template match="m">
    <xsl:choose>
        <xsl:when test="ancestor::equation">
            <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>$</xsl:text><xsl:apply-templates/><xsl:text>$</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Set a block equation
-->
<xsl:template match="equation">
    <xsl:choose>
        <xsl:when test="@number = 'yes'">
            <xsl:call-template name="equation.numbered"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="equation.plain"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Set a numbered block equation
-->
<xsl:template name="equation.numbered">
    <xsl:text>\begin{equation}</xsl:text>
    <xsl:if test="@id">
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>\end{equation}%&#x0a;</xsl:text>
</xsl:template>

<!--
  - Set a block equation without number
-->
<xsl:template name="equation.plain">
    <xsl:text>\begin{displaymath}</xsl:text>
    <xsl:if test="@id">
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>\end{displaymath}%&#x0a;</xsl:text>    
</xsl:template>

</xsl:stylesheet>
