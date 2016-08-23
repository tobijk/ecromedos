<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Calculate the width over multiple columns
-->
<xsl:template name="table.colwidth">
    <xsl:param name="column"/>
    <xsl:param name="colspan"/>
    <xsl:variable name="width">
        <xsl:for-each select="parent::*/parent::*/colgroup/col[position() = $column]">
            <xsl:call-template name="table.colwidthsum">
                <xsl:with-param name="depth" select="$colspan - 1"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$width"/><xsl:text>%</xsl:text>
</xsl:template>

<!--
  - Recursive helper for adding colunm widths
  - Called by 'table.colwidth' above.
-->
<xsl:template name="table.colwidthsum">
    <xsl:param name="depth"/>
    <xsl:choose>
        <xsl:when test="$depth &lt;= 0">
            <xsl:value-of select="normalize-space(substring-before(@width, '%'))"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="nextwidth">
                <xsl:for-each select="following-sibling::col[1]">
                    <xsl:call-template name="table.colwidthsum">
                        <xsl:with-param name="depth" select="$depth - 1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="selfwidth">
                <xsl:value-of select="normalize-space(substring-before(@width, '%'))"/>
            </xsl:variable>
            <xsl:value-of select="$selfwidth + $nextwidth"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Set a table
-->
<xsl:template match="table">

    <!-- frame rulesize -->
    <xsl:variable name="rulewidth">
        <xsl:choose>
            <xsl:when test="@screen-rulewidth">
                <xsl:value-of select="normalize-space(@screen-rulewidth)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>1px</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- frame rulecolor -->
    <xsl:variable name="rulecolor">
        <xsl:choose>
            <xsl:when test="@rulecolor">
                <xsl:value-of select="normalize-space(@rulecolor)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>#000000</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- rule -->
    <xsl:variable name="rule">
        <xsl:value-of select="$rulewidth"/>
        <xsl:text> solid </xsl:text>
        <xsl:value-of select="$rulecolor"/>
        <xsl:text>;</xsl:text>
    </xsl:variable>

    <!-- outer frame -->
    <xsl:variable name="style">
        <xsl:text>border-collapse: collapse;</xsl:text>
        <xsl:if test="contains(@frame, 'left')">
            <xsl:text>border-left: </xsl:text>
            <xsl:value-of select="$rule"/>
        </xsl:if>
        <xsl:if test="contains(@frame, 'right')">
            <xsl:text>border-right: </xsl:text>
            <xsl:value-of select="$rule"/>
        </xsl:if>
        <xsl:if test="contains(@frame, 'top')">
            <xsl:text>border-top: </xsl:text>
            <xsl:value-of select="$rule"/>
        </xsl:if>
        <xsl:if test="contains(@frame, 'bottom')">
            <xsl:text>border-bottom: </xsl:text>
            <xsl:value-of select="$rule"/>
        </xsl:if>
    </xsl:variable>

    <!-- width -->
    <xsl:variable name="width">
        <xsl:if test="@screen-width">
            <xsl:text>width:</xsl:text>
            <xsl:value-of select="normalize-space(@screen-width)"/>
            <xsl:text>;</xsl:text>
        </xsl:if>
    </xsl:variable>

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

    <!-- combined counter -->
    <xsl:variable name="prefix">
        <xsl:call-template name="element.prefix">
            <xsl:with-param name="element" select="'table'"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- check if parent is a sectioning element -->
    <xsl:variable name="parent.issection">
        <xsl:call-template name="util.parent.issection"/>
    </xsl:variable>

    <!-- container -->
    <table border="0" cellspacing="0" cellpadding="0" width="100%" class="block-element">
        <xsl:if test="caption and $parent.issection = 1">
        <tr>
            <td align="{$alignment}">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr align="center">
                        <td class="caption">
                            <xsl:if test="$prefix != ''">
                            <span class="caption-counter">
                            <xsl:call-template name="i18n.print">
                                <xsl:with-param name="key" select="'table'"/>
                                <xsl:with-param name="number" select="$prefix"/>
                                <xsl:with-param name="context" select="'caption'"/>
                            </xsl:call-template>
                            <xsl:text>: </xsl:text>
                            </span>
                            </xsl:if>
                            <!-- label -->
                            <a name="{generate-id()}" id="{generate-id()}"></a>
                            <!-- caption -->
                            <xsl:apply-templates select="caption"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: xx-small;">
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        </xsl:if>
        <tr>
            <td align="{$alignment}">
            <!-- table -->
            <table border="0" cellspacing="0" cellpadding="0" class="table" style="{$style}{$width}">
                <xsl:for-each select="th">
                    <xsl:call-template name="table.row">
                        <xsl:with-param name="rulewidth" select="$rulewidth"/>
                        <xsl:with-param name="rule" select="$rule"/>
                        <xsl:with-param name="rulecolor" select="$rulecolor"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="tr">
                    <xsl:call-template name="table.row">
                        <xsl:with-param name="rulewidth" select="$rulewidth"/>
                        <xsl:with-param name="rule" select="$rule"/>
                        <xsl:with-param name="rulecolor" select="$rulecolor"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="tf">
                    <xsl:call-template name="table.row">
                        <xsl:with-param name="rulewidth" select="$rulewidth"/>
                        <xsl:with-param name="rule" select="$rule"/>
                        <xsl:with-param name="rulecolor" select="$rulecolor"/>
                    </xsl:call-template>
                </xsl:for-each>
            </table>
            </td>
        </tr>
    </table>
</xsl:template>

<!--
  - Set a table row
