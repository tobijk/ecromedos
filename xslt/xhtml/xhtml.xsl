<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="global.stylesheet" select="document('style.xml')"/>

<!--
  - Filter out labels to avoid nested links.
-->
<xsl:template name="xhtml.section.title">
    <xsl:apply-templates select="child::*[not(name() = 'label')] | text()"/>
</xsl:template>

<!--
 - Determine the filename for the current node.
-->
<xsl:template name="xhtml.file">
    <xsl:choose>
        <xsl:when test="generate-id() = generate-id(/*[1])">
            <xsl:text>index.html</xsl:text>
        </xsl:when>
        <xsl:when test="name() = 'preface'">
            <xsl:text>preface</xsl:text>
            <xsl:number count="preface"/>
            <xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:when test="name() = 'index'">
            <xsl:text>index</xsl:text>
            <xsl:number count="index"/>
            <xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:when test="name() = 'part'">
            <xsl:text>part</xsl:text>
            <xsl:number count="part" format="I"/>
            <xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:when test="not(title)">
            <xsl:value-of select="name()"/><xsl:text>.html</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="name()"/>
            <xsl:call-template name="util.secprefix"/>
            <xsl:text>.html</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Print link to prev, next, ..., section
-->
<xsl:template name="xhtml.nav.link">

    <xsl:param name="curdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="direction"/>
    <xsl:param name="nodeid" select="''"/>

    <!-- determine filename -->
    <xsl:variable name="filename">
        <xsl:call-template name="xhtml.file"/>
    </xsl:variable>

    <!-- print direction -->
    <span class="nav-link-dir">
        <xsl:call-template name="i18n.print">
            <xsl:with-param name="key" select="concat('nav-', $direction)"/>
        </xsl:call-template>
        <xsl:text>: </xsl:text>
    </span>
    <!-- print link -->
    <a href="{$filename}{$nodeid}" class="nav-link">
        <xsl:choose>
            <!-- index.html -->
            <xsl:when test="generate-id() = generate-id(/*[1])">
                <xsl:call-template name="i18n.print">
                    <xsl:with-param name="key" select="'contents'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="title">
                <!-- print section counter -->
                <xsl:if test="$curdepth &lt;= $secnumdepth">
                    <xsl:variable name="prefix">
                        <xsl:call-template name="util.secprefix"/>
                    </xsl:variable>
                    <xsl:if test="$prefix != ''">
                        <xsl:call-template name="i18n.print">
                            <xsl:with-param name="key" select="'sectionnumber'"/>
                            <xsl:with-param name="number" select="$prefix"/>
                        </xsl:call-template>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:for-each select="title">
                    <xsl:call-template name="xhtml.section.title"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@title">
                <xsl:value-of select="@title"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="i18n.print">
                    <xsl:with-param name="key" select="name()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </a>
</xsl:template>

<!--
 - Load button graphic linking to prev, next, ..., section
-->
<xsl:template name="xhtml.nav.button">
    <!-- prev, up, next -->
    <xsl:param name="direction"/>
    <xsl:param name="nodeid" select="''"/>

    <!-- determine filename -->
    <xsl:variable name="filename">
        <xsl:call-template name="xhtml.file"/>
    </xsl:variable>

    <!-- load button -->
    <a href="{$filename}{$nodeid}" class="nav-button">
        <img src="{$direction}.gif" alt="{$direction}" class="nav-button"/>
    </a>
</xsl:template>

<!--
 - Prints a link to the TOC or containing section
-->
<xsl:template name="xhtml.pageup">

    <xsl:param name="curdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="mode"/>
    
    <xsl:variable name="nodeid">
        <xsl:choose>
            <xsl:when test="generate-id(parent::*) = generate-id(/*[1])">
                <xsl:value-of select="concat('#', generate-id())"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- to be extended when 'parts' are introduced -->
    <xsl:for-each select="parent::*">
        <xsl:choose>
            <xsl:when test="$mode = 'button'">
                <xsl:call-template name="xhtml.nav.button">
                    <xsl:with-param name="direction" select="'up'"/>
                    <xsl:with-param name="nodeid" select="$nodeid"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$mode = 'link'">
                <xsl:call-template name="xhtml.nav.link">
                    <xsl:with-param name="curdepth" select="$curdepth - 1"/>
                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                    <xsl:with-param name="direction" select="'up'"/>
                    <xsl:with-param name="nodeid" select="$nodeid"/>
                </xsl:call-template>        
            </xsl:when>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>

