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
    <img alt="" style="vertical-align: middle; border: 0px;">
        <xsl:attribute name="src">
            <xsl:value-of select="@src"/>
        </xsl:attribute>
    </img>
</xsl:template>

<!--
  - Catch node 'figure' and determine context
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
  - Set an inline figure
-->
<xsl:template name="figure.inline">

    <xsl:variable name="style">
        <xsl:choose>
            <xsl:when test="@align='right'">
                <xsl:text>float: right; padding: 2ex 0 2ex 2ex;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>float: left; padding: 2ex 2ex 2ex 0;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="width">
        <xsl:choose>
            <xsl:when test="img/@screen-width">
                <xsl:text>width:</xsl:text>
                <xsl:value-of select="normalize-space(img/@screen-width)"/>
                <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="prefix">
        <xsl:call-template name="element.prefix">
            <xsl:with-param name="element" select="'figure'"/>
        </xsl:call-template>
    </xsl:variable>

    <span style="{$width} {$style}">
        <!-- label -->
        <a name="{generate-id()}" id="{generate-id()}"></a>
        <!-- graphic -->
        <img style="display: block" alt="">
            <xsl:attribute name="src">
                <xsl:value-of select="img/@src"/>
            </xsl:attribute>
        </img>
        <xsl:if test="caption">
        <span style="display: block; font-size: xx-small;">
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </span>
        <span style="display: block; text-align: center;">
            <span class="caption">
            <xsl:if test="$prefix != ''">
                <span class="caption-counter">
                <xsl:call-template name="i18n.print">
                    <xsl:with-param name="key" select="'figure'"/>
                    <xsl:with-param name="number" select="$prefix"/>
                    <xsl:with-param name="context" select="'caption'"/>
                </xsl:call-template>
                <xsl:text>: </xsl:text>
                </span>
            </xsl:if>
            <xsl:apply-templates select="caption"/>
            </span>
        </span>
        </xsl:if>
    </span>
</xsl:template>

<!--
  - Set a block figure
-->
<xsl:template name="figure.block">

    <!-- alignment -->
    <xsl:variable name="alignment">
        <xsl:choose>
            <xsl:when test="not(@align)">
                <xsl:text>center</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(@align)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="prefix">
        <xsl:call-template name="element.prefix">
            <xsl:with-param name="element" select="'figure'"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="border">
        <xsl:choose>
            <xsl:when test="@border = 'yes'">
                <xsl:text>border: 1px solid black;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text><!-- empty --></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- container -->
    <table border="0" cellspacing="0" cellpadding="0" width="100%" class="block-element">
        <tr>
            <td align="{$alignment}">
                <!-- figure -->
                <table border="0" cellspacing="0" cellpadding="0" width="1px">
                    <tr>
                        <td>
                            <!-- label -->
                            <a name="{generate-id()}" id="{generate-id()}"></a>
                            <!-- graphic -->
                            <img style="vertical-align: middle; {$border}" alt="">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="img/@src"/>
                                </xsl:attribute>
                            </img>
                        </td>
                    </tr>
                    <!-- caption -->
                    <xsl:if test="caption">
                        <tr>
                            <td style="font-size: xx-small;">
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </td>
                        </tr>
                        <tr align="{$alignment}">
                            <td class="caption">
                                <xsl:if test="$prefix != ''">
                                    <span class="caption-counter">
                                    <xsl:call-template name="i18n.print">
                                        <xsl:with-param name="key" select="'figure'"/>
                                        <xsl:with-param name="number" select="$prefix"/>
                                        <xsl:with-param name="context" select="'caption'"/>
                                    </xsl:call-template>
                                    <xsl:text>: </xsl:text>
                                    </span>
                                </xsl:if>
                                <xsl:apply-templates select="caption"/>
                            </td>
                        </tr>
                    </xsl:if>
                </table>
            </td>
        </tr>
    </table>
</xsl:template>

</xsl:stylesheet>
