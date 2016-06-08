<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Set an in-text image. Note that this is _not_ called
  - for images that are set within a 'figure' environment.
-->
<xsl:template match="img">
    <xsl:variable name="printwidth">
        <xsl:choose>
            <xsl:when test="@print-width">
                <xsl:value-of select="@print-width"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>3cm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:text>\hspace{0.25em}\parbox[c]{</xsl:text>
        <xsl:value-of select="$printwidth"/>
    <xsl:text>}{\vspace{0.5ex}\includegraphics[width=</xsl:text>
        <xsl:value-of select="$printwidth"/>
    <xsl:text>]{</xsl:text>
        <xsl:value-of select="@src"/>
    <xsl:text>}\vspace{0.5ex}}\hspace{0.25em}</xsl:text>    
</xsl:template>

<!--
  - Catch 'figure' node and determine context
-->
<xsl:template match="figure">
    <xsl:choose>
        <xsl:when test="ancestor::p">
            <xsl:call-template name="figure.inline"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="figure.block"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Extract width attribute
-->
<xsl:template name="figure.width">
    <xsl:param name="width"/>
    <xsl:choose>
        <xsl:when test="substring($width, string-length($width), string-length($width)) = '%'">
            <xsl:variable name="percent">
                <xsl:value-of select="number(substring($width, 1, string-length($width) - 1))"/>
            </xsl:variable>
            <xsl:value-of select="$percent div 100.0"/>
            <xsl:text>\linewidth</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$width"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Set an inline figure
-->
<xsl:template name="figure.inline">

    <xsl:variable name="width">
        <xsl:choose>
            <xsl:when test="img/@print-width">
                <xsl:call-template name="figure.width">
                    <xsl:with-param name="width" select="normalize-space(img/@print-width)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0.5\linewidth</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:text>\begin{wrapfigure}{</xsl:text>
    <xsl:choose>
        <xsl:when test="@align = 'right'">
            <xsl:text>r</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>l</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}[0cm]{</xsl:text>
    <xsl:value-of select="$width"/>
    <xsl:text>}%&#x0a;</xsl:text>
    <xsl:text>\includegraphics[width=\linewidth]{</xsl:text>
    <xsl:value-of select="img/@src"/>
    <xsl:text>}%&#x0a;</xsl:text>
    <xsl:if test="caption">
        <xsl:text>\caption{</xsl:text>
            <xsl:apply-templates select="caption"/>
        <xsl:text>}%&#x0a;</xsl:text>
    </xsl:if>
    <xsl:if test="@id">
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>\end{wrapfigure}</xsl:text>
</xsl:template>

<!--
  - Set a block figure
-->
<xsl:template name="figure.block">

    <!-- is parent a sectioning element? -->
    <xsl:variable name="parent.issection">
        <xsl:call-template name="util.parent.issection"/>
    </xsl:variable>

    <!-- table width -->
    <xsl:variable name="figure.width">
        <xsl:choose>
            <xsl:when test="img/@print-width">
                <xsl:call-template name="figure.width">
                    <xsl:with-param name="width" select="normalize-space(img/@print-width)"/>
                    <xsl:with-param name="reflen" select="'linewidth'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\linewidth</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- open figure environment -->
    <xsl:choose>
        <xsl:when test="$parent.issection = 1">
            <xsl:text>\begin{figure}[</xsl:text>
            <xsl:choose>
                <xsl:when test="@float='yes'">
                    <xsl:text>h!</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>H</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>]%&#x0a;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\begin{blockelement}%&#x0a;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>

    <!-- read graphic -->
    <xsl:text>\begin{minipage}{\linewidth}%&#x0a;</xsl:text>
    <xsl:choose>
        <xsl:when test="@align = 'left'">
            <xsl:text></xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'right'">
            <xsl:text>\hfill</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\centering</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
        <xsl:when test="@border = 'yes'">
            <xsl:text>\fbox{\includegraphics[width=</xsl:text>
                <xsl:value-of select="$figure.width"/>
            <xsl:text>]{</xsl:text>
                <xsl:value-of select="img/@src"/>
            <xsl:text>}}%&#x0a;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\includegraphics[width=</xsl:text>
                <xsl:value-of select="$figure.width"/>
            <xsl:text>]{</xsl:text>
                <xsl:value-of select="img/@src"/>
            <xsl:text>}%&#x0a;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\end{minipage}%&#x0a;</xsl:text>

    <!-- caption -->
    <xsl:if test="caption and $parent.issection = 1">
        <xsl:choose>
            <xsl:when test="@align = 'left'">
                <xsl:text>\captionsetup{singlelinecheck=off,justification=raggedright}&#x0a;</xsl:text>
            </xsl:when>
            <xsl:when test="@align = 'right'">
                <xsl:text>\captionsetup{singlelinecheck=off,justification=raggedleft}&#x0a;</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:text>\caption{</xsl:text>
            <!-- label -->
            <xsl:if test="@id">
                <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="@id"/>
                <xsl:text>}</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="caption"/>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>

    <xsl:choose>
        <xsl:when test="$parent.issection = 1">
            <xsl:text>\end{figure}&#x0a;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\end{blockelement}&#x0a;</xsl:text>
            <!-- end paragraph -->
            <xsl:call-template name="text.end.para"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
