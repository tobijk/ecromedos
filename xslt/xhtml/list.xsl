<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Process simple bullet lists.
-->
<xsl:template match="ul">
    <ul>
        <xsl:apply-templates/>
    </ul>
</xsl:template>

<!--
  - Handle enumerated lists.
-->
<xsl:template match="ol">
    <xsl:variable name="num_ancestors">
        <xsl:value-of select="count(ancestor::ol)"/>
    </xsl:variable>
    <xsl:variable name="style">
        <xsl:choose>
            <!-- explicit -->
            <xsl:when test="@type = '1'">
                <xsl:text>decimal</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'i'">
                <xsl:text>lower-roman</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'I'">
                <xsl:text>upper-roman</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'a'">
                <xsl:text>lower-alpha</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'A'">
                <xsl:text>upper-alpha</xsl:text>
            </xsl:when>
            <!-- automatic -->
            <xsl:when test="$num_ancestors = 3">
                <xsl:text>upper-alpha</xsl:text>
            </xsl:when>
            <xsl:when test="$num_ancestors = 2">
                <xsl:text>lower-roman</xsl:text>
            </xsl:when>
            <xsl:when test="$num_ancestors = 1">
                <xsl:text>lower-alpha</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>decimal</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <ol>
        <xsl:if test="$style != ''">
            <xsl:attribute name="style">
                <xsl:text>list-style-type:</xsl:text>
                <xsl:value-of select="$style"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </ol>
</xsl:template>

<!--
  - Set a list item in bullet/enumerated lists.
-->
<xsl:template match="li">
    <li>
        <xsl:apply-templates/>
    </li>
</xsl:template>

<!--
  - Process a glossary-type list.
-->
<xsl:template match="dl">
    <dl>
        <xsl:apply-templates select="dt|dd"/>
    </dl>
</xsl:template>

<!--
  - Set an item in glossary lists...
-->
<xsl:template match="dt">
    <dt>
        <b><xsl:apply-templates/></b>
    </dt>
</xsl:template>

<!--
  - ...and its definition
-->
<xsl:template match="dd">
    <dd>
        <xsl:apply-templates/>
    </dd>
</xsl:template>

<!--
  - Return item prefix for 'ref' statements
-->
<xsl:template name="listitem.prefix">
    <xsl:variable name="num_ancestors">
        <xsl:value-of select="count(ancestor::ol)"/>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="ancestor::ol[1]/@type">
            <xsl:value-of select="ancestor::ol[1]/@type"/>
        </xsl:when>
        <xsl:when test="$num_ancestors = 4">
            <xsl:number count="li" format="A"/>
        </xsl:when>
        <xsl:when test="$num_ancestors = 3">
            <xsl:number count="li" format="i"/>
        </xsl:when>
        <xsl:when test="$num_ancestors = 2">
            <xsl:number count="li" format="a"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:number count="li"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
