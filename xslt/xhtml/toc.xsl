<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Prints document head
-->
<xsl:template name="frontpage.make">
        <!-- header -->
        <xsl:call-template name="head.make"/>
</xsl:template>

<!--
  - Prints the table of contents
-->
<xsl:template name="frontpage.toc">
    <!-- table of contents -->
    <xsl:if test="make-toc and not(make-toc/@depth) or (make-toc/@depth &gt; 0)">
        <xsl:apply-templates select="make-toc"/>
    </xsl:if>
</xsl:template>

<!--
  - Prints author, title, publisher, ...
-->
<xsl:template name="head.make">
    <div class="frontmatter">
        <div class="container">
            <div class="row">
                <div class="span12">
                    <div class="title-wrapper">

                        <!-- title -->
                        <div class="head-title">
                            <!-- subject -->
                            <xsl:if test="head/subject">
                                <div class="head-subject">
                                    <xsl:apply-templates select="head/subject"/>
                                </div>
                            </xsl:if>
                            
                            <div><xsl:apply-templates select="head/title"/></div>

                            <!-- subtitle -->
                            <xsl:if test="head/subtitle">
                                <div class="head-subtitle">
                                    <xsl:apply-templates select="head/subtitle"/>
                                </div>
                            </xsl:if>
                        </div>
                        <!-- authors -->
                        <xsl:for-each select="head/author">
                            <div class="head-author">
                                <xsl:apply-templates select="."/>
                            </div>
                        </xsl:for-each>
                        <!-- date -->
                        <xsl:if test="head/date">
                            <div class="head-date">
                                <xsl:apply-templates select="head/date"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="head/publisher">
                            <div class="head-publisher">
                                <xsl:apply-templates select="head/publisher"/>
                            </div>
                        </xsl:if>
                        <!-- legal info -->
                        <xsl:for-each select="legal">
                            <div class="head-legal">
                                <xsl:apply-templates/>
                            </div>
                        </xsl:for-each>

                    </div>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

<!--
  - Prints table of contents listing
-->
<xsl:template match="make-toc">

    <!-- parameters -->
    <xsl:variable name="tocdepth">
        <xsl:call-template name="util.tocdepth"/>
    </xsl:variable>
    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>
    <xsl:variable name="secsplitdepth">
        <xsl:call-template name="util.secsplitdepth"/>
    </xsl:variable>
    <xsl:variable name="curdepth">
        <xsl:call-template name="util.curdepth"/>
    </xsl:variable>

    <!-- "table of contents" -->
    <h1>
        <xsl:call-template name="i18n.print">
            <xsl:with-param name="key" select="'contents'"/>
        </xsl:call-template>
    </h1>
    <xsl:for-each select="following-sibling::*[not(substring(name(),1,4) = 'make')]">
        <xsl:call-template name="toc.section.print">
            <xsl:with-param name="curdepth" select="$curdepth + 1"/>
            <xsl:with-param name="tocdepth" select="$tocdepth"/>
            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
            <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
        </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="@lof = 'yes'">
        <xsl:call-template name="toc.make.listof">
            <xsl:with-param name="element" select="'figure'"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="@lot = 'yes'">
        <xsl:call-template name="toc.make.listof">
            <xsl:with-param name="element" select="'table'"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="@lol = 'yes'">
        <xsl:call-template name="toc.make.listof">
            <xsl:with-param name="element" select="'listing'"/>
        </xsl:call-template>
    </xsl:if>

</xsl:template>

<!--
  - Make a list of a given type of block element
