<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="../shared/version.xsl"/>
<xsl:include href="../shared/wspace.xsl"/>

<xsl:template match="copy">
    <xsl:copy-of select="child::*|text()"/>
</xsl:template>

<xsl:include href="../i18n/i18n.xsl"/>
<xsl:include href="style.xsl"/>
<xsl:include href="entities.xsl"/>
<xsl:include href="latex.xsl"/>
<xsl:include href="utility.xsl"/>
<xsl:include href="annotation.xsl"/>
<xsl:include href="counter.xsl"/>
<xsl:include href="text.xsl"/>
<xsl:include href="color.xsl"/>
<xsl:include href="toc.xsl"/>
<xsl:include href="biblio.xsl"/>
<xsl:include href="section.xsl"/>
<xsl:include href="list.xsl"/>
<xsl:include href="equation.xsl"/>
<xsl:include href="figure.xsl"/>
<xsl:include href="table.xsl"/>
<xsl:include href="listing.xsl"/>
<xsl:include href="index.xsl"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="book">
    <xsl:call-template name="xdoc.process"/>
</xsl:template>

<xsl:template match="article">
    <xsl:call-template name="xdoc.process"/>
</xsl:template>

<xsl:template match="report">
    <xsl:call-template name="xdoc.process"/>
</xsl:template>

<xsl:template name="xdoc.process">
    <!-- output to main tex-file -->
    <xsl:document href="main.tex" method="text" indent="yes" encoding="UTF-8">
        <!-- document preamble -->
        <xsl:call-template name="latex.prepare"/>
        <!-- document start -->
        <xsl:text>\begin{document}&#x0a;&#x0a;</xsl:text>
            <!-- load stylesheet -->
            <xsl:call-template name="style.document"/>
            <!-- select babel language -->
            <xsl:call-template name="latex.babel.select"/>
            <!-- make the toc -->
            <xsl:call-template name="toc.make"/>
            <!-- process sections -->
            <xsl:call-template name="section.make"/>
        <xsl:text>\end{document}</xsl:text>
    </xsl:document>
</xsl:template>

</xsl:stylesheet>
