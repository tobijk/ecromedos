<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Extract width attribute
-->
<xsl:template name="table.width">
    <xsl:param name="width"/>
    <xsl:param name="reflen" select="'linewidth'"/>
    <xsl:choose>
        <xsl:when test="substring($width, string-length($width), string-length($width)) = '%'">
            <xsl:variable name="percent">
                <xsl:value-of select="number(substring($width, 1, string-length($width) - 1))"/>
            </xsl:variable>
            <xsl:value-of select="$percent div 100.0"/>
            <xsl:value-of select="concat('\', $reflen)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$width"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
 - Catch 'table' element
-->
<xsl:template match="table">

    <!-- is parent a sectioning element? -->
    <xsl:variable name="parent.issection">
        <xsl:call-template name="util.parent.issection"/>
    </xsl:variable>

    <!-- decide whether to use longtable or tabular -->
    <xsl:choose>
        <xsl:when test="@float = 'yes' or $global.columns &gt; 1
            or $parent.issection = 0 or ancestor::table">
            <xsl:call-template name="table.tabular" select=".">
                <xsl:with-param name="parent.issection" select="$parent.issection"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="table.longtable" select="."/>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<!--
  - Setup variables, rule color, rule width, etc.
-->
<xsl:template name="table.preamble">

    <!-- number of columns -->
    <xsl:variable name="columns" select="count(colgroup/col)"/>

    <!-- set rulewidth -->
    <xsl:text>\setlength{\arrayrulewidth}{</xsl:text>
    <xsl:choose>
        <xsl:when test="@print-rulewidth">
            <xsl:value-of select="normalize-space(@print-rulewidth)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>0.76pt</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}%&#x0a;</xsl:text>

    <!-- set rulecolor -->
    <xsl:text>\arrayrulecolor[rgb]{</xsl:text>
        <xsl:choose>
            <xsl:when test="@rulecolor">
                <xsl:call-template name="color.triple">
                    <xsl:with-param name="rgb" select="normalize-space(@rulecolor)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0.0,0.0,0.0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    <xsl:text>}%&#x0a;</xsl:text>

    <!-- adjust padding -->
    <xsl:text>\setlength{\ecmdscolsep}{\tabcolsep - 0.5\arrayrulewidth}%&#x0a;</xsl:text>

    <!-- calculate table width without padding -->
    <xsl:text>\setlength{\ecmdstablewidth}{</xsl:text>
    <xsl:choose>
        <xsl:when test="@print-width">
            <xsl:call-template name="table.width">
                <xsl:with-param name="width" select="normalize-space(@print-width)"/>
                <xsl:with-param name="reflen" select="'linewidth'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\linewidth</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text> - \tabcolsep * 2 * </xsl:text>
    <xsl:value-of select="$columns"/>
    <xsl:text> - \arrayrulewidth * </xsl:text>
    <xsl:value-of select="
        count(colgroup/col[(position() != last()) 
        and contains(@frame, 'colsep')])"/>
    <xsl:if test="contains(@frame, 'left')">
        <xsl:text> - \arrayrulewidth </xsl:text>
    </xsl:if>
    <xsl:if test="contains(@frame, 'right')">
        <xsl:text> - \arrayrulewidth </xsl:text>
    </xsl:if>
    <xsl:text>}%&#x0a;</xsl:text>

</xsl:template>

<!--
  - Set floats with tabluar.
-->
<xsl:template name="table.tabular">

    <!-- is parent a sectioning element? -->
    <xsl:param name="parent.issection" select="0"/>

    <!-- table width -->
    <xsl:variable name="table.width">
        <xsl:choose>
            <xsl:when test="@print-width">
                <xsl:call-template name="table.width">
                    <xsl:with-param name="width" select="normalize-space(@print-width)"/>
                    <xsl:with-param name="reflen" select="'linewidth'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\linewidth</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- open table environment -->
    <xsl:choose>
        <xsl:when test="$parent.issection = 1">
            <xsl:text>\begin{table}[</xsl:text>
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

    <!-- setup variables, rule color, rule width, etc. -->
    <xsl:call-template name="table.preamble" select="."/>

    <!-- caption -->
    <xsl:if test="caption and $parent.issection = 1">
        <xsl:choose>
            <xsl:when test="@align = 'left'">
                <xsl:text>\captionsetup{singlelinecheck=off,justification=raggedright}%&#x0a;</xsl:text>
            </xsl:when>
            <xsl:when test="@align = 'right'">
                <xsl:text>\captionsetup{singlelinecheck=off,justification=raggedleft}%&#x0a;</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:text>\caption{</xsl:text>
            <xsl:apply-templates select="caption"/>
        <xsl:text>}%&#x0a;</xsl:text>
        <!-- label -->
        <xsl:if test="@id">
            <xsl:text>\label{</xsl:text>
                <xsl:value-of select="@id"/>
            <xsl:text>}%&#x0a;</xsl:text>
        </xsl:if>
    </xsl:if>

    <!-- alignment -->
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

    <!-- start table -->
    <xsl:text>\begin{tabular}{</xsl:text>
        <xsl:for-each select="colgroup/col">
            <xsl:text> c </xsl:text>
        </xsl:for-each>
        <xsl:text>}%&#x0a;</xsl:text>
        <!-- table top rule -->
        <xsl:if test="contains(@frame, 'top')">
            <xsl:text>\hhline{</xsl:text>
            <xsl:for-each select="colgroup/col">
                <xsl:text>-</xsl:text>
            </xsl:for-each>
            <xsl:text>}%&#x0a;</xsl:text>
        </xsl:if>
        <!-- table head -->
        <xsl:apply-templates select="th"/>
        <!-- table rows -->
        <xsl:apply-templates select="tr"/>
        <!-- table foot -->
        <xsl:apply-templates select="tf"/>
        <!-- table bottom rule -->
        <xsl:if test="contains(@frame, 'bottom')">
            <xsl:text>\hhline{</xsl:text>
            <xsl:for-each select="colgroup/col">
                <xsl:text>-</xsl:text>
            </xsl:for-each>
            <xsl:text>}%&#x0a;</xsl:text>
        </xsl:if>
    <xsl:text>\end{tabular}</xsl:text>

    <xsl:if test="@align = 'left'">
        <xsl:text>\hfill{}&#x0a;</xsl:text>
    </xsl:if>

    <!-- reset color if we're inside another table -->
    <xsl:if test="ancestor::table">
        <xsl:text>\arrayrulecolor[rgb]{</xsl:text>
            <xsl:choose>
                <xsl:when test="ancestor::table[1]/@rulecolor">
                    <xsl:call-template name="color.triple">
                        <xsl:with-param name="rgb" select="normalize-space(ancestor::table[1]/@rulecolor)"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0.0,0.0,0.0</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        <xsl:text>}%&#x0a;</xsl:text>
    </xsl:if>

    <xsl:choose>
        <xsl:when test="$parent.issection = 1">
            <xsl:if test="not(caption)">
                <xsl:text>\vspace{-0.5ex}</xsl:text>
            </xsl:if>
            <xsl:text>\end{table}%&#x0a;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\end{blockelement}</xsl:text>
            <!-- end paragraph -->
            <xsl:call-template name="text.end.para"/>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<!--
  - Set table with 'longtable' environment
-->
<xsl:template name="table.longtable">

    <!-- setup variables, rule color, rule width, etc. -->
    <xsl:call-template name="table.preamble" select="."/>

    <xsl:text>{</xsl:text>
    <xsl:choose>
        <xsl:when test="@align = 'left'">
            <xsl:text>\captionsetup{singlelinecheck=off,justification=raggedright}%&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'right'">
            <xsl:text>\captionsetup{singlelinecheck=off,justification=raggedleft}%&#x0a;</xsl:text>
        </xsl:when>
    </xsl:choose>

     <xsl:text>\setlength{\LTcapwidth}{</xsl:text>
     <xsl:choose>
        <xsl:when test="@print-width">
            <xsl:call-template name="table.width">
                <xsl:with-param name="width" select="normalize-space(@print-width)"/>
                <xsl:with-param name="reflen" select="'linewidth'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>\linewidth</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
     <xsl:text>}&#x0a;</xsl:text>


    <!-- open longtable environment -->
    <xsl:text>\begin{longtable}[</xsl:text>
    <xsl:choose>
        <xsl:when test="@align='left'">
            <xsl:text>l</xsl:text>
        </xsl:when>
        <xsl:when test="@align='right'">
            <xsl:text>r</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>c</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>]{</xsl:text>
        <xsl:for-each select="colgroup/col">
            <xsl:text> c </xsl:text>
        </xsl:for-each>
        <xsl:text>}&#x0a;</xsl:text>

        <!-- caption -->
        <xsl:if test="caption">
            <xsl:text>\caption{</xsl:text>
                <xsl:apply-templates select="caption"/>
                <xsl:if test="@id">
                    <xsl:text>\label{</xsl:text>
                    <xsl:value-of select="@id"/>
                    <xsl:text>}</xsl:text>
                </xsl:if>
            <xsl:text>}\tabularnewline&#x0a;</xsl:text>
        </xsl:if>

        <!-- table head -->
        <xsl:if test="contains(@frame, 'top')">
            <xsl:text>\hhline{</xsl:text>
            <xsl:for-each select="colgroup/col">
                <xsl:text>-</xsl:text>
            </xsl:for-each>
            <xsl:text>}&#x0a;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="th"/>
        <xsl:text>\endfirsthead&#x0a;</xsl:text>

        <!-- caption -->
        <xsl:if test="caption">
            <xsl:text>\caption{</xsl:text>
            <xsl:choose>
                <xsl:when test="shortcaption">
                    <xsl:apply-templates select="shortcaption"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="caption"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}\tabularnewline&#x0a;</xsl:text>
        </xsl:if>

        <!-- table head -->
        <xsl:if test="contains(@frame, 'top')">
            <xsl:text>\hhline{</xsl:text>
            <xsl:for-each select="colgroup/col">
                <xsl:text>-</xsl:text>
            </xsl:for-each>
            <xsl:text>}&#x0a;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="th"/>
        <xsl:text>\endhead&#x0a;</xsl:text>
        
        <!-- table foot -->
        <xsl:apply-templates select="tf"/>
        <xsl:if test="contains(@frame, 'bottom')">
            <xsl:text>\hhline{</xsl:text>
            <xsl:for-each select="colgroup/col">
                <xsl:text>-</xsl:text>
            </xsl:for-each>
            <xsl:text>}&#x0a;</xsl:text>
        </xsl:if>
        <xsl:text>\endfoot&#x0a;</xsl:text>

        <!-- table rows -->
        <xsl:apply-templates select="tr"/>
    <xsl:text>\end{longtable}</xsl:text>
    <!-- hack to adjust spacing after tables -->
    <xsl:if test="following-sibling::*[1][
        name() != 'table']">
        <xsl:choose>
            <xsl:when test="caption">
                <xsl:choose>
                    <xsl:when test="/*[1]/@parskip = 'half'">
                        <xsl:text>\vspace{-5pt}</xsl:text>
                    </xsl:when>
                    <xsl:when test="/*[1]/@parskip = 'full'">
                        <xsl:text>\vspace{-10pt}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- // -->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="/*[1]/@parskip = 'half'">
                        <xsl:text>\vspace{-8pt}</xsl:text>
                    </xsl:when>
                    <xsl:when test="/*[1]/@parskip = 'full'">
                        <xsl:text>\vspace{-14pt}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\vspace{-5pt}</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
    <xsl:text>}%&#x0a;</xsl:text>

    <!-- setup text for footnotes in table -->
    <xsl:call-template name="footnotetext"/>
</xsl:template>

<!--
  - Set a subtable
-->
<xsl:template name="table.subtable">

    <!-- number of columns -->
    <xsl:variable name="columns" select="count(colgroup/col)"/>

    <!-- adjust padding -->
    <xsl:text>\setlength{\ecmdscolsep}{\tabcolsep - 0.5\arrayrulewidth}%&#x0a;</xsl:text>

    <!-- calculate table width without padding -->
    <xsl:text>\setlength{\ecmdstablewidth}{\linewidth</xsl:text>
    <xsl:text> - \tabcolsep * 2 * </xsl:text>
    <xsl:value-of select="$columns"/>
    <xsl:text> - \arrayrulewidth * </xsl:text>
    <xsl:value-of select="
        count(colgroup/col[(position() != last()) 
        and contains(@frame, 'colsep')])"/>
    <xsl:text>}%&#x0a;</xsl:text>

    <!-- start table -->
    <xsl:text>\begin{tabular}</xsl:text>
        <!-- vertical row alignment -->
        <xsl:choose>
            <xsl:when test="parent::*/@valign = 'middle'">
                <xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="parent::*/@valign = 'bottom'">
                <xsl:text>[b]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[t]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>{</xsl:text>
        <xsl:for-each select="colgroup/col">
            <xsl:text> c </xsl:text>
        </xsl:for-each>
        <xsl:text>}%&#x0a;</xsl:text>
        <!-- table rows -->
        <xsl:apply-templates select="tr"/>
    <xsl:text>\end{tabular}%&#x0a;</xsl:text>

</xsl:template>

<!--
  - Catch table rows
-->
<xsl:template match="tr">
    <xsl:call-template name="table.row"/>
</xsl:template>

<!--
  - Catch table header rows
-->
<xsl:template match="th">
    <xsl:call-template name="table.row"/>
</xsl:template>

<!--
  - Catch table footer rows
-->
<xsl:template match="tf">
    <xsl:call-template name="table.row"/>
</xsl:template>

<!--
  - Set a table row
-->
<xsl:template name="table.row">

    <!-- draw top frame rule for footer -->
    <xsl:if test="name(self::*) = 'tf' and name(preceding-sibling::*[1]) = 'tr'">
        <xsl:if test="contains(@frame, 'top')">
            <xsl:text>\hhline{*{</xsl:text>
            <xsl:value-of select="count(parent::*/colgroup/col)"/>
            <xsl:text>}{-}}</xsl:text>
        </xsl:if>
    </xsl:if>

    <!-- process this row's cells -->
    <xsl:for-each select="td|subtable">
        <xsl:if test="not(position() = 1)">
            <xsl:text disable-output-escaping="yes"> &amp; </xsl:text>
        </xsl:if>
        <xsl:call-template name="table.cell"/>
    </xsl:for-each>
    <xsl:text>\tabularnewline&#x0a;</xsl:text>

    <!-- print frame rules -->
    <xsl:variable name="border">
        <xsl:for-each select="td|subtable">
            <xsl:if test="(position() = 1) and
                contains(parent::*/parent::table/@frame, 'left')">
                <xsl:text>|</xsl:text>
            </xsl:if>
            <!-- row separator -->
            <xsl:choose>
                <xsl:when test="
                    (contains(self::td/@frame, 'rowsep') or
                    contains(self::subtable/@frame, 'bottom') or
                    contains(parent::*/@frame, 'rowsep') or
                    contains(parent::*/parent::*/@frame, 'rowsep'))
                    and    (parent::*/following-sibling::th or
                    parent::*/following-sibling::tr or
                    parent::*/following-sibling::tf)">
                    <xsl:if test="@colspan">
                        <xsl:text>*{</xsl:text>
                        <xsl:value-of select="number(normalize-space(@colspan))"/>
                        <xsl:text>}{</xsl:text>
                    </xsl:if>

                    <!-- dash -->
                    <xsl:text>-</xsl:text>

                    <xsl:if test="@colspan">
                        <xsl:text>}</xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>~</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <!-- column separator -->
            <xsl:if test="
                ((contains(self::td/@frame, 'colsep') or
                contains(self::subtable/@frame, 'right') or
                contains(parent::*/@frame, 'colsep') or
                contains(parent::*/parent::*/@frame, 'colsep'))
                and    not(position() = last()))
                or
                ((position() = last()) and
                contains(parent::*/parent::table/@frame, 'right'))">
                <xsl:text>|</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- only print, if rule contains dashes -->
    <xsl:if test="contains($border, '-')">
        <xsl:text>\hhline{</xsl:text>
        <xsl:value-of select="$border"/>
        <xsl:text>}&#x0a;</xsl:text>
    </xsl:if>
</xsl:template>

<!--
  - Set a table cell
-->
<xsl:template name="table.cell">

        <!-- colspan -->
        <xsl:variable name="colspan">
            <xsl:choose>
                <xsl:when test="@colspan &gt; 1">
                    <xsl:value-of select="number(@colspan)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:number value="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- column number -->
        <xsl:variable name="column">
            <xsl:value-of select="
                count(preceding-sibling::*[not(@colspan &gt; 1)]) + 
                sum(preceding-sibling::*[@colspan &gt; 1]/@colspan) + 1"/>
        </xsl:variable>

        <!-- column width -->
        <xsl:variable name="colwidth">
            <xsl:for-each select="
                parent::*/parent::*/colgroup/col[
                    position() &gt;= $column and
                    position() &lt; ($column + $colspan)]">
                <xsl:call-template name="table.width">
                    <xsl:with-param name="width" select="@width"/>
                    <xsl:with-param name="reflen" select="'ecmdstablewidth'"/>
                </xsl:call-template>
                <xsl:if test="position() != last()">
                    <xsl:text> + </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <!-- if this is a multicolumn, we have to add -->
            <xsl:if test="$colspan &gt; 1">
                <xsl:text> + \tabcolsep * </xsl:text>
                <xsl:value-of select="(number($colspan) - 1) * 2"/>
                <xsl:for-each select="
                    parent::*/parent::*/colgroup/col[
                        position() &gt;= $column and
                        position() &lt; ($column + $colspan - 1) and
                        contains(@frame, 'colsep')]">
                    <xsl:text> + \arrayrulewidth </xsl:text>
                </xsl:for-each>
            </xsl:if>
            <!-- extend over open rule gaps, left hand side ... -->
            <xsl:choose>
                <xsl:when test="
                    preceding-sibling::* and
                    not(contains(preceding-sibling::td[1]/@frame, 'colsep') or
                    contains(preceding-sibling::subtable[1]/@frame, 'right') or
                    contains(parent::*/@frame, 'colsep') or
                    contains(parent::*/parent::*/@frame, 'colsep'))
                        and
                    not(position() = 1)
                        and 
                    contains(parent::*/parent::*/colgroup/col[
                        position() = ($column - 1)]/@frame, 'colsep')">
                    <xsl:text> + 0.5\arrayrulewidth </xsl:text>
                    <xsl:if test="self::subtable">
                        <xsl:text> + \ecmdscolsep </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="self::subtable">
                        <xsl:text> + \tabcolsep </xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ... and right hand side -->
            <xsl:choose>
                <xsl:when test="
                    not(contains(self::td/@frame, 'colsep') or
                    contains(self::subtable/@frame, 'right') or
                    contains(parent::*/@frame, 'colsep') or
                    contains(parent::*/parent::*/@frame, 'colsep'))
                        and
                    not(position() = last())
                        and 
                    contains(parent::*/parent::*/colgroup/col[
                        position() = ($column + $colspan - 1)]/@frame, 'colsep')">
                    <xsl:text> + 0.5\arrayrulewidth </xsl:text>
                    <xsl:if test="self::subtable">
                        <xsl:text> + \ecmdscolsep </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="self::subtable">
                        <xsl:text> + \tabcolsep </xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- color your life -->
        <xsl:variable name="rgb">
            <xsl:choose>
                <xsl:when test="@color">
                    <xsl:value-of select="normalize-space(@color)"/>
                </xsl:when>
                <xsl:when test="parent::*/@color">
                    <xsl:value-of select="normalize-space(parent::*/@color)"/>
                </xsl:when>
                <xsl:when test="parent::*/parent::subtable/@color">
                    <xsl:value-of select="parent::*/parent::subtable/@color"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text></xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- start multicolumn -->
        <xsl:text>\multicolumn{</xsl:text>
        <xsl:value-of select="$colspan"/>
        <xsl:text>}{</xsl:text>

        <!-- left table border -->
        <xsl:if test="
            position() = 1 and 
            contains(parent::*/parent::*/@frame, 'left')">
            <xsl:text>|</xsl:text>
        </xsl:if>

        <!-- adjust left hand side padding -->
        <xsl:choose>
            <xsl:when test="self::subtable">
                <xsl:text>@{}</xsl:text>
            </xsl:when>
            <xsl:when test="
                preceding-sibling::* and
                not(contains(preceding-sibling::td[1]/@frame, 'colsep') or
                contains(preceding-sibling::subtable[1]/@frame, 'right') or
                contains(parent::*/@frame, 'colsep') or
                contains(parent::*/parent::*/@frame, 'colsep'))
                    and
                not(position() = 1)
                    and 
                contains(parent::*/parent::*/colgroup/col[
                    position() = ($column - 1)]/@frame, 'colsep')">
                <xsl:text>@{\hspace{\ecmdscolsep}}</xsl:text>
            </xsl:when>
        </xsl:choose>

        <!-- color cell -->
        <xsl:if test="$rgb != '' and not(self::subtable)">
            <xsl:text>&gt;{\columncolor[rgb]{</xsl:text>
            <xsl:call-template name="color.triple">
                <xsl:with-param name="rgb" select="$rgb"/>
            </xsl:call-template>
            <xsl:text>}}</xsl:text>
        </xsl:if>

        <!-- vertical row alignment -->
        <xsl:choose>
            <xsl:when test="parent::*/@valign = 'middle'">
                <xsl:text>m{</xsl:text>
            </xsl:when>
            <xsl:when test="parent::*/@valign = 'bottom'">
                <xsl:text>b{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>p{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <!-- set cell width -->
        <xsl:value-of select="$colwidth"/>
        <xsl:text>}</xsl:text>

        <!-- remove right padding, if subtable -->
        <xsl:if test="self::subtable">
            <xsl:text>@{}</xsl:text>
        </xsl:if>

        <!-- column separator, right border -->
        <xsl:if test="
            ((contains(self::td/@frame, 'colsep') or
            contains(self::subtable/@frame, 'right') or
            contains(parent::*/@frame, 'colsep') or
            contains(parent::*/parent::*/@frame, 'colsep')) and
            not(position() = last()))
                or
            ((position() = last()) and
            contains(parent::*/parent::table/@frame, 'right'))">
            <xsl:text>|</xsl:text>
        </xsl:if>
        <xsl:text>}{</xsl:text>

        <!-- text alignment -->
        <xsl:choose>
            <xsl:when test="self::subtable">
                <!-- NOOP -->
            </xsl:when>
            <xsl:when test="@align = 'justify'">
                <xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="@align = 'right'">
                <xsl:text>\raggedleft{}%&#x0a;</xsl:text>
            </xsl:when>
            <xsl:when test="@align = 'center'">
                <xsl:text>\centering{}%&#x0a;</xsl:text>
            </xsl:when>
            <xsl:when test="parent::*/@align = 'justify'">
                <xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="parent::*/@align = 'right'">
                <xsl:text>\raggedleft{}%&#x0a;</xsl:text>
            </xsl:when>
            <xsl:when test="parent::*/@align = 'center'">
                <xsl:text>\centering{}%&#x0a;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\raggedright{}%&#x0a;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <!-- in-table paragraph skip -->
        <xsl:call-template name="util.setparskip"/>
        <!-- hack to avoid indentation of subtables -->
        <xsl:text>\noindent{}</xsl:text>

        <!-- process cell content -->
        <xsl:choose>
            <xsl:when test="self::subtable">
                <xsl:call-template name="table.subtable"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- end multicolumn -->
        <xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>
