<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Quotation marks
-->
<xsl:template match="qq">
    <xsl:choose>
        <xsl:when test="not(ancestor::qq)">
            <xsl:call-template name="i18n.print">
                <xsl:with-param name="key" select="'startquote'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
            <xsl:call-template name="i18n.print">
                <xsl:with-param name="key" select="'endquote'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="i18n.print">
                <xsl:with-param name="key" select="'startnestedquote'"/>
            </xsl:call-template>        
            <xsl:apply-templates/>
            <xsl:call-template name="i18n.print">
                <xsl:with-param name="key" select="'endnestedquote'"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="q">
    <xsl:call-template name="i18n.print">
        <xsl:with-param name="key" select="'startsinglequote'"/>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:call-template name="i18n.print">
        <xsl:with-param name="key" select="'endsinglequote'"/>
    </xsl:call-template>
</xsl:template>

<!--
  - Blockquotes
-->
<xsl:template match="blockquote">
    <blockquote>
        <xsl:apply-templates/>
    </blockquote>
</xsl:template>

<!--
  - Verbatim text
-->
<xsl:template match="verbatim">
    <pre class="verbatim">
        <xsl:if test="@bgcolor">
            <xsl:attribute name="style">
                <xsl:text>background-color: </xsl:text>
                <xsl:value-of select="@bgcolor"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </pre>
</xsl:template>

<!--
  - Font size
-->
<xsl:template match="xx-small">
    <span style="font-size: xx-small"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="x-small">
    <span style="font-size: x-small"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="small">
    <span style="font-size: small"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="medium">
    <span style="font-size: medium"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="large">
    <span style="font-size: large"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="x-large">
    <span style="font-size: x-large"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="xx-large">
    <span style="font-size: xx-large"><xsl:apply-templates/></span>
</xsl:template>

<!--
  - Set text in italics.
-->
<xsl:template match="i">
    <i><xsl:apply-templates/></i>
</xsl:template>

<!--
  - Set text in bold face.
-->
<xsl:template match="b">
    <b><xsl:apply-templates/></b>
</xsl:template>

<!--
  - Underline text.
-->
<xsl:template match="u">
    <span style="text-decoration: underline;"><xsl:apply-templates/></span>
</xsl:template>

<!--
  - Set typewriter text.
-->
<xsl:template match="tt">
    <span class="tt"><xsl:apply-templates/></span>
</xsl:template>

<!--
 - Set text in superscript.
-->
<xsl:template match="sup">
    <sup><xsl:apply-templates/></sup>
</xsl:template>

<!--
 - Set text in subscript.
-->
<xsl:template match="sub">
    <sub><xsl:apply-templates/></sub>
</xsl:template>

<!--
  - Prevent line break or hyphenation.
-->
<xsl:template match="nobr">
    <span style="white-space: nowrap;"><xsl:apply-templates/></span>
</xsl:template>

<!--
  - Put a line break.
-->
<xsl:template match="br">
    <br/>
</xsl:template>

<!-- page break -->
<xsl:template match="pagebreak"/>

<!--
  - Set a paragraph.
-->
<xsl:template match="p">
    <xsl:choose>
        <xsl:when test="title">
            <p><span class="title"><xsl:apply-templates select="title"/></span>
            <xsl:apply-templates select="title/following-sibling::*|title/following-sibling::text()"/></p>
        </xsl:when>
        <xsl:otherwise>
            <p><xsl:apply-templates/></p>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Hyphenation is ignored for html.
-->
<xsl:template match="y"/>

<!--
  - Place a label for a cross-reference.
-->
<xsl:template match="label">
    <a name="{generate-id()}" id="{generate-id()}"></a>
</xsl:template>

<!--
  - Print reference to section containing corresponding label.
-->
<xsl:template match="ref">
    <xsl:variable name="prefix">
        <xsl:for-each select="key('id', @idref)">
            <xsl:call-template name="ref.secprefix"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="ancestor::link">
            <xsl:value-of select="$prefix"/>
        </xsl:when>
        <xsl:when test="$prefix != ''">
            <xsl:for-each select="key('id', @idref)">
                <xsl:variable name="filename">
                    <xsl:call-template name="ref.filename"/>
                </xsl:variable>
                <a href="{$filename}#{generate-id()}"><xsl:value-of select="$prefix"/></a>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise><!-- do nothing --></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Prints the name of the file containing the referenced label.
-->
<xsl:template match="pageref">
    <xsl:variable name="filename">
        <xsl:for-each select="key('id', @idref)">
            <xsl:call-template name="ref.filename"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="ancestor::link">
            <xsl:value-of select="$filename"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:for-each select="key('id', @idref)">
                <a href="{$filename}#{generate-id()}"><xsl:value-of select="$filename"/></a>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Print text-nodes
-->
<xsl:template match="text()">
    <xsl:value-of select="."/>
</xsl:template>

<!--
  - Determine prefix of containing section.
