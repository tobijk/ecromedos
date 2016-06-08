<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
 - All 'make-index' elements are replaced with an 'index' section
 - by the pre-processor. So this should never match, unless in draft mode.
-->
<xsl:template match="make-index">
    <!-- cut -->
</xsl:template>

<!--
 - Processes an index environment. Items have already been
 - sorted by the pre-processor.
-->
<xsl:template match="index">
    <xsl:text>\begin{multicols}{</xsl:text>
    <!-- number of columns -->
    <xsl:choose>
        <xsl:when test="@columns">
            <xsl:value-of select="@columns"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>2</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}[</xsl:text>
    <xsl:if test="not(@tocentry) or @tocentry != 'no'">
        <xsl:text>\addchap{</xsl:text>
    </xsl:if>
    <!-- index name -->
    <xsl:choose>
        <xsl:when test="@title">
            <xsl:value-of select="normalize-space(@title)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="i18n.print">
                <xsl:with-param name="key" select="'index'"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not(@tocentry) or @tocentry != 'no'">
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>]&#x0a;</xsl:text>

    <!-- set parskip, parindent and columnsep -->
    <xsl:text>\setlength{\parindent}{0em}&#x0a;</xsl:text>
    <xsl:text>\setlength{\parskip}{0ex}&#x0a;</xsl:text>
    <xsl:text>\makeatletter&#x0a;</xsl:text>
    <xsl:text>\let\item\@idxitem&#x0a;</xsl:text>
    <xsl:text>\makeatother&#x0a;</xsl:text>

    <!-- render sections -->
    <xsl:for-each select="idxsection[child::item]">
        <xsl:apply-templates select="."/>
    </xsl:for-each>

    <xsl:text>\end{multicols}&#x0a;&#x0a;</xsl:text>
</xsl:template>

<!--
 - Renders an index section.
-->
<xsl:template match="idxsection">
    <!-- section name, usually a
    letter from the alphabet -->
    <xsl:if test="@name">
        <xsl:text>\vspace{3ex plus .5ex minus .25ex}{\sffamily\bfseries\large{}</xsl:text>
        <xsl:value-of select="normalize-space(@name)"/>
        <xsl:text>}\hfil\nopagebreak\vspace{3pt}</xsl:text>
    </xsl:if>
    <!-- render items -->
    <xsl:for-each select="item|subitem|subsubitem">
        <xsl:text>\</xsl:text><xsl:value-of select="name()"/><xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#x0a;&#x0a;</xsl:text>
    </xsl:for-each>
</xsl:template>

<!--
 - Translates 'idxref' elements into \pagerefs.
-->
<xsl:template match="idxref">
    <xsl:if test="not(preceding-sibling::idxref)">
        <xsl:text>\dotfill</xsl:text>
    </xsl:if>
    <xsl:text>\pageref{</xsl:text>
        <xsl:value-of select="@idref"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<!--
 - All 'idxterm' elements are replaced with an in-text label
 - by the pre-processor. So this should never match, unless in draft mode.
-->
<xsl:template match="idxterm">
    <!-- cut -->
</xsl:template>

</xsl:stylesheet>
