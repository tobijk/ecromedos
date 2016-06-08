<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Print value of a named counter
-->
<xsl:template match="counter">
    <xsl:if test="@id">
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:call-template name="counter.prefix"/>
</xsl:template>

<!--
  - Get combined prefix for 'counter' elements.
-->
<xsl:template name="counter.prefix">

    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>
    
    <xsl:variable name="group">
        <xsl:value-of select="@group"/>
    </xsl:variable>

    <xsl:variable name="sectprefix">
        <xsl:choose>
            <xsl:when test="/article or @simple = 'yes'">
                <!-- empty -->
            </xsl:when>
            <xsl:when test="$secnumdepth &lt;= 0 or ($secnumdepth &lt;= 1 and //part)">
                <xsl:text>0.</xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::chapter">
                <xsl:value-of select="count(ancestor::chapter/preceding::chapter) + 1"/>
                <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::appendix">
                <xsl:number count="appendix" format="A"/>
                <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::section">
                <xsl:number count="section"/>
                <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::preface">
                <xsl:text>0.</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="counterval">
        <xsl:choose>
            <xsl:when test="/article or @simple = 'yes'">
                <xsl:number value="count(preceding::counter[@group = $group])"/>
            </xsl:when>
            <xsl:when test="$secnumdepth &lt;= 0 or ($secnumdepth &lt;= 1 and //part)">
                <xsl:number value="count(preceding::counter[@group = $group])"/>
            </xsl:when>
            <xsl:when test="ancestor::chapter">
                <xsl:variable name="id" select="generate-id(ancestor::chapter)"/>
                <xsl:number value="count(preceding::counter[generate-id(ancestor::chapter) = $id and @group = $group])"/>
            </xsl:when>
            <xsl:when test="ancestor::appendix">
                <xsl:variable name="id" select="generate-id(ancestor::appendix)"/>
                <xsl:number value="count(preceding::counter[generate-id(ancestor::appendix) = $id and @group = $group])"/>
            </xsl:when>
            <xsl:when test="ancestor::section">
                <xsl:variable name="id" select="generate-id(ancestor::section)"/>
                <xsl:number value="count(preceding::counter[generate-id(ancestor::section) = $id and @group = $group])"/>
            </xsl:when>
            <xsl:when test="ancestor::preface">
                <xsl:variable name="id" select="generate-id(ancestor::preface)"/>
                <xsl:number value="count(preceding::counter[generate-id(ancestor::preface) = $id and @group = $group])"/>
            </xsl:when>
        </xsl:choose>    
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="@base = '0'">
            <xsl:value-of select="$sectprefix"/><xsl:text></xsl:text><xsl:value-of select="$counterval"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$sectprefix"/><xsl:text></xsl:text><xsl:value-of select="$counterval + 1"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
