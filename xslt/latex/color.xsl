<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Color your life
-->
<xsl:template match="color">
    <xsl:choose>
        <xsl:when test="@rgb">
            <xsl:variable name="rgb" select="normalize-space(@rgb)"/>
            <xsl:text>\rgbcolor{</xsl:text>
            <xsl:call-template name="color.component">
                <xsl:with-param name="component" select="substring($rgb, string-length($rgb) - 5, 2)"/>
            </xsl:call-template>
            <xsl:text>}{</xsl:text>
            <xsl:call-template name="color.component">
                <xsl:with-param name="component" select="substring($rgb, string-length($rgb) - 3, 2)"/>
            </xsl:call-template>
            <xsl:text>}{</xsl:text>
            <xsl:call-template name="color.component">
                <xsl:with-param name="component" select="substring($rgb, string-length($rgb) - 1, 2)"/>
            </xsl:call-template>
            <xsl:text>}{</xsl:text>
                <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Make an x,y,z color triple from an #xxxxxx hex number
-->
<xsl:template name="color.triple">
    <xsl:param name="rgb"/>
    <xsl:call-template name="color.component">
        <xsl:with-param name="component" select="substring($rgb, string-length($rgb) - 5, 2)"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="color.component">
        <xsl:with-param name="component" select="substring($rgb, string-length($rgb) - 3, 2)"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="color.component">
        <xsl:with-param name="component" select="substring($rgb, string-length($rgb) - 1, 2)"/>
    </xsl:call-template>
</xsl:template>

<!--
  - Takes a html-format hex-number and prints a triplet of form X.YZ, X.YZ, X.YZ
-->
<xsl:template name="color.component">

    <xsl:param name="component"/>
    <xsl:variable name="c" select="translate($component, 'abcdef', 'ABCDEF')"/>

    <xsl:variable name="upper">
        <xsl:call-template name="hexchar2decimal">
            <xsl:with-param name="hexchar" select="substring($c, 1, 1)"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lower">
        <xsl:call-template name="hexchar2decimal">
            <xsl:with-param name="hexchar" select="substring($c, 2, 1)"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="($upper * 16 + $lower) div 255.0"/>
</xsl:template>

<!--
  - Convert a _single_ hex-digit to decimal
-->
<xsl:template name="hexchar2decimal">
    <xsl:param name="hexchar"/>
    <xsl:variable name="table" select="'0123456789ABCDEF'"/>
    <xsl:value-of select="number(string-length(substring-before($table,$hexchar)))"/>
</xsl:template>

</xsl:stylesheet>
