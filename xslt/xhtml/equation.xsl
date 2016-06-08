<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Set an inline math node (this is never called)
-->
<xsl:template match="m">
    <xsl:value-of select="."/>
</xsl:template>

<!--
  - Set block equation
-->
<xsl:template match="equation">
    <table border="0" cellspacing="0" cellpadding="0" class="block-element">
        <tr>
            <td class="eq-counter">
                <xsl:choose>
                    <xsl:when test="@number = 'yes'">
                        <xsl:text>(</xsl:text>
                        <xsl:call-template name="element.prefix">
                            <xsl:with-param name="element" select="'equation'"/>
                        </xsl:call-template>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <a name="{generate-id()}" id="{generate-id()}"></a>
            </td>
            <td class="eq-content">
                <xsl:apply-templates/>
            </td>
        </tr>
    </table>
</xsl:template>

<!--
  - Get combined counter for equation
-->
<xsl:template name="equation.prefix">

    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="/article">
            <xsl:number value="count(preceding::equation[@number = 'yes']) + 1"/>
        </xsl:when>
        <xsl:when test="$secnumdepth &lt;= 0">
            <xsl:text>0.</xsl:text>
            <xsl:number value="count(preceding::equation[@number = 'yes']) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::chapter">
            <xsl:value-of select="count(ancestor::chapter/preceding::chapter) + 1"/>
            <xsl:text>.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::chapter)"/>
            <xsl:number value="count(preceding::equation[
                generate-id(ancestor::chapter) = $id
                and (@number = 'yes')]) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::appendix">
            <xsl:number count="appendix" format="A"/>
            <xsl:text>.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::appendix)"/>
            <xsl:number value="count(preceding::equation[
                generate-id(ancestor::appendix) = $id
                and (@number = 'yes')]) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::section">
            <xsl:number count="section"/>
            <xsl:text>.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::section)"/>
            <xsl:number value="count(preceding::equation[
                generate-id(ancestor::section) = $id
                and (@number = 'yes')]) + 1"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>0.</xsl:text>
            <xsl:number value="count(preceding::equation[ancestor::preface and @number = 'yes']) + 1"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
