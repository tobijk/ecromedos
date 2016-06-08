<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Puts an identifier superscript number in place of the footnote.
-->
<xsl:template match="footnote">
    <xsl:call-template name="footnote.mark"/>
</xsl:template>

<!--
  - Invoked from 'footnote.text'.
-->
<xsl:template match="footnote" mode="settext">
    <xsl:apply-templates/>
</xsl:template>

<!--
  - Leave a mark for a footnote.
--> 
<xsl:template name="footnote.mark">
    <xsl:variable name="sectid">
        <xsl:value-of select="generate-id(ancestor::*[not(name() = 'part')][last()-1])"/>
    </xsl:variable>
    <xsl:variable name="counter">
        <xsl:value-of select="count(preceding::footnote[ancestor::*[generate-id(self::*) = $sectid]]) + 1"/>
    </xsl:variable>
    <sup class="footnote">(<a href="#{generate-id()}" class="sup"><xsl:value-of select="$counter"/></a>)</sup>
</xsl:template>

<xsl:template name="footnote.text">
    <xsl:variable name="sectid">
        <xsl:value-of select="generate-id(ancestor::*[not(name() = 'part')][last()-1])"/>
    </xsl:variable>
    <xsl:if test="
        child::*[not(
            name() = 'chapter' or
            name() = 'section' or
            name() = 'subsection' or
            name() = 'subsubsection'
        )]//footnote">
        <hr class="above-footnote"/>
        <xsl:for-each select="
            child::*[not(
                name() = 'chapter' or
                name() = 'section' or
                name() = 'subsection' or
                name() = 'subsubsection'
            )]//footnote">
            <xsl:variable name="counter">
                <xsl:value-of select="count(preceding::footnote[ancestor::*[generate-id(self::*) = $sectid]]) + 1"/>
            </xsl:variable>
            <div class="footnote">
                <sup>(<a id="{generate-id()}" name="{generate-id()}"><xsl:value-of select="$counter"/></a>)</sup>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="." mode="settext"/>
            </div>
        </xsl:for-each>
        <hr class="below-footnote"/>
    </xsl:if>
</xsl:template>

<!--
  - Places a link in the page that serves as a reference point when
  - adjusting the actual marginal with javascript.
-->
<xsl:template match="marginal">
    <a id="a:{generate-id()}" name="a:{generate-id()}" class="marginal"></a>
</xsl:template>

<!--
  - Invoked from 'marginal.text'.
-->
<xsl:template match="marginal" mode="settext">
    <xsl:apply-templates/>
</xsl:template>


<!--
  - Inserts the javascript that aligns marginals along the vertical
  - position of the corresponding anchor in the document.
-->
<xsl:template name="marginal.script">

    <xsl:param name="curdepth"/>
    <xsl:param name="secsplitdepth"/>

    <script type="text/javascript">
        <xsl:comment>
            <xsl:variable name="num_marginals">
                <xsl:choose>
                    <xsl:when test="$secsplitdepth > $curdepth">
                        <xsl:value-of select="
                            count(child::*[not(
                                name() = 'section' or
                                name() = 'subsection' or
                                name() = 'subsubsection'
                            )]//marginal)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count(.//marginal)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            var mnotes = new Array(<xsl:value-of select="$num_marginals"/>);    
            <xsl:choose>
                <xsl:when test="$secsplitdepth > $curdepth">
                    <xsl:for-each select="
                        child::*[not(
                            name() = 'section' or
                            name() = 'subsection' or
                            name() = 'subsubsection'
                        )]//marginal">
                        mnotes[<xsl:value-of select="position() - 1"/>] = "<xsl:value-of select="generate-id()"/>";
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise test="$secsplitdepth > $curdepth">
                    <xsl:for-each select=".//marginal">
                        mnotes[<xsl:value-of select="position() - 1"/>] = "<xsl:value-of select="generate-id()"/>";
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>

            function update_margin() {

                var i, id, top, obj, anchor, div;

                for(i = 0; i &lt; <xsl:value-of select="$num_marginals"/>; i++) {

                    id = mnotes[i];
                    obj = document.getElementById("a:" + id);
                    div = document.getElementById("div:" + id);
                    top = 0;

                    while(obj.className != "textbody") {
                        top += obj.offsetTop;
                        obj = obj.offsetParent;
                    }

                    div.style.top = top + "px";
                }
            }
            
            window.onload = update_margin;
            window.onresize = update_margin;
        </xsl:comment>
    </script>
</xsl:template>

<!--
  - Place the marginals in the side column.
-->
<xsl:template name="marginal.text">
    <!-- parameters -->
    <xsl:param name="secsplitdepth"/>
    <xsl:param name="curdepth"/>

    <xsl:choose>
        <!-- excluding subsections -->
        <xsl:when test="$secsplitdepth > $curdepth">
            <xsl:for-each select="
                child::*[not(
                    name() = 'chapter' or
                    name() = 'section' or
                    name() = 'subsection' or
                    name() = 'subsubsection'
                )]//marginal">
                <div id="div:{generate-id()}" class="marginal">
                    <xsl:apply-templates mode="settext" select="."/>
                </div>
            </xsl:for-each>        
        </xsl:when>
        <!-- including subsections -->
        <xsl:otherwise>
            <xsl:for-each select=".//marginal">
                <div id="div:{generate-id()}" class="marginal">
                    <xsl:apply-templates mode="settext" select="."/>
                </div>
            </xsl:for-each>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Hyperlinks
-->
<xsl:template match="link">
    <xsl:variable name="url" select="@url"/>
    <xsl:variable name="idref" select="@idref"/>
    
    <xsl:choose>
        <xsl:when test="$url">
            <a href="{$url}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:when test="$idref">
            <xsl:variable name="filename">
                <xsl:for-each select="key('id', $idref)">
                    <xsl:call-template name="ref.filename"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="idnum">
                <xsl:for-each select="key('id', $idref)">
                    <xsl:value-of select="generate-id()"/>
                </xsl:for-each>
            </xsl:variable>
            <a href="{$filename}#{$idnum}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