-->
<xsl:template name="toc.make.listof">

    <!-- parms -->
    <xsl:param name="element"/>

    <!-- vars -->
    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>
    
    <!-- "list of something" -->
    <h1>
        <xsl:call-template name="i18n.print">
            <xsl:with-param name="key" select="concat('lo', substring($element, 1, 1))"/>
        </xsl:call-template>
    </h1>
    <!-- listof listing -->
    <xsl:for-each select="//*[name() = $element and child::caption]">
        <xsl:if test="position() = 1">
            <xsl:text disable-output-escaping="yes">&lt;ul class="toc"&gt;</xsl:text>
        </xsl:if>
        <xsl:variable name="filename">
            <xsl:call-template name="ref.filename"/>
        </xsl:variable>
        <xsl:variable name="prefix">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="$element"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="idnum">
            <xsl:value-of select="generate-id()"/>
        </xsl:variable>
        <!-- entry -->
        <li class="toc-mainitem">
            <a href="{$filename}#{$idnum}" class="toc-mainitem">
                <xsl:call-template name="i18n.print">
                    <xsl:with-param name="key" select="'sectionnumber'"/>
                    <xsl:with-param name="number" select="$prefix"/>
                </xsl:call-template>
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                <xsl:apply-templates select="descendant::caption"/>
            </a>
        </li>
        <xsl:if test="position() = last()">
            <xsl:text disable-output-escaping="yes">&lt;/ul&gt;</xsl:text>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<!--
  - Prints an in-section table of contents
-->
<xsl:template match="make-overview">

    <!-- parameters -->
    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>
    <xsl:variable name="secsplitdepth">
        <xsl:call-template name="util.secsplitdepth"/>
    </xsl:variable>
    <xsl:variable name="curdepth">
        <xsl:call-template name="util.curdepth"/>
    </xsl:variable>
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

    <!-- listing -->
    <xsl:if test="$tocdepth &gt; $curdepth">
        <div class="minitoc">
            <div class="minitoc-heading">
                <xsl:choose>
                    <xsl:when test="ancestor::section or ancestor::chapter">
                        <xsl:call-template name="i18n.print">
                            <xsl:with-param name="key" select="'minitoc'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="ancestor::part">
                        <xsl:call-template name="i18n.print">
                            <xsl:with-param name="key" select="'parttoc'"/>
                        </xsl:call-template>                    
                    </xsl:when>
                </xsl:choose>
            </div>
            <xsl:for-each select="following-sibling::*[
                name() = 'chapter' or
                name() = 'section' or
                name() = 'subsection' or
                name() = 'subsubsection']">
                <xsl:call-template name="toc.section.print">
                    <xsl:with-param name="curdepth" select="$curdepth + 1"/>
                    <xsl:with-param name="tocdepth" select="$tocdepth"/>
                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                    <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                </xsl:call-template>
            </xsl:for-each>
        </div>
    </xsl:if>
</xsl:template>

<!--
  - Determines the numerical prefix for a given node, i.e. A.1.2 for
  - Appendix A, Section 1, Subsection 2.
-->
<xsl:template name="toc.section.prefix">

    <xsl:param name="secnumdepth"/>
    <xsl:param name="curdepth"/>
    <xsl:param name="iteration"/>

    <xsl:choose>
        <xsl:when test="$curdepth &gt; $secnumdepth"><!-- empty --></xsl:when>
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="
                    name() = 'preface' or
                    not(title) or
                    ancestor-or-self::*[@number='no']">
                    <!-- empty -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="prefix">
                        <xsl:call-template name="util.secprefix"/>
                    </xsl:variable>
                    <xsl:call-template name="i18n.print">
                        <xsl:with-param name="key" select="'sectionnumber'"/>
                        <xsl:with-param name="number" select="$prefix"/>
                    </xsl:call-template>
                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - This is called by 'toc.section.title' to go back in the hierarchy
  - of sections to the ancestor that is on the chunking level requested
  - by by the user.
-->
<xsl:template name="toc.section.file">
    <xsl:param name="generations"/>
    <xsl:choose>
        <xsl:when test="$generations > 0">
            <xsl:for-each select="parent::*">
                <xsl:call-template name="toc.section.file">
                    <xsl:with-param name="generations" select="$generations - 1"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="name()"/>
            <xsl:call-template name="util.secprefix"/>
            <xsl:text>.html</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - We allow labels in titles of sections, but this causes a pair of nested
  - anchors to be created in the toc. So we have to filter out labels explicitely.
