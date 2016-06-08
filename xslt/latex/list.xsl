<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- bullet list -->
<xsl:template match="ul">
    <xsl:text>\begin{itemize}&#x0a;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{itemize}%&#x0a;</xsl:text>
    <xsl:call-template name="footnotetext"/>
    <!-- end paragraph -->
    <xsl:call-template name="text.end.para"/>
</xsl:template>

<!-- enumerated list -->
<xsl:template match="ol">

    <xsl:variable name="num_ancestors">
        <xsl:value-of select="count(ancestor::ol)"/>
    </xsl:variable>
    <xsl:variable name="countername">
        <xsl:choose>
            <xsl:when test="$num_ancestors = 3">
                <xsl:text>enumiv</xsl:text>
            </xsl:when>
            <xsl:when test="$num_ancestors = 2">
                <xsl:text>enumiii</xsl:text>
            </xsl:when>
            <xsl:when test="$num_ancestors = 1">
                <xsl:text>enumii</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>enumi</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="style">
        <xsl:choose>
            <xsl:when test="@type">
                <xsl:choose>
                    <xsl:when test="@type = 'a'">
                        <xsl:text>\alph{</xsl:text><xsl:value-of select="$countername"/><xsl:text>})</xsl:text>
                    </xsl:when>
                    <xsl:when test="@type = 'A'">
                        <xsl:text>\Alph{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:when>
                    <xsl:when test="@type = 'i'">
                        <xsl:text>\roman{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:when>
                    <xsl:when test="@type = 'I'">
                        <xsl:text>\Roman{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\arabic{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$num_ancestors = 3">
                        <xsl:text>\Alph{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:when>
                    <xsl:when test="$num_ancestors = 2">
                        <xsl:text>\roman{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:when>
                    <xsl:when test="$num_ancestors = 1">
                        <xsl:text>\alph{</xsl:text><xsl:value-of select="$countername"/><xsl:text>})</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\arabic{</xsl:text><xsl:value-of select="$countername"/><xsl:text>}.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:text>{</xsl:text>
    <xsl:if test="$style != ''">
        <xsl:text>\renewcommand{\label</xsl:text>
            <xsl:value-of select="$countername"/>
        <xsl:text>}{</xsl:text>
            <xsl:value-of select="$style"/>
        <xsl:text>}%&#x0a;</xsl:text>
    </xsl:if>
    <xsl:text>\begin{enumerate}&#x0a;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{enumerate}}%&#x0a;</xsl:text>
    <xsl:call-template name="footnotetext"/>
    <!-- end paragraph -->
    <xsl:call-template name="text.end.para"/>
</xsl:template>

<!-- list item in bullet/enumerated list -->
<xsl:template match="li">
    <xsl:text>\item{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}&#x0a;</xsl:text>
</xsl:template>

<!-- glossary list -->
<xsl:template match="dl">
    <xsl:text>\begin{description}&#x0a;</xsl:text>
    <xsl:apply-templates select="dt|dd"/>
    <xsl:text>\end{description}%&#x0a;</xsl:text>
    <xsl:call-template name="footnotetext"/>
    <!-- end paragraph -->
    <xsl:call-template name="text.end.para"/>
</xsl:template>

<!-- item in glossary list... -->
<xsl:template match="dt">
    <xsl:text>\item[{\parbox[b]{\linewidth}{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}}]</xsl:text>
</xsl:template>

<!-- ...and its definition -->
<xsl:template match="dd">
    <xsl:text>{\hfill{}\mbox{}\newline{}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}&#x0a;</xsl:text>
</xsl:template>

</xsl:stylesheet>
