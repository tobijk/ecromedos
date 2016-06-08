<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Print table of contents.
-->
<xsl:template name="toc.make">

    <!-- depth of toc -->
    <xsl:variable name="tocdepth">
        <xsl:call-template name="util.tocdepth"/>
    </xsl:variable>

    <!-- in-section overview -->
    <xsl:if test="//part/make-overview">
        <xsl:text>\doparttoc{}&#x0a;</xsl:text>
    </xsl:if>
    <xsl:if test="//chapter/make-overview">
        <xsl:text>\dominitoc{}&#x0a;</xsl:text>
    </xsl:if>
    <xsl:if test="/article and //section/make-overview">
        <xsl:text>\dosecttoc{}&#x0a;</xsl:text>
    </xsl:if>

    <!-- make title -->
    <xsl:call-template name="toc.head"/>

    <!-- table of contents -->
    <xsl:if test="$tocdepth > 0">
        <xsl:apply-templates select="make-toc"/>
    </xsl:if>

</xsl:template>

<!--
  - Make table of contents
-->
<xsl:template match="make-toc">
    <xsl:text>\tableofcontents{}&#x0a;</xsl:text>
    <xsl:if test="@lof = 'yes'">
        <xsl:text>\listoffigures{}&#x0a;</xsl:text>
    </xsl:if>
    <xsl:if test="@lot = 'yes'">
        <xsl:text>\listoftables{}&#x0a;</xsl:text>
    </xsl:if>
    <xsl:if test="@lol = 'yes'">
        <xsl:text>\listoflistings{}&#x0a;</xsl:text>
    </xsl:if>
</xsl:template>

<!--
  - Make per chapter overview
-->
<xsl:template match="make-overview">

    <!-- HACK!!! reset table rule attributes -->
    <xsl:text>\setlength{\arrayrulewidth}{0.5pt}%&#x0a;</xsl:text>
    <xsl:text>\arrayrulecolor[rgb]{0,0,0}%&#x0a;</xsl:text>

    <!-- toggle pagenumbers -->
    <xsl:choose>
        <xsl:when test="@pagenumbers = 'no'">
            <xsl:text>\mtcsetpagenumbers{*}{off}%&#x0a;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\mtcsetpagenumbers{*}{on}%&#x0a;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>

    <!-- current sectioning depth -->
    <xsl:variable name="curdepth">
        <xsl:call-template name="util.curdepth"/>
    </xsl:variable>

    <!-- depth of minitoc -->
    <xsl:variable name="tocdepth">
        <xsl:choose>
            <xsl:when test="@depth">
                <xsl:value-of select="$curdepth + @depth"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$curdepth + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- set depth of in-section tocs -->
    <xsl:choose>
        <xsl:when test="ancestor::section">
            <xsl:text>\setcounter{secttocdepth}{</xsl:text>
                <xsl:call-template name="util.secdepth.translate">
                    <xsl:with-param name="depth" select="$tocdepth"/>
                </xsl:call-template>
            <xsl:text>}&#x0a;&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::chapter">
            <xsl:text>\setcounter{minitocdepth}{</xsl:text>
                <xsl:call-template name="util.secdepth.translate">
                    <xsl:with-param name="depth" select="$tocdepth"/>
                </xsl:call-template>
            <xsl:text>}&#x0a;&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::part">
            <xsl:text>\setcounter{parttocdepth}{</xsl:text>
                <xsl:call-template name="util.secdepth.translate">
                    <xsl:with-param name="depth" select="$tocdepth"/>
                </xsl:call-template>
            <xsl:text>}&#x0a;&#x0a;</xsl:text>
        </xsl:when>
    </xsl:choose>


    <!-- set overview -->
    <xsl:choose>
        <xsl:when test="parent::part">
            <xsl:text>\parttoc{}&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="parent::chapter">
            <xsl:text>\minitoc{}&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="parent::section">
            <xsl:text>\secttoc{}&#x0a;</xsl:text>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<!--
  - Generate title page.
-->
<xsl:template name="toc.head">
    <!-- subject is optional -->
    <xsl:if test="head/subject">
        <xsl:text>\subject{</xsl:text>
        <xsl:apply-templates select="head/subject"/>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>
    <!-- title is mandatory -->
    <xsl:text>\title{</xsl:text>
    <xsl:apply-templates select="head/title"/>
        <!-- subtitle is optional -->
        <xsl:if test="head/subtitle">
            <xsl:variable name="documentclass" select="name(/*[1])"/>
            <xsl:text>\\{}</xsl:text>
            <xsl:value-of select="$global.stylesheet/style/child::*[name() =
                $documentclass]/document-subtitle"/>
            <xsl:text>{}</xsl:text>
            <xsl:apply-templates select="head/subtitle"/>
        </xsl:if>
    <xsl:text>}&#x0a;</xsl:text>
    <!-- author is optional -->
    <xsl:if test="head/author">
        <xsl:text>\author{</xsl:text>
        <xsl:for-each select="head/author">
            <xsl:if test="preceding-sibling::author">
                <xsl:text>\and </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>
    <!-- date must always be set, even if undefined -->
    <xsl:text>\date{</xsl:text>
    <xsl:apply-templates select="head/date"/>
    <xsl:text>}&#x0a;</xsl:text>
    <!-- publisher is optional -->
    <xsl:if test="head/publisher">
        <xsl:text>\publishers{</xsl:text>
        <xsl:apply-templates select="head/publisher"/>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>
    <!-- dedication is optional -->
    <xsl:if test="head/dedication">
        <xsl:text>\dedication{</xsl:text>
        <xsl:apply-templates select="head/dedication"/>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>

    <!-- make title and legal shmoo -->
    <xsl:choose>
        <xsl:when test="/book">
            <xsl:text>\lowertitleback{&#x0a;</xsl:text>
                <xsl:apply-templates select="legal"/>
            <xsl:text>}&#x0a;</xsl:text>
            <xsl:text>\maketitle&#x0a;&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="/report">
            <xsl:text>\maketitle&#x0a;&#x0a;</xsl:text>
            <xsl:text>\vfill&#x0a;</xsl:text>
            <xsl:text>\thispagestyle{empty}&#x0a;</xsl:text>
            <xsl:apply-templates select="legal"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\maketitle&#x0a;&#x0a;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

</xsl:stylesheet>
