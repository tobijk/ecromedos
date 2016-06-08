<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Cite an element from the bibliography
-->
<xsl:template match="cite">
    <xsl:variable name="idref" select="@idref"/>
    <xsl:text>\cite{</xsl:text>
        <xsl:value-of select="@idref"/>
    <xsl:text>}</xsl:text>
</xsl:template>

<!--
  - Set the bibliography
-->
<xsl:template match="biblio">
    <xsl:text>\setcounter{footnote}{0}&#x0a;</xsl:text>
    <xsl:text>\begin{thebibliography}{</xsl:text>
    <xsl:choose>
        <xsl:when test="@number='no'">
            <xsl:text>9</xsl:text>
            <xsl:apply-templates select="bibitem[1]" mode="longest"/>
            <xsl:text>9</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>9</xsl:text>
            <xsl:value-of select="count(bibitem)"/>
            <xsl:text>9</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}&#x0a;</xsl:text>
    <xsl:choose>
        <xsl:when test="@number='no'">
            <xsl:apply-templates select="bibitem" mode="manual"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="bibitem" mode="auto"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\end{thebibliography}&#x0a;&#x0a;</xsl:text>
    <xsl:call-template name="footnotetext"/>
    <xsl:text>&#x0a;&#x0a;</xsl:text>
</xsl:template>

<!--
  - Determine length of longest label in bibliography
-->
<xsl:template match="bibitem" mode="longest">
    <xsl:variable name="current" select="@label"/>
    <xsl:variable name="longest">
        <xsl:apply-templates mode="longest" select="following-sibling::bibitem[1]"/>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="string-length($current) > string-length($longest)">
            <xsl:value-of select="$current"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$longest"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Set a bibliography entry with automatic numbering
-->
<xsl:template match="bibitem" mode="auto">
    <xsl:text>\bibitem{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}&#x0a;</xsl:text>
</xsl:template>

<!--
  - Set a bibliography entry with manual labeling
-->
<xsl:template match="bibitem" mode="manual">
    <xsl:text>\bibitem[</xsl:text>
    <xsl:value-of select="@label"/>
    <xsl:text>]{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}&#x0a;</xsl:text>
</xsl:template>

</xsl:stylesheet>
