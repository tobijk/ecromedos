<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- command line parameters -->
<xsl:param name="global.hyperref" select="'yes'"/>
<xsl:param name="global.lazydtp" select="'yes'"/>

<!--
  - Column mode
-->
<xsl:param name="global.columns">
    <xsl:choose>
        <xsl:when test="/*[1]/@columns">
            <xsl:value-of select="/*[1]/@columns"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:number select="1"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:param>

<!--
  - Generate preamble and initialize counters
-->
<xsl:template name="latex.prepare">
    <xsl:call-template name="latex.documentclass"/>
    <xsl:call-template name="latex.preamble"/>
    <xsl:call-template name="latex.babel.load"/>

    <xsl:variable name="tocdepth">
        <xsl:call-template name="util.tocdepth"/>
    </xsl:variable>
    <xsl:variable name="secnumdepth">
        <xsl:call-template name="util.secnumdepth"/>
    </xsl:variable>
    
    <!-- set depth of section numbering -->
    <xsl:text>\setcounter{secnumdepth}{</xsl:text>
        <xsl:call-template name="util.secdepth.translate">
            <xsl:with-param name="depth" select="$secnumdepth"/>
        </xsl:call-template>
    <xsl:text>}&#x0a;&#x0a;</xsl:text>
    <!-- set depth of toc listing -->
    <xsl:text>\setcounter{tocdepth}{</xsl:text>
        <xsl:call-template name="util.secdepth.translate">
            <xsl:with-param name="depth" select="$tocdepth"/>
        </xsl:call-template>
    <xsl:text>}&#x0a;&#x0a;</xsl:text>
</xsl:template>

<!--
  - Select LaTeX document class
-->
<xsl:template name="latex.documentclass">
    <xsl:param name="documentclass" select="name(/*[1])"/>

    <!-- start document class and set driver to load -->
    <xsl:text>\documentclass[captions=tableheading,</xsl:text>
    <xsl:if test="$global.texdriver">
        <xsl:value-of select="$global.texdriver"/><xsl:text>,</xsl:text>
    </xsl:if>
    <!-- font size -->
    <xsl:text>fontsize=</xsl:text>
    <xsl:choose>
        <xsl:when test="@fontsize">
            <xsl:value-of select="@fontsize"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>11pt</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <!-- paper size -->
    <xsl:choose>
        <xsl:when test="@papersize">
            <xsl:value-of select="@papersize"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>a4paper</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <!-- style: novel or scientific -->
    <xsl:choose>
        <xsl:when test="@parskip = 'off' or @parskip = 'no'">
            <!-- noop -->
        </xsl:when>
        <xsl:when test="@parskip = 'full'">
            <xsl:text>parskip=full,</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>parskip=half,</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <!-- number of columns -->
    <xsl:choose>
        <xsl:when test="@columns = 2">
            <xsl:text>twocolumn,</xsl:text>
        </xsl:when>
    </xsl:choose>
    <!-- document class and general options -->
    <xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/document-options"/>
    <xsl:choose>
        <xsl:when test="/book">
            <xsl:text>]{scrbook}&#x0a;&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="/article">
            <xsl:text>]{scrartcl}&#x0a;&#x0a;</xsl:text>
        </xsl:when>
        <xsl:when test="/report">
            <xsl:text>]{scrreprt}&#x0a;&#x0a;</xsl:text>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<!--
  - Insert some fixes for prevailing latex bugs
-->
<xsl:template name="latex.fixes">
    <!-- add here fixes for broken packages -->
</xsl:template>

<!--
  - Generate LaTeX document preamble
