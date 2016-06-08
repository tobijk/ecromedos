<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch (tkoch@ecromedos.net)
 - License: GNU General Public License, version 2
 - URL:     http://www.ecromedos.net
 - Date:    2009/11/15
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
 - sorted by the pre-processor (or manually).
-->
<xsl:template match="index">
    <!-- print links to index sections -->
    <xsl:if test="child::idxsection[@name]">
        <div class="idxlinks">
            <xsl:for-each select="idxsection[@name]">
                <xsl:choose>
                    <xsl:when test="item">
                        <span class="idxlink">
                            <a href="#{generate-id()}" class="idxlink">
                                <xsl:value-of select="normalize-space(@name)"/>
                            </a>
                        </span>
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="idxnolink">
                            <xsl:value-of select="normalize-space(@name)"/>
                        </span>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </div>
        <hr class="idxseparator"/>
    </xsl:if>
    <!-- render sections -->
    <xsl:for-each select="idxsection[child::item]">
        <xsl:apply-templates select="."/>
        <xsl:if test="position() != last()">
            <hr class="idxseparator"/>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<!--
 - Renders an index section. This is awfully slow.
-->
<xsl:template match="idxsection">
    <!-- section name, usually a
    letter from the alphabet -->
    <xsl:if test="@name">
        <h1 class="idxsection">
            <a id="{generate-id()}" name="{generate-id()}"></a><xsl:value-of select="normalize-space(@name)"/>
        </h1>
    </xsl:if>
    
    <!-- count items -->
    <xsl:variable name="numitem" select="count(child::*)"/>
    <xsl:variable name="rest" select="$numitem mod 2"/>
    <xsl:variable name="offset" select="floor($numitem div 2) + $rest"/>
    
    <!-- section content -->
    <table border="0" cellspacing="0" cellpadding="0" class="idxlisting">
        <tr>
            <xsl:for-each select="child::*[position() &lt;= $offset]">
                <!-- insert this item -->
                <td class="idxitem"><span class="idx{name()}"><xsl:apply-templates/></span></td>
                <!-- insert neighbor -->
                <xsl:for-each select="following-sibling::*[$offset]">
                    <td class="idxitem"><span class="idx{name()}"><xsl:apply-templates/></span></td>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="position() = last()">
                        <!-- insert extra cell, if count was odd -->
                        <xsl:if test="$rest = 1">
                            <td class="idxitem">
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </td>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- this is a bit dirty -->
                        <xsl:text disable-output-escaping="yes">&lt;/tr&gt;&lt;tr&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </tr>
    </table>
</xsl:template>

<!--
 - The pre-processor collects all 'idxterm' elements, replaces each
 - with a label and generates corresponding index items, each bearing
 - a number of 'idxref' elements pointing back at the labels.
-->
<xsl:template match="idxref">
    <xsl:variable name="number" select="count(preceding-sibling::idxref) + 1"/>
    <xsl:for-each select="key('id', @idref)">
        <xsl:variable name="filename">
            <xsl:call-template name="ref.filename"/>
        </xsl:variable>
        <xsl:text>[</xsl:text>
        <a href="{$filename}#{generate-id()}" class="idxref">
            <xsl:value-of select="$number"/>
        </a>
        <xsl:text>]</xsl:text>
    </xsl:for-each>
</xsl:template>

<!--
 - All 'idxterm' elements are replaced with an in-text label
 - by the pre-processor. So this should never match, unless in draft mode.
-->
<xsl:template match="idxterm">
    <!-- cut -->
</xsl:template>

</xsl:stylesheet>