-->
<xsl:template name="table.row">
    <xsl:param name="rule"/>
    <xsl:param name="rulewidth"/>
    <xsl:param name="rulecolor"/>
    <tr>
        <xsl:for-each select="td|subtable">
            <xsl:call-template name="table.cell">
                <xsl:with-param name="rule" select="$rule"/>
                <xsl:with-param name="rulewidth" select="$rulewidth"/>
                <xsl:with-param name="rulecolor" select="$rulecolor"/>
            </xsl:call-template>
        </xsl:for-each>
    </tr>
</xsl:template>

<!--
  - Set a subtable
-->
<xsl:template name="table.subtable">

    <xsl:param name="rule"/>
    <xsl:param name="rulewidth"/>
    <xsl:param name="rulecolor"/>

    <table border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse;width:100%">
        <xsl:for-each select="tr">
            <xsl:call-template name="table.row">
                <xsl:with-param name="rulewidth" select="$rulewidth"/>
                <xsl:with-param name="rule" select="$rule"/>
                <xsl:with-param name="rulecolor" select="$rulecolor"/>
            </xsl:call-template>
        </xsl:for-each>
    </table>
</xsl:template>

<!--
  - Set a table cell
-->
<xsl:template name="table.cell">

    <xsl:param name="rule"/>
    <xsl:param name="rulewidth"/>
    <xsl:param name="rulecolor"/>

    <!-- column position -->
    <xsl:variable name="column">
        <xsl:value-of select="
            count(preceding-sibling::td[not(@colspan &gt; 1)]) + 
            sum(preceding-sibling::td[@colspan &gt; 1]/@colspan) + 1"/>
    </xsl:variable>

    <!-- column span -->
    <xsl:variable name="colspan">
        <xsl:choose>
            <xsl:when test="@colspan &gt; 1">
                <xsl:value-of select="normalize-space(@colspan)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number value="1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- column width -->
    <xsl:variable name="width">
        <xsl:call-template name="table.colwidth">
            <xsl:with-param name="column" select="$column"/>
            <xsl:with-param name="colspan" select="$colspan"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="style">
        <xsl:text>width:</xsl:text>
        <xsl:value-of select="$width"/>
        <xsl:text>;</xsl:text>
        <!-- padding -->
        <xsl:choose>
            <xsl:when test="self::subtable">
                <xsl:text>padding: 0;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>padding-left: 1ex;</xsl:text>
                <xsl:text>padding-right: 1ex;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- vertical alignment -->
        <xsl:choose>
            <xsl:when test="parent::*/@valign">
                <xsl:text>vertical-align:</xsl:text>
                <xsl:value-of select="normalize-space(parent::*/@valign)"/>
                <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>vertical-align: top;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- horizontal alignment -->
        <xsl:choose>
            <xsl:when test="@align">
                <xsl:text>text-align:</xsl:text>
                <xsl:value-of select="normalize-space(@align)"/>
                <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:when test="parent::*/@align">
                <xsl:text>text-align:</xsl:text>
                <xsl:value-of select="normalize-space(parent::*/@align)"/>
                <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>text-align: left;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- footer top rule -->
        <xsl:if test="parent::tf and
            name(parent::tf/preceding-sibling::*[1]) = 'tr' and
            contains(parent::tf/@frame, 'top')">
            <xsl:text>border-top: 1px solid black;</xsl:text>
        </xsl:if>
        <!-- row separator -->
        <xsl:if test="
            (contains(self::td/@frame, 'rowsep') or
            contains(self::subtable/@frame, 'bottom') or
            contains(parent::*/@frame, 'rowsep') or
            contains(parent::*/parent::*/@frame, 'rowsep'))
            and    (parent::*/following-sibling::th or
            parent::*/following-sibling::tr or
            parent::*/following-sibling::tf)">
            <!-- dash -->
            <xsl:text>border-bottom: </xsl:text><xsl:value-of select="$rule"/>
        </xsl:if>
        <!-- column separator -->
        <xsl:if test="
            (contains(self::td/@frame, 'colsep') or
            contains(self::subtable/@frame, 'right') or
            contains(parent::*/@frame, 'colsep') or
            contains(parent::*/parent::*/@frame, 'colsep'))
            and    not(position() = last())">
            <xsl:text>border-right: </xsl:text>
            <xsl:value-of select="$rule"/>
        </xsl:if>
        <!-- background color -->
        <xsl:variable name="rgb">
            <xsl:choose>
                <xsl:when test="@color">
                    <xsl:value-of select="normalize-space(@color)"/>
                </xsl:when>
                <xsl:when test="parent::*/@color">
                    <xsl:value-of select="normalize-space(parent::*/@color)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text></xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$rgb != ''">
            <xsl:text>background-color:</xsl:text>
            <xsl:value-of select="$rgb"/>
            <xsl:text>;</xsl:text>
        </xsl:if>
    </xsl:variable>

    <td style="{$style}">
        <xsl:if test="$colspan &gt; 1">
            <xsl:attribute name="colspan">
                <xsl:value-of select="$colspan"/>
            </xsl:attribute>
        </xsl:if>
        <!-- process cell content -->
        <xsl:choose>
            <xsl:when test="self::subtable">
                <xsl:call-template name="table.subtable">
                    <xsl:with-param name="rule" select="$rule"/>
                    <xsl:with-param name="rulewidth" select="$rulewidth"/>
                    <xsl:with-param name="rulecolor" select="$rulecolor"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </td>
</xsl:template>

</xsl:stylesheet>
