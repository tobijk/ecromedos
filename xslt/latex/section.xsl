<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
 - This is there, to allow filtering of text with the pre-processor.
-->
<xsl:template match="span">
    <xsl:apply-templates/>
</xsl:template>

<!--
 - The 'make-glossary' is replaced with a 'glossary' section
 - by the pre-processor. So this should never match, unless in draft mode.
-->
<xsl:template match="make-glossary">
    <!-- cut -->
</xsl:template>

<!--
 - All 'defterm' elements are moved to the 'glossary' section
 - by the pre-processor. So this should never match, unless in draft mode.
-->
<xsl:template match="defterm">
    <!-- cut -->
</xsl:template>

<!--
 - Sets a glossary section
-->
<xsl:template match="glossary">
    <xsl:text>{</xsl:text>
    <xsl:if test="not(@tocentry) or @tocentry != 'no'">
        <xsl:choose>
            <xsl:when test="/book or /report">
                <xsl:text>\addchap{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\addsec{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="i18n.print">
            <xsl:with-param name="key" select="'glossary'"/>
        </xsl:call-template>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>

    <!-- set parskip und parindent -->
    <xsl:text>\setlength{\parindent}{0em}&#x0a;</xsl:text>
    <xsl:text>\setlength{\parskip}{0ex}&#x0a;</xsl:text>

    <xsl:for-each select="glsection[dl/dt]">
        <xsl:if test="position() != 1">
            <xsl:text>\vspace{3ex}</xsl:text>
        </xsl:if>
        <xsl:if test="@name">
            <xsl:text>{\sffamily\bfseries\Large{}</xsl:text>
            <xsl:value-of select="normalize-space(@name)"/>
            <xsl:text>}\hfill\nopagebreak\vspace{1ex}&#x0a;</xsl:text>
        </xsl:if>
        <!-- render definition list -->
        <xsl:apply-templates/>
        <!-- end paragraph -->
        <xsl:if test="position() != last()">
            <xsl:text>&#x0a;&#x0a;</xsl:text>
        </xsl:if>
    </xsl:for-each>
    
    <!-- pop stack -->
    <xsl:text>}</xsl:text>
</xsl:template>

<!--
 - Sets an article introduction
-->
<xsl:template match="abstract">
    <xsl:choose>
        <xsl:when test="/article">
            <xsl:text>\begin{abstract}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\chapter*{</xsl:text>
            <xsl:call-template name="i18n.print">
                <xsl:with-param name="key" select="'abstract'"/>
            </xsl:call-template>
            <xsl:text>}&#x0a;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:if test="/article">
        <xsl:text>\end{abstract}</xsl:text>
    </xsl:if>
</xsl:template>

<!--
  - Entry point for printing the document.
-->
<xsl:template name="section.make">

    <!-- level of chunking -->
    <xsl:variable name="secsplitdepth">
        <xsl:call-template name="util.secsplitdepth"/>
    </xsl:variable>

    <xsl:for-each select="head/following-sibling::*[
            not(substring(name(),1,4) = 'make')
            and not(name() = 'legal')
        ]">
        <xsl:call-template name="section.print">
            <xsl:with-param name="curdepth" select="1"/>
            <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
        </xsl:call-template>
    </xsl:for-each>

</xsl:template>

<!--
 - Prints the section heading.
-->
<xsl:template name="section.title">
    <!-- choose heading weight, depeding on level -->

    <xsl:variable name="sectname">
        <xsl:choose>
            <xsl:when test="name() = 'preface'">
                <xsl:choose>
                    <xsl:when test="@tocentry='no'">
                        <xsl:value-of select="'addchap*'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'addchap'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name() = 'chapter' or name() = 'appendix'">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*[@tocentry = 'no']">
                        <xsl:value-of select="'addchap*'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'chapter'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="/article and name() = 'section'">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*[@tocentry = 'no']">
                        <xsl:value-of select="'addsec*'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'section'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text><xsl:value-of select="name()"/><xsl:text></xsl:text>
                <xsl:if test="ancestor-or-self::*[@tocentry = 'no']">
                    <xsl:text>*</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="not(title)">
            <xsl:text></xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="name() = 'appendix' and not(preceding-sibling::appendix)">
                <xsl:text>\appendix{}&#x0a;&#x0a;</xsl:text>
            </xsl:if>
            <xsl:text>\</xsl:text><xsl:value-of select="$sectname"/><xsl:text>{</xsl:text>
                <xsl:apply-templates select="title"/>
            <xsl:text>}&#x0a;&#x0a;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Prints the contents of a section and calls 'section.print' for
  - subsections.
-->
<xsl:template name="section.content">

    <xsl:param name="curdepth"/>
    <xsl:param name="secsplitdepth"/>

    <!-- HACK!!! -->
    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>
    <xsl:if test="self::chapter and $secnumdepth &gt; 0">
        <xsl:text>\setcounter{listing}{0}%&#x0a;</xsl:text>
    </xsl:if>

    <!-- print title -->
    <xsl:call-template name="section.title">
        <xsl:with-param name="curdepth" select="$curdepth"/>
    </xsl:call-template>
    <xsl:choose>
        <xsl:when test="not(title)">
            <xsl:apply-templates select="."/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:for-each select="child::*[not(name() = 'title')]">
                <xsl:choose>
                    <!-- process content -->
                    <xsl:when test="not(name() = 'chapter' or
                                        name() = 'section' or
                                        name() = 'subsection' or
                                        name() = 'subsubsection')">
                        <xsl:apply-templates select="."/>
                    </xsl:when>
                    <!-- process subsection -->
                    <xsl:otherwise>
                        <xsl:call-template name="section.print">
                            <xsl:with-param name="curdepth" select="$curdepth + 1"/>
                            <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Returns name of file that contains the calling section.