-->
<xsl:template name="toc.title">
    <xsl:apply-templates select="child::*[not(name() = 'label')] | text()"/>
</xsl:template>

<!--
  - This is called by 'toc.section.title' to print the actual title
  - of the section that is currently being processed. Depending on the
  - depth of chunking that the user has requested, the template determines in
  - which file the section is located and sets the hyperlink accordingly.
-->
<xsl:template name="toc.section.link">

    <xsl:param name="secsplitdepth"/>
    <xsl:param name="curdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="iteration"/>
        
    <!-- link style -->
    <xsl:variable name="link-style">
        <xsl:choose>
            <xsl:when test="$iteration = 1">
                <xsl:text>toc-mainitem</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>toc-subitem</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:choose>
        <!-- user wants chunked output -->
        <xsl:when test="$secsplitdepth > 0">
            <!-- if in toc, add suffix -->
            <xsl:variable name="node.id">
                <xsl:choose> <!-- is toc or overview? -->
                    <xsl:when test="$curdepth != $iteration">
                        <xsl:value-of select="concat(generate-id(), ':oview')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- print link -->
            <xsl:choose>
                <xsl:when test="name() = 'preface'">
                    <xsl:variable name="position" select="count(preceding-sibling::preface) + 1"/>
                    <a href="preface{$position}.html" id="{generate-id()}" name="{generate-id()}" class="{$link-style}">
                        <xsl:call-template name="toc.section.prefix">
                            <xsl:with-param name="curdepth" select="$curdepth"/>
                            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                            <xsl:with-param name="iteration" select="$iteration"/>
                        </xsl:call-template>
                        <xsl:for-each select="title">
                            <xsl:call-template name="toc.title"/>
                        </xsl:for-each>
                    </a>
                </xsl:when>
                <xsl:when test="self::index">
                    <xsl:variable name="position" select="count(preceding-sibling::index) + 1"/>
                    <a href="{name()}{$position}.html" id="{generate-id()}" name="{generate-id()}" class="{$link-style}">
                        <xsl:choose>
                            <xsl:when test="@title">
                                <xsl:value-of select="normalize-space(@title)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="i18n.print">
                                    <xsl:with-param name="key" select="name()"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </xsl:when>
                <xsl:when test="not(title)">
                    <a href="{name()}.html" id="{generate-id()}" name="{generate-id()}" class="{$link-style}">
                        <xsl:call-template name="toc.section.prefix">
                            <xsl:with-param name="curdepth" select="$curdepth"/>
                            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                            <xsl:with-param name="iteration" select="$iteration"/>
                        </xsl:call-template>
                        <xsl:call-template name="i18n.print">
                            <xsl:with-param name="key" select="name()"/>
                        </xsl:call-template>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <!-- containing file -->
                    <xsl:variable name="filename">
                        <xsl:call-template name="toc.section.file">
                            <xsl:with-param name="generations" select="$curdepth - $secsplitdepth"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <!-- section has its own file -->
                        <xsl:when test="$secsplitdepth >= $curdepth">
                            <a href="{$filename}" id="{$node.id}" name="{$node.id}" class="{$link-style}">
                                <xsl:call-template name="toc.section.prefix">
                                    <xsl:with-param name="curdepth" select="$curdepth"/>
                                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                                    <xsl:with-param name="iteration" select="$iteration"/>
                                </xsl:call-template>
                                <xsl:for-each select="title">
                                    <xsl:call-template name="toc.title"/>
                                </xsl:for-each>
                            </a>
                        </xsl:when>
                        <!-- section is contained in ancestor's file -->
                        <xsl:otherwise>
                            <a href="{$filename}#{generate-id()}" id="{$node.id}" name="{$node.id}" class="{$link-style}">
                                <xsl:call-template name="toc.section.prefix">
                                    <xsl:with-param name="curdepth" select="$curdepth"/>
                                    <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                                    <xsl:with-param name="iteration" select="$iteration"/>
                                </xsl:call-template>
                                <xsl:for-each select="title">
                                    <xsl:call-template name="toc.title"/>
                                </xsl:for-each>
                            </a>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <!-- user wants a single file -->
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="not(title)">
                    <a href="index.html#{generate-id()}" class="{$link-style}">
                        <xsl:call-template name="toc.section.prefix">
                            <xsl:with-param name="curdepth" select="$curdepth"/>
                            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                            <xsl:with-param name="iteration" select="$iteration"/>
                        </xsl:call-template>
                        <xsl:call-template name="i18n.print">
                            <xsl:with-param name="key" select="name()"/>
                        </xsl:call-template>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="index.html#{generate-id()}" class="{$link-style}">
                        <xsl:call-template name="toc.section.prefix">
                            <xsl:with-param name="curdepth" select="$curdepth"/>
                            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                            <xsl:with-param name="iteration" select="$iteration"/>
                        </xsl:call-template>
                        <xsl:for-each select="title">
                            <xsl:call-template name="toc.title"/>
                        </xsl:for-each>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - This template prints one line in the table of contents, consisting
  - of an apropriate indentation, a prefix and the title of the section.