<!--
 - Prints the link to the next page.
-->
<xsl:template name="xhtml.nextpage">

    <xsl:param name="curdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="mode"/>

    <!-- if we can go deeper then first look for children -->
    <xsl:choose>
        <xsl:when test="$secsplitdepth > $curdepth">
            <xsl:choose>
                <xsl:when test="
                    child::*[
                        name() = 'chapter' or
                        name() = 'section' or
                        name() = 'subsection' or
                        name() = 'subsubsection'
                    ]">
                    <!-- select first child -->
                    <xsl:for-each select="
                        child::*[
                            name() = 'chapter' or
                            name() = 'section' or
                            name() = 'subsection' or
                            name() = 'subsubsection'
                        ][1]">
                        <xsl:choose>
                            <xsl:when test="$mode = 'button'">
                                <xsl:call-template name="xhtml.nav.button">
                                    <xsl:with-param name="direction" select="'next'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$mode = 'link'">
                                <xsl:call-template name="xhtml.nav.link">
                                    <xsl:with-param name="curdepth" select="$curdepth + 1"/>
                                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                                    <xsl:with-param name="direction" select="'next'"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <!-- none eligible found, look in ancestor chain for a following sibling -->
                <xsl:otherwise>
                    <xsl:call-template name="xhtml.firstfollowing">
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="mode" select="$mode"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <!-- recurse back through ancestor chain and look for a following-sibling -->
        <xsl:otherwise>
            <xsl:call-template name="xhtml.firstfollowing">
                <xsl:with-param name="curdepth" select="$curdepth"/>
                <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                <xsl:with-param name="mode" select="$mode"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Helper template called by 'xhtml.nextpage' to find the first
 - following sibling in the chain of ancestors.
-->
<xsl:template name="xhtml.firstfollowing">

    <xsl:param name="curdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="mode"/>

    <!-- is there a node following? -->
    <xsl:choose>
        <xsl:when test="following-sibling::*[not(substring(name(),1,4) = 'make')]">
            <xsl:for-each select="following-sibling::*[not(substring(name(),1,4) = 'make')][1]">
                <xsl:choose>
                    <xsl:when test="$mode = 'button'">
                        <xsl:call-template name="xhtml.nav.button">
                            <xsl:with-param name="direction" select="'next'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$mode = 'link'">
                        <xsl:call-template name="xhtml.nav.link">
                            <xsl:with-param name="curdepth" select="$curdepth"/>
                            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                            <xsl:with-param name="direction" select="'next'"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:when>
        <!-- go back to parent's level and try again -->
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="name(parent::*) = name(/*[1])">
                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="parent::*">
                        <xsl:call-template name="xhtml.firstfollowing">
                            <xsl:with-param name="curdepth" select="$curdepth - 1"/>
                            <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                            <xsl:with-param name="mode" select="$mode"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Helper template called by 'xhtml.prevpage' to find the last child
 - of all descendants of a node where the descendants are at the level
 - of chunking.