-->
<xsl:template name="section.file">
    <xsl:choose>
        <xsl:when test="name() = 'preface'">
            <xsl:text>preface</xsl:text>
            <xsl:number count="preface"/>
        </xsl:when>
        <xsl:when test="name() = 'index'">
            <xsl:text>index</xsl:text>
            <xsl:number count="index"/>
        </xsl:when>
        <xsl:when test="name() = 'part'">
            <xsl:text>part</xsl:text>
            <xsl:number format="I"/>
        </xsl:when>
        <xsl:when test="not(title)">
            <xsl:value-of select="name()"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="name()"/>
            <xsl:call-template name="util.secprefix"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Recursive template that takes care of splitting the document in
  - multiple output files and printing section contents.
-->
<xsl:template name="section.print">
    
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="curdepth"/>
    
    <xsl:choose>
        <!-- output to separate file -->
        <xsl:when test="$secsplitdepth >= $curdepth">
            <xsl:variable name="filename">
                <xsl:call-template name="section.file"/>
            </xsl:variable>
            <!-- leave include directive -->
            <xsl:text>\input{</xsl:text>
                <xsl:value-of select="$filename"/>
            <xsl:text>}&#x0a;&#x0a;</xsl:text>
            <!-- output to separate file -->
            <xsl:document href="{$filename}.tex" method="text" indent="yes" encoding="UTF-8">
                <xsl:call-template name="section.content">
                    <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                    <xsl:with-param name="curdepth" select="$curdepth"/>
                </xsl:call-template>
            </xsl:document>
        </xsl:when>
        <!-- output on the spot -->
        <xsl:otherwise>
            <xsl:call-template name="section.content">
                <xsl:with-param name="secsplitdepth" select="$secsplitdepth"/>
                <xsl:with-param name="curdepth" select="$curdepth"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - A minisection is an odd kind of section. It does not have a fixed place in
  - the section hierarchy. Instead, it can occur pretty much anywhere and only
  - serves the purpose of having a titled series of paragraphs. Minisections
  - are never numbered.
-->
<xsl:template match="minisection">
    <xsl:text>\minisec{</xsl:text>
        <xsl:apply-templates select="title"/>
    <xsl:text>}&#x0a;</xsl:text>
    <xsl:apply-templates select="title/following-sibling::*"/>
</xsl:template>

</xsl:stylesheet>
