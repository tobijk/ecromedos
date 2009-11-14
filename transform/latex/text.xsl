<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Date:    2006/03/09
 - Author:  Tobias Koch (tkoch@ecromedos.net)
 - License: GNU General Public License, version 2
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Quotation marks
-->
<xsl:template match="qq">
	<xsl:choose>
		<xsl:when test="not(ancestor::qq)">
			<xsl:text>{</xsl:text>
			<xsl:call-template name="i18n.print">
				<xsl:with-param name="key" select="'startquote'"/>
			</xsl:call-template>
			<xsl:text>}</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>{</xsl:text>
			<xsl:call-template name="i18n.print">
				<xsl:with-param name="key" select="'endquote'"/>
			</xsl:call-template>
			<xsl:text>}</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>{</xsl:text>
			<xsl:call-template name="i18n.print">
				<xsl:with-param name="key" select="'startnestedquote'"/>
			</xsl:call-template>
			<xsl:text>}</xsl:text>		
			<xsl:apply-templates/>
			<xsl:text>{</xsl:text>
			<xsl:call-template name="i18n.print">
				<xsl:with-param name="key" select="'endnestedquote'"/>
			</xsl:call-template>
			<xsl:text>}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="q">
	<xsl:text>{</xsl:text>
	<xsl:call-template name="i18n.print">
		<xsl:with-param name="key" select="'startsinglequote'"/>
	</xsl:call-template>
	<xsl:text>}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>{</xsl:text>
	<xsl:call-template name="i18n.print">
		<xsl:with-param name="key" select="'endsinglequote'"/>
	</xsl:call-template>
	<xsl:text>}</xsl:text>
</xsl:template>

<!--
  - Blockquote
-->
<xsl:template match="blockquote">
	<xsl:text>\begin{quote}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>\end{quote}</xsl:text>
</xsl:template>

<!--
  - Set verbatim text
-->
<xsl:template match="verbatim">
	<xsl:text>{\setlength{\topsep}{0ex}\begin{alltt}</xsl:text>
		<xsl:apply-templates/>
	<xsl:text>\end{alltt}}</xsl:text>
</xsl:template>

<!-- font size -->
<xsl:template match="xx-small">
	<xsl:text>{\scriptsize{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="x-small">
	<xsl:text>{\footnotesize{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="small">
	<xsl:text>{\small{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="medium">
	<xsl:text>{\normalsize{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="large">
	<xsl:text>{\large{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="x-large">
	<xsl:text>{\Large{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="xx-large">
	<xsl:text>{\LARGE{}</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- text in italics -->
<xsl:template match="i">
	<xsl:text>\textit{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- text in bold face -->
<xsl:template match="b">
	<xsl:text>\textbf{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- underlined text -->
<xsl:template match="u">
	<xsl:text>\uline{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
	<xsl:call-template name="footnotetext"/>
</xsl:template>

<!-- typewriter text -->
<xsl:template match="tt">
	<xsl:text>\nohyphens{\texttt{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}}</xsl:text>
</xsl:template>

<!-- text in superscript -->
<xsl:template match="sup">
	<xsl:text>\textsuperscript{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- text in subscript -->
<xsl:template match="sub">
	<xsl:text>\textsubscript{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- prevent line break or hyphenation -->
<xsl:template match="nobr">
	<xsl:text>\mbox{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- line break -->
<xsl:template match="br">
	<xsl:choose>
		<xsl:when test="ancestor::title or ancestor::head or ancestor::bibitem">
			<xsl:text>\\{}</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>\mbox{}\newline{}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- page break -->
<xsl:template match="pagebreak">
	<xsl:choose>
		<xsl:when test="ancestor::index">
			<xsl:text>\columnbreak{}</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>\pagebreak{}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- paragraph -->
<xsl:template match="p">
	<xsl:choose>
		<xsl:when test="title">
			<xsl:text>\paragraph*{</xsl:text>
			<xsl:apply-templates select="title"/>
			<xsl:text>} </xsl:text>
			<xsl:apply-templates select="title/following-sibling::*|title/following-sibling::text()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
	<!-- end paragraph -->
	<xsl:call-template name="text.end.para"/>
</xsl:template>

<!-- end paragraph -->
<xsl:template name="text.end.para">
	<xsl:choose>
		<xsl:when test="parent::legal">
			<xsl:text>\vspace{2ex}&#x0a;</xsl:text>
		</xsl:when>
		<xsl:when test="following-sibling::*[1][ name() = 'equation' ]">
			<xsl:text>%&#x0a;</xsl:text>
		</xsl:when>
		<xsl:when test="following-sibling::*">
			<xsl:text>&#x0a;&#x0a;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>%&#x0a;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- hyphenation -->
<xsl:template match="y">
	<xsl:text>\-</xsl:text>
</xsl:template>

<!-- cross-referencing -->
<xsl:template match="label">
	<xsl:text>\label{</xsl:text>
	<xsl:value-of select="@id"/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="ref">
	<xsl:variable name="idref" select="@idref"/>
	<xsl:choose>
		<xsl:when test="//counter[@id=$idref]">
			<xsl:for-each select="//counter[@id=$idref]">
				<xsl:call-template name="counter.prefix"/>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>\ref</xsl:text>
			<xsl:if test="ancestor::link and $cmdopt.hyperref = 'yes'">
				<xsl:text>*</xsl:text>
			</xsl:if>
			<xsl:text>{</xsl:text>
			<xsl:value-of select="@idref"/>
			<xsl:text>}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="pageref">
	<xsl:variable name="idref" select="@idref"/>
	<xsl:text>\pageref</xsl:text>
	<xsl:if test="ancestor::link and $cmdopt.hyperref = 'yes'">
		<xsl:text>*</xsl:text>
	</xsl:if>
	<xsl:text>{</xsl:text>
	<xsl:value-of select="@idref"/>
	<xsl:text>}</xsl:text>
</xsl:template>

<!--
  - Print text-nodes
-->
<xsl:template match="text()">
	<xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
