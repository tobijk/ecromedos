<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Print a reference to a bibliography entry.
-->
<xsl:template match="cite">
    <xsl:variable name="secsplitdepth">
        <xsl:call-template name="util.secsplitdepth"/>
    </xsl:variable>
    <xsl:variable name="idref" select="@idref"/>
    <xsl:variable name="file">
        <xsl:choose>
            <xsl:when test="$secsplitdepth > 0">
                <xsl:text>biblio.html</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:text>[</xsl:text>
    <a href="{$file}#{generate-id(//biblio/bibitem[@id=$idref])}" class="bib">
        <xsl:choose>
            <xsl:when test="//biblio/@number='no'">
                <xsl:value-of select="//biblio/bibitem[@id=$idref]/@label"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="count(//biblio/bibitem[@id = $idref]/preceding-sibling::*) + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </a>
    <xsl:text>]</xsl:text>
</xsl:template>

<!--
  - Process the bibliography.
-->
<xsl:template match="biblio">
    <table class="biblio block-element">
        <xsl:choose>
            <xsl:when test="@number='no'">
                <xsl:apply-templates select="bibitem" mode="manual"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="bibitem" mode="auto"/>            
            </xsl:otherwise>
        </xsl:choose>
    </table>
</xsl:template>

<!--
  - Process a bibliography item in autonumbering mode.
-->
<xsl:template match="bibitem" mode="auto">
    <tr>
        <td class="biblio-label-auto">
            <a name="{generate-id()}" id="{generate-id()}"></a>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text>]</xsl:text>
        </td>
        <td class="biblio-text">
            <xsl:apply-templates/>
        </td>
    </tr>
</xsl:template>

<!--
  - Set a bibliography item with the user-defined label.
-->
<xsl:template match="bibitem" mode="manual">
    <tr>
        <td class="biblio-label-manual">
            <a name="{generate-id()}" id="{generate-id()}"></a>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@label"/>
            <xsl:text>]</xsl:text>
        </td>
        <td class="biblio-text">
            <xsl:apply-templates/>
        </td>
    </tr>
</xsl:template>

</xsl:stylesheet>