-->
<xsl:template name="ref.secprefix">

    <xsl:choose>
        <xsl:when test="
            name() = 'abstract' or
            name() = 'preface' or
            name() = 'part' or
            name() = 'chapter' or
            name() = 'appendix' or
            name() = 'section' or
            name() = 'subsection' or
            name() = 'subsubsection' or
            name() = 'biblio' or
            name() = 'glossary' or
            name() = 'index'">
            <xsl:variable name="secnumdepth">
                <xsl:call-template name="util.secnumdepth"/>
            </xsl:variable>
            <xsl:variable name="curdepth">
                <xsl:call-template name="util.curdepth"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$curdepth = 0">
                    <xsl:text></xsl:text>
                </xsl:when>
                <xsl:when test="$secnumdepth >= $curdepth">
                    <xsl:call-template name="util.secprefix"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="parent::*">
                        <xsl:call-template name="ref.secprefix"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="name() = 'counter'">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="'counter'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="name() = 'figure'">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="'figure'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="name() = 'table'">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="'table'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="name() = 'equation'">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="'equation'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="name() = 'listing'">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="'listing'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="name() = 'li' and parent::ol">
            <xsl:call-template name="element.prefix">
                <xsl:with-param name="element" select="'li'"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:for-each select="parent::*">
                <xsl:call-template name="ref.secprefix"/>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Find the name of the file that contains the context node.
-->
<xsl:template name="ref.filename">

    <!-- current nesting depth -->
    <xsl:variable name="curdepth">
        <xsl:call-template name="util.curdepth"/>
    </xsl:variable>
    <!-- depth of chunking -->
    <xsl:variable name="secsplitdepth">
        <xsl:call-template name="util.secsplitdepth"/>
    </xsl:variable>
    
    <!-- recurse or print filename -->
    <xsl:choose>
        <xsl:when test="$secsplitdepth = 0">
            <xsl:text>index.html</xsl:text>
        </xsl:when>
        <xsl:when test="$curdepth > $secsplitdepth">
            <xsl:for-each select="parent::*">
                <xsl:call-template name="ref.filename"/>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="name() = 'preface'">
                    <xsl:text>preface</xsl:text>
                    <xsl:number count="preface"/>
                    <xsl:text>.html</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'index'">
                    <xsl:text>index</xsl:text>
                    <xsl:number count="index"/>
                    <xsl:text>.html</xsl:text>
                </xsl:when>
                <xsl:when test="
                    name() = 'abstract' or
                    name() = 'part' or
                    name() = 'chapter' or
                    name() = 'appendix' or
                    name() = 'section' or
                    name() = 'subsection' or
                    name() = 'subsubsection' or
                    name() = 'glossary' or
                    name() = 'biblio'">
                    <xsl:value-of select="name()"/>
                    <xsl:call-template name="util.secprefix"/>
                    <xsl:text>.html</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="parent::*">
                        <xsl:call-template name="ref.filename"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Get combined counter for element
-->
<xsl:template name="element.prefix">

    <xsl:param name="element"/>

    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>

    <xsl:choose>
        <!-- delegate for equation-->
        <xsl:when test="$element = 'equation'">
            <xsl:call-template name="equation.prefix"/>
        </xsl:when>
        <!-- delegate for numbered list item -->
        <xsl:when test="$element = 'li' and parent::ol">
            <xsl:call-template name="listitem.prefix"/>
        </xsl:when>

        <!-- generic template -->
        <xsl:when test="/article">
            <xsl:number value="count(preceding::*[name() = $element and descendant::caption]) + 1"/>        
        </xsl:when>
        <xsl:when test="$secnumdepth &lt;= 0 or ($secnumdepth &lt;= 1 and //part)">
            <xsl:text>0.</xsl:text>
            <xsl:number value="count(preceding::*[name() = $element and descendant::caption]) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::chapter">
            <xsl:value-of select="count(ancestor::chapter/preceding::chapter) + 1"/>
            <xsl:text>.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::chapter)"/>
            <xsl:number value="count(preceding::*[name() = $element and
                generate-id(ancestor::chapter) = $id
                and descendant::caption]) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::appendix">
            <xsl:number count="appendix" format="A"/>
            <xsl:text>.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::appendix)"/>
            <xsl:number value="count(preceding::*[name() = $element and
                generate-id(ancestor::appendix) = $id
                and descendant::caption]) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::section">
            <xsl:number count="section"/>
            <xsl:text>.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::section)"/>
            <xsl:number value="count(preceding::*[name() = $element and
                generate-id(ancestor::section) = $id
                and descendant::caption]) + 1"/>
        </xsl:when>
        <xsl:when test="ancestor::preface">
            <xsl:text>0.</xsl:text>
            <xsl:variable name="id" select="generate-id(ancestor::preface)"/>
            <xsl:number value="count(preceding::*[name() = $element and
                generate-id(ancestor::preface) = $id
                and descendant::caption]) + 1"/>
        </xsl:when>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