-->
<xsl:template name="latex.preamble">
    <xsl:param name="documentclass" select="name(/*[1])"/>

    <xsl:call-template name="latex.preamble.encoding"/>
    <xsl:call-template name="latex.preamble.fonts"/>

    <xsl:text>% Color and verbatim environment&#x0a;</xsl:text>
    <xsl:text>\usepackage{color}&#x0a;</xsl:text>
    <xsl:text>\usepackage{framed}&#x0a;</xsl:text>
    <xsl:text>\usepackage{colortbl}&#x0a;</xsl:text>
    <xsl:text>\usepackage{alltt}&#x0a;</xsl:text>
    <xsl:text>\newcommand{\rgbshadecolor}[3]{\definecolor{shadecolor}{rgb}{#1,#2,#3}}&#x0a;</xsl:text>
    <xsl:text>\newcommand{\rgbcolor}[4]{\textcolor[rgb]{#1,#2,#3}{#4}}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Make euro symbol available&#x0a;</xsl:text>
    <xsl:text>\usepackage[gen]{eurosym}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Load math environment&#x0a;</xsl:text>
    <xsl:text>\usepackage{amsmath}&#x0a;</xsl:text>
    <xsl:text>\usepackage{amsthm}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Disable extra space after fullstops&#x0a;</xsl:text>
    <xsl:text>\frenchspacing{}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Allows disabling hyphenation on demand&#x0a;</xsl:text>
    <xsl:text>\usepackage{hyphenat}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Redefine footnotes' appearance&#x0a;</xsl:text>
    <xsl:text>\renewcommand{\thefootnote}{(\arabic{footnote})}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Table stuff&#x0a;</xsl:text>
    <xsl:text>\usepackage{longtable}&#x0a;</xsl:text>
    <xsl:text>\usepackage{hhline}&#x0a;</xsl:text>
    <xsl:text>\usepackage{array}&#x0a;</xsl:text>
    <xsl:text>\usepackage{calc}&#x0a;</xsl:text>
    <xsl:text>\doublerulesepcolor{white}&#x0a;</xsl:text>
    <xsl:text>\newlength{\ecmdstablewidth}&#x0a;</xsl:text>
    <xsl:text>\newlength{\ecmdscolsep}&#x0a;</xsl:text>
     <xsl:text>\usepackage{multirow}&#x0a;&#x0a;</xsl:text>
 
    <xsl:text>% Environment for nested block elements&#x0a;</xsl:text>
    <xsl:text>\newenvironment{blockelement}{%&#x0a;</xsl:text>
    <xsl:text>\noindent\begin{trivlist}\item%&#x0a;</xsl:text>
    <xsl:text>}{%&#x0a;</xsl:text>
    <xsl:text>\end{trivlist}}%&#x0a;&#x0a;</xsl:text>

    <!-- spare length variable -->
    <xsl:text>\newlength{\ecmdstmplength}&#x0a;&#x0a;</xsl:text>
    
    <!-- used for indices -->
    <xsl:text>\usepackage{multicol}&#x0a;&#x0a;</xsl:text>

    <!-- activate bug fixes -->
    <xsl:call-template name="latex.fixes"/>

    <xsl:text>% Redefine paragraph&#x0a;</xsl:text>
    <xsl:text>\makeatletter&#x0a;</xsl:text>
    <xsl:text>\renewcommand{\paragraph}{\@startsection{paragraph}{4}{\z@}%&#x0a;</xsl:text>
    <xsl:text>    {-0ex\@plus -0.5ex \@minus -.2ex}%&#x0a;</xsl:text>
    <xsl:text>    {-1.5ex}%&#x0a;</xsl:text>
    <xsl:text>    {</xsl:text>
        <xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/paragraph-title"/>
    <xsl:text>}}&#x0a;</xsl:text>
    <xsl:text>\makeatother&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Minimal listing environment&#x0a;</xsl:text>
    <xsl:text>\usepackage{listing}&#x0a;</xsl:text>
    <xsl:text>\renewcommand{\listingname}{</xsl:text>
        <xsl:call-template name="i18n.print">
            <xsl:with-param name="key" select="'listing'"/>
        </xsl:call-template>
    <xsl:text>}&#x0a;</xsl:text>
    <xsl:text>\renewcommand{\listlistingname}{</xsl:text>
        <xsl:call-template name="i18n.print">
            <xsl:with-param name="key" select="'lol'"/>
        </xsl:call-template>
    <xsl:text>}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Unify the look of caption labels&#x0a;</xsl:text>
    <xsl:text>\usepackage[</xsl:text>
        <xsl:value-of select="$global.stylesheet/style/child::*[name() = $documentclass]/caption-setup"/>
    <xsl:text>]{caption}&#x0a;</xsl:text>
    <xsl:if test="/book or /report">
        <xsl:text>\renewcommand\thelisting{\thechapter.\arabic{listing}}&#x0a;&#x0a;</xsl:text>
    </xsl:if>

    <xsl:text>% Enable hyphenation of underlined text&#x0a;</xsl:text>
    <xsl:text>\usepackage[normalem]{ulem}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Graphics environment&#x0a;</xsl:text>
    <xsl:text>\usepackage{graphicx}&#x0a;&#x0a;</xsl:text>
        
    <xsl:text>% Inline objects&#x0a;</xsl:text>
    <xsl:text>\usepackage{wrapfig}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Enable custom page headers&#x0a;</xsl:text>
    <xsl:text>\usepackage{scrlayer-scrpage}&#x0a;</xsl:text>
    <xsl:text>\usepackage{scrhack}&#x0a;</xsl:text>

    <!-- explicitly set parskip/parindent -->
    <xsl:call-template name="util.setparskip"/>

    <xsl:text>% For per chapter overviews&#x0a;</xsl:text>
    <xsl:text>\usepackage[checkfiles,tight]{minitoc}&#x0a;&#x0a;</xsl:text>

    <xsl:text>% Floating environment&#x0a;</xsl:text>
    <xsl:text>\usepackage{float}&#x0a;</xsl:text>
    <xsl:text>\usepackage{flafter}&#x0a;&#x0a;</xsl:text>

    <xsl:if test="$global.hyperref='yes'">
        <xsl:text>\definecolor{ecmdslinkcolor}{rgb}{0.11,0.11,0.44}&#x0a;&#x0a;</xsl:text>
        <xsl:text>%Bookmarks, Links and URLs in PDF&#x0a;</xsl:text>
        <xsl:text>\usepackage[hyperindex=false,colorlinks=true,breaklinks=true,&#x0a;</xsl:text>
        <xsl:text>linkcolor=ecmdslinkcolor,anchorcolor=ecmdslinkcolor,citecolor=ecmdslinkcolor,&#x0a;</xsl:text>
        <xsl:text>bookmarksopen=true,bookmarksnumbered=true,filecolor=ecmdslinkcolor,&#x0a;</xsl:text>
        <xsl:text>menucolor=ecmdslinkcolor,urlcolor=ecmdslinkcolor</xsl:text>

        <!-- work around for xetex -->
        <xsl:if test="$global.texdriver != ''">
            <xsl:text>,unicode=true</xsl:text>
        </xsl:if>

        <!-- start meta info -->
        <xsl:text>,pdfcreator={</xsl:text><xsl:value-of select="$global.version"/><xsl:text>}</xsl:text>
        <!-- end meta info -->

        <xsl:text>]{hyperref}&#x0a;&#x0a;</xsl:text>
    </xsl:if>

    <xsl:text>% Recalculate layout&#x0a;</xsl:text>
    <xsl:text>\typearea[</xsl:text>
    <xsl:choose>
        <xsl:when test="@bcor">
            <xsl:value-of select="@bcor"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>0mm</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>]{</xsl:text>
    <xsl:choose>
        <xsl:when test="@div">
            <xsl:value-of select="@div"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>calc</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}&#x0a;&#x0a;</xsl:text>

    <xsl:if test="$global.lazydtp = 'yes'">
        <xsl:text>% Turn on lazy typesetting.&#x0a;</xsl:text>
        <xsl:text>\sloppy&#x0a;&#x0a;</xsl:text>
        <xsl:text>\clubpenalty=9999&#x0a;</xsl:text>
        <xsl:text>\widowpenalty=9999&#x0a;&#x0a;</xsl:text>
    </xsl:if>

    <xsl:call-template name="latex.preamble.misc"/>

</xsl:template>

<!--
  - Set input and font encoding, this is e.g. overwritten in
  - ../xelatex/ecmds.xsl
-->
<xsl:template name="latex.preamble.encoding">
    <xsl:text>% Set input- and fontencoding&#x0a;</xsl:text>
    <xsl:text>\usepackage[utf8]{inputenc}&#x0a;</xsl:text>
    <xsl:text>\usepackage[T1]{fontenc}&#x0a;&#x0a;</xsl:text>
</xsl:template>

<!--
  - Load PostScript fonts via fonts packages
-->
<xsl:template name="latex.preamble.fonts">
    <xsl:text>% Use postscript fonts&#x0a;</xsl:text>
    <xsl:text>\usepackage{pifont}&#x0a;</xsl:text>
    <xsl:text>\usepackage{textcomp}&#x0a;</xsl:text>
    <xsl:text>\usepackage{courier}&#x0a;</xsl:text>
    <xsl:text>\usepackage{helvet}&#x0a;</xsl:text>
    <xsl:text>\usepackage{lmodern}&#x0a;&#x0a;</xsl:text>
</xsl:template>

<!--
  - Overriding this allows customization and loading of additional packages
-->
<xsl:template name="latex.preamble.misc"/>

<!--
  - Load babel
-->
<xsl:template name="latex.babel.load">
    <!-- load babel languages -->
    <xsl:text>% Select babel language&#x0a;</xsl:text>
    <xsl:text>\usepackage[</xsl:text>
        <xsl:call-template name="i18n.babel.lang"/>
    <xsl:text>]{babel}&#x0a;&#x0a;</xsl:text>
</xsl:template>

<!--
  - Load hyphenation patterns and automatic titles for language
-->
<xsl:template name="latex.babel.select">
    <!-- babel and minitoc -->
    <xsl:text>\selectlanguage{</xsl:text>
        <xsl:call-template name="i18n.babel.select"/>
    <xsl:text>}&#x0a;&#x0a;</xsl:text>
    <xsl:text>\mtcselectlanguage{</xsl:text>
        <xsl:call-template name="i18n.babel.select"/>
    <xsl:text>}&#x0a;&#x0a;</xsl:text>
</xsl:template>

</xsl:stylesheet>
