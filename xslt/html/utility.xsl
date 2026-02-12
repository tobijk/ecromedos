<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Returns the smaller one of the passed parameters
-->
<xsl:template name="util.min">
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:choose>
        <xsl:when test="$x > $y">
            <xsl:value-of select="$y"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$x"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Returns the user-defined section numbering depth or a default
  - value, if the user did not specify anything-
-->
<xsl:template name="util.secnumdepth">
    <!-- how deep is document actually nested? -->
    <xsl:variable name="secdepth">
        <xsl:call-template name="util.secdepth"/>
    </xsl:variable>
    <xsl:variable name="requested_secnumdepth">
        <xsl:choose>
            <xsl:when test="/*[1]/@secnumdepth">
                <xsl:value-of select="/*[1]/@secnumdepth"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number value="3"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- whichever is smaller -->
    <xsl:call-template name="util.min">
        <xsl:with-param name="x" select="$secdepth"/>
        <xsl:with-param name="y" select="$requested_secnumdepth"/>
    </xsl:call-template>
</xsl:template>

<!--
  - Returns the user-defined depth to which the document shall be split
  - in individual files or a default value, if the user did not say.
-->
<xsl:template name="util.secsplitdepth">
    <!-- how deep is document actually nested? -->
    <xsl:variable name="secdepth">
        <xsl:call-template name="util.secdepth"/>
    </xsl:variable>
    <!-- level of chunking -->
    <xsl:variable name="requested_secsplitdepth">
        <xsl:choose>
            <xsl:when test="/*[1]/@secsplitdepth">
                <xsl:value-of select="/*[1]/@secsplitdepth"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="/book">
                        <xsl:number value="2"/>
                    </xsl:when>
                    <xsl:when test="/article">
                        <xsl:number value="0"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:number value="1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- select minimum -->
    <xsl:call-template name="util.min">
        <xsl:with-param name="x" select="$secdepth"/>
        <xsl:with-param name="y" select="$requested_secsplitdepth"/>
    </xsl:call-template>
</xsl:template>

<!--
  - Determines how deep the document is actually nested.
-->
<xsl:template name="util.secdepth">
    <xsl:variable name="depth">
        <xsl:choose>
            <xsl:when test="//subsubsection">
                <xsl:number value="5"/>
            </xsl:when>
            <xsl:when test="//subsection">
                <xsl:number value="4"/>
            </xsl:when>
            <xsl:when test="//section">
                <xsl:number value="3"/>
            </xsl:when>
            <xsl:when test="/*[1]/child::*">
                <xsl:number value="2"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number value="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="$depth > 1 and not(//chapter | //appendix)">
            <xsl:value-of select="$depth - 2"/>
        </xsl:when>
        <xsl:when test="$depth > 1 and not(//part)">
            <xsl:value-of select="$depth - 1"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$depth"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Determine the numerical prefix for a given node, e.g. 'A.1.2.' for
  - Appendix A, Section 1, Subsection 2.
-->
<xsl:template name="util.secprefix">

    <xsl:variable name="prefix">
        <xsl:choose>
            <xsl:when test="name() = 'preface' or not(title)">
                <xsl:text disable-output-escaping="yes"></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="self::part">
                    <xsl:number count="part" format="I"/>
                    <!-- filler gets cut off, see below -->
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="ancestor-or-self::chapter">
                    <xsl:value-of select="count(ancestor-or-self::chapter/preceding::chapter) + 1"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="ancestor-or-self::appendix">
                    <xsl:number count="appendix" format="A"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="ancestor-or-self::section">
                    <xsl:number count="section"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="ancestor-or-self::subsection">
                    <xsl:number count="subsection"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:if test="self::subsubsection">
                    <xsl:number count="subsubsection"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:if test="$prefix != ''">
        <xsl:value-of select="substring($prefix, 1, string-length($prefix) - 1)"/>
    </xsl:if>
</xsl:template>

<!--
  - Depth of table of contents
-->
<xsl:template name="util.tocdepth">
    <!-- how deep is document actually nested? -->
    <xsl:variable name="secdepth">
        <xsl:call-template name="util.secdepth"/>
    </xsl:variable>
    <xsl:variable name="requested_tocdepth">
        <xsl:choose>
            <xsl:when test="//make-toc">
                <xsl:choose>
                    <xsl:when test="//make-toc/@depth">
                        <xsl:value-of select="//make-toc/@depth"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:number value="3"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number value="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- select smaller -->
    <xsl:call-template name="util.min">
        <xsl:with-param name="x" select="$secdepth"/>
        <xsl:with-param name="y" select="$requested_tocdepth"/>
    </xsl:call-template>
</xsl:template>

<!--
  - Determine current level in section hierarchy.
-->
<xsl:template name="util.curdepth">
    <xsl:variable name="depth">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::subsubsection">
                <xsl:number value="5"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::subsection">
                <xsl:number value="4"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::section">
                <xsl:number value="3"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::*[
                            name() = 'preface' or
                            name() = 'abstract' or
                            name() = 'chapter' or
                            name() = 'appendix' or
                            name() = 'biblio' or
                            name() = 'glossary' or
                            name() = 'index']">
                <xsl:number value="2"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::part">
                <xsl:number value="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number value="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="$depth > 1 and not(//chapter | //appendix)">
            <xsl:value-of select="$depth - 2"/>
        </xsl:when>
        <xsl:when test="$depth > 1 and not(//part)">
            <xsl:value-of select="$depth - 1"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$depth"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Returns 1 if parent is a section element or 0 otherwise
-->
<xsl:template name="util.parent.issection">
    <xsl:choose>
        <xsl:when test="
            name(parent::*) = 'preface' or
            name(parent::*) = 'appendix' or
            name(parent::*) = 'chapter' or
            name(parent::*) = 'section' or
            name(parent::*) = 'subsection' or
            name(parent::*) = 'subsubsection' or
            name(parent::*) = 'minisection'">
            <xsl:number value="1"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:number value="0"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Prints the document title without subtitles
-->
<xsl:template name="util.print.title">
    <xsl:choose>
        <xsl:when test="//head/title/br">
            <xsl:apply-templates select="//head/title/br/preceding-sibling::text()|
                //head/title/br/preceding-sibling::*//text()"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="//head/title"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
