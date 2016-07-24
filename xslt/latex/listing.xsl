<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Set program listing
-->
<xsl:template match="listing">
    <xsl:param name="documentclass" select="name(/*[1])"/>

    <xsl:variable name="parskip">
        <xsl:call-template name="util.getparskip"/>
    </xsl:variable>

    <!-- begin listing -->
    <xsl:text>\begin{listing}</xsl:text>
        <!-- caption and label -->
        <xsl:choose>
            <xsl:when test="caption">
                <!-- switch caption spacing -->
                <xsl:text>\setlength{\belowcaptionskip}{10pt}%&#x0a;</xsl:text>
                <xsl:text>\setlength{\abovecaptionskip}{0pt}%&#x0a;</xsl:text>
                <xsl:text>\captionsetup{singlelinecheck=off,position=top,</xsl:text>
                    <xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/caption-setup"/>
                <xsl:text>}%&#x0a;</xsl:text>
                <xsl:text>\caption{</xsl:text>
                    <xsl:apply-templates select="caption"/>
                <xsl:text>}%&#x0a;</xsl:text>
                <xsl:if test="@id">
                    <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="@id"/>
                    <xsl:text>}%&#x0a;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$parskip = 'half'">
                        <xsl:text>\vspace{1.5\parskip}%&#x0a;</xsl:text>
                    </xsl:when>
                    <xsl:when test="$parskip = 'full'">
                        <xsl:text>\vspace{\parskip}%&#x0a;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\vspace{1.2ex}%&#x0a;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <!-- program listing -->
        <xsl:apply-templates select=".//code"/>
        <xsl:choose>
            <xsl:when test="caption">
                <xsl:text>\setlength{\ecmdstmplength}{\belowcaptionskip-\parskip}%&#x0a;</xsl:text>
                <xsl:text>\vspace*{\ecmdstmplength}%&#x0a;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$parskip = 'half'">
                        <xsl:text>\vspace{0.5\parskip}%&#x0a;</xsl:text>
                    </xsl:when>
                    <xsl:when test="$parskip = 'full'">
                        <!-- noop -->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\vspace{1.2ex}%&#x0a;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:otherwise>
        </xsl:choose>
    <xsl:text>\end{listing}</xsl:text>
</xsl:template>

<!--
  - Set program listing helper
-->
<xsl:template match="code">
    <xsl:variable name="bgcolor">
        <xsl:choose>
            <xsl:when test="@bgcolor">
                <xsl:value-of select="normalize-space(@bgcolor)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>#ffffff</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:text>\rgbshadecolor{</xsl:text>
    <xsl:call-template name="color.component">
        <xsl:with-param name="component" select="substring($bgcolor, string-length($bgcolor) - 5, 2)"/>
    </xsl:call-template>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="color.component">
        <xsl:with-param name="component" select="substring($bgcolor, string-length($bgcolor) - 3, 2)"/>
    </xsl:call-template>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="color.component">
        <xsl:with-param name="component" select="substring($bgcolor, string-length($bgcolor) - 1, 2)"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>

    <xsl:text>{\setlength{\partopsep}{0ex}\setlength{\topsep}{0ex}\setlength{\parskip}{0ex}\setlength{\parindent}{0em}\noindent{}</xsl:text>
    <xsl:text>\begin{shaded*}</xsl:text>
    <xsl:text>\small\begin{alltt}</xsl:text>
        <xsl:apply-templates/>
    <xsl:text>\end{alltt}</xsl:text>
    <xsl:text>\end{shaded*}}</xsl:text>
</xsl:template>

</xsl:stylesheet>