-->
<xsl:template name="toc.section.title">

    <xsl:param name="curdepth"/>
    <xsl:param name="tocdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="iteration"/>

    <!-- determine entry's style -->
    <xsl:variable name="entry-style">
        <xsl:choose>
            <xsl:when test="$iteration = 1">
                <xsl:text>toc-mainitem</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>toc-subitem</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- print item -->
    <li class="{$entry-style}">
        <xsl:call-template name="toc.section.link">
            <xsl:with-param name="curdepth" select="$curdepth"/>
            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
            <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
            <xsl:with-param name="iteration" select="$iteration"/>
        </xsl:call-template>
        <!-- recurse into subsection -->
        <xsl:for-each select="
            child::*[
                name() = 'chapter' or
                name() = 'section' or
                name() = 'subsection' or
                name() = 'subsubsection'
            ]">
            <xsl:call-template name="toc.section.print">
                <xsl:with-param name="curdepth" select="$curdepth + 1"/>
                <xsl:with-param name="tocdepth" select="$tocdepth"/>
                <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
                <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                <xsl:with-param name="iteration" select="$iteration + 1"/>
            </xsl:call-template>
        </xsl:for-each>
    </li>
</xsl:template>

<!--
  - Recursive template to print hierachy of sections. You can start
  - and stop at arbitrary depths. Template makes no assumptions about
  - the cascading order, so this can be used for any type of document.
-->
<xsl:template name="toc.section.print">

    <xsl:param name="tocdepth"/>
    <xsl:param name="curdepth"/>
    <xsl:param name="secnumdepth"/>
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="iteration" select="1"/>

    <xsl:if test="$tocdepth >= $curdepth and not(ancestor-or-self::*[@tocentry='no'])">
        <xsl:if test="position() = 1">
            <xsl:text disable-output-escaping="yes">&lt;ul</xsl:text>
            <xsl:if test="$curdepth = 1">
                <xsl:text> class="toc"</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        </xsl:if>

        <!-- print table item -->
        <xsl:call-template name="toc.section.title">
            <xsl:with-param name="curdepth" select="$curdepth"/>
            <xsl:with-param name="tocdepth" select="$tocdepth"/>
            <xsl:with-param name="secnumdepth" select="$secnumdepth"/>
            <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
            <xsl:with-param name="iteration" select="$iteration"/>
        </xsl:call-template>

        <xsl:if test="position() = last()">
            <xsl:text disable-output-escaping="yes">&lt;/ul&gt;</xsl:text>
        </xsl:if>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