-->
<xsl:template name="xhtml.lastvisiblechild">

    <xsl:param name="curdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="mode"/>

    <!-- check if we contain subsections -->
    <xsl:choose>
        <xsl:when test="($secsplitdepth > $curdepth) and
            child::*[
                name() = 'chapter' or
                name() = 'section' or
                name() = 'subsection' or
                name() = 'subsubsection'
            ]">
            <!-- select the last one and recurse -->
            <xsl:for-each select="
                child::*[
                    name() = 'chapter' or
                    name() = 'section' or
                    name() = 'subsection' or
                    name() = 'subsubsection'
                ][last()]">
                <xsl:call-template name="xhtml.lastvisiblechild">
                    <xsl:with-param name="curdepth" select="$curdepth + 1"/>
                    <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                    <xsl:with-param name="mode" select="$mode"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:when>
        <!-- cannot go deeper, so it's us -->
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="$mode = 'button'">
                    <xsl:call-template name="xhtml.nav.button">
                        <xsl:with-param name="direction" select="'prev'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$mode = 'link'">
                    <xsl:call-template name="xhtml.nav.link">
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="direction" select="'prev'"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Prints the link to the previous page.
-->
<xsl:template name="xhtml.prevpage">

    <xsl:param name="curdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="mode"/>

    <!-- look for a preceding section -->
    <xsl:choose>
        <xsl:when test="
            preceding-sibling::*[
                name() = 'abstract' or
                name() = 'part' or
                name() = 'preface' or
                name() = 'chapter' or
                name() = 'section' or
                name() = 'subsection' or
                name() = 'subsubsection' or
                name() = 'appendix' or
                name() = 'glossary' or
                name() = 'biblio' or
                name() = 'index'
            ]">
            <!-- and search the last visible descendant -->
            <xsl:for-each select="
                preceding-sibling::*[
                    name() = 'abstract' or
                    name() = 'part' or
                    name() = 'preface' or
                    name() = 'chapter' or
                    name() = 'section' or
                    name() = 'subsection' or
                    name() = 'subsubsection' or
                    name() = 'appendix' or
                    name() = 'glossary' or
                    name() = 'biblio' or
                    name() = 'index'
                ][1]">
                <xsl:call-template name="xhtml.lastvisiblechild">
                    <xsl:with-param name="curdepth" select="$curdepth"/>
                    <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                    <xsl:with-param name="mode" select="$mode"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:when>
        <!-- if there's no preceding sibling, then our parent is the node we're looking for -->
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="parent::*[not(name() = name(/*[1]))]">
                    <xsl:for-each select="parent::*">
                        <xsl:choose>
                            <xsl:when test="$mode = 'button'">
                                <xsl:call-template name="xhtml.nav.button">
                                    <xsl:with-param name="direction" select="'prev'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$mode = 'link'">
                                <xsl:call-template name="xhtml.nav.link">
                                    <xsl:with-param name="curdepth" select="$curdepth - 1"/>
                                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                                    <xsl:with-param name="direction" select="'prev'"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Print the page head and the navigation bar.
-->
<xsl:template name="xhtml.pagehead">

    <xsl:param name="secsplitdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="curdepth"/>

    <div class="nav-top">
        <div class="container">
            <div class="row">
                <!-- print title -->
                <div class="s-span12 m-span09 l-span09 s-center m-left-align l-left-align nav-top-title">
                    <xsl:call-template name="util.print.title"/>
                </div>
                <!-- show buttons -->
                <div class="s-span12 m-span03 l-span03 s-center m-right-align l-right-align nav-top-buttons">
                    <xsl:call-template name="xhtml.prevpage">
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="mode" select="'button'"/>
                    </xsl:call-template>
                    <xsl:call-template name="xhtml.pageup">
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="mode" select="'button'"/>
                    </xsl:call-template>
                    <xsl:call-template name="xhtml.nextpage">
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="mode" select="'button'"/>
                    </xsl:call-template>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

<!--
 - Print the page foot and navigation bar.
-->
<xsl:template name="xhtml.pagefoot">

    <xsl:param name="secsplitdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="curdepth"/>

    <div class="nav-bottom">
        <div class="container">
            <div class="row">
                <div class="s-span12 m-span04 l-span04 s-center m-left-align l-left-align">
                    <xsl:call-template name="xhtml.prevpage">
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="mode" select="'link'"/>
                    </xsl:call-template>
                </div>
                <div class="s-span12 m-span04 l-span04 s-center m-center l-center">
                    <xsl:call-template name="xhtml.pageup">
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="mode" select="'link'"/>
                    </xsl:call-template>
                </div>
                <div class="s-span12 m-span04 l-span04 s-center m-right-align l-right-align">
                    <xsl:call-template name="xhtml.nextpage">
                        <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                        <xsl:with-param name="curdepth" select="$curdepth"/>
                        <xsl:with-param name="mode" select="'link'"/>
                    </xsl:call-template>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

<!--
  - Print CSS definitions
-->
<xsl:template name="css.definitions">
    <xsl:value-of select="$global.stylesheet/style/css"/>
</xsl:template>

<!--
  - Print CSS definitions to external file
-->
<xsl:template name="css.stylesheet">
    <xsl:document href="style.css" method="text" indent="no" encoding="UTF-8">
        <xsl:call-template name="css.definitions"/>
    </xsl:document>
</xsl:template>

<!--
  - Print CSS definitions inline
-->
<xsl:template name="css.inline">
    <style type="text/css">
        <xsl:comment>
            <xsl:call-template name="css.definitions"/>
        </xsl:comment>
    </style>
</xsl:template>

</xsl:stylesheet>
