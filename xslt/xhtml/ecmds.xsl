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
<xsl:include href="keys.xsl"/>
<xsl:include href="entities.xsl"/>
<xsl:include href="utility.xsl"/>
<xsl:include href="xhtml.xsl"/>
<xsl:include href="annotation.xsl"/>
<xsl:include href="figure.xsl"/>
<xsl:include href="equation.xsl"/>
<xsl:include href="table.xsl"/>
<xsl:include href="listing.xsl"/>
<xsl:include href="counter.xsl"/>
<xsl:include href="text.xsl"/>
<xsl:include href="color.xsl"/>
<xsl:include href="toc.xsl"/>
<xsl:include href="biblio.xsl"/>
<xsl:include href="section.xsl"/>
<xsl:include href="list.xsl"/>
<xsl:include href="index.xsl"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<!--
 - Catch root node 'book'
-->
<xsl:template match="book">
    <xsl:call-template name="xdoc.process"/>
</xsl:template>

<!--
 - Catch root node 'article'
-->
<xsl:template match="article">
    <xsl:call-template name="xdoc.process"/>
</xsl:template>

<!--
 - Catch root node 'report'
-->
<xsl:template match="report">
    <xsl:call-template name="xdoc.process"/>
</xsl:template>

<!--
 - Generic entry point for processing documents of type 'book',
 - 'article' or 'report'.
-->
<xsl:template name="xdoc.process">

    <xsl:variable name="secsplitdepth">
        <xsl:call-template name="util.secsplitdepth"/>
    </xsl:variable>

    <!-- output to file index.html -->
    <xsl:document href="index.html" method="xml" indent="no" encoding="UTF-8"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    omit-xml-declaration="yes">
        <!-- page start -->
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <meta name="generator" content="{$global.version}"/>
                <meta name="viewport" content="width=device-width,initial-scale=1.0"/>

                <title><xsl:value-of select="//head/title"/></title>

                <!-- decide if CSS is inline or separate -->
                <xsl:choose>
                    <xsl:when test="$secsplitdepth > 0">
                        <xsl:call-template name="css.stylesheet"/>
                        <link rel="stylesheet" type="text/css" href="style.css"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="css.inline"/>
                    </xsl:otherwise>
                </xsl:choose>
            </head>
            <body>
                <!-- make the coverpage -->
                <xsl:call-template name="frontpage.make"/>

                <div class="content">
                    <div class="container">
                        <div class="row">
                            <div class="span12 textbody">
                                <!-- make table of contents -->
                                <xsl:call-template name="frontpage.toc"/>
                                <!-- process sections -->
                                <xsl:call-template name="section.make"/>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:document>
</xsl:template>

</xsl:stylesheet>
