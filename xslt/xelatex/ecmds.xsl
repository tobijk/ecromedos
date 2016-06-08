<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../latex/main.xsl"/>
<xsl:param name="global.texdriver"/>
<xsl:param name="global.entities" select="document('entities.xml')"/>

<xsl:template name="latex.preamble.encoding">
    <!-- XeTeX understands unicode, so nothing to do here -->
</xsl:template>

<xsl:template name="latex.preamble.fonts">
    <xsl:text>\usepackage{fontspec}&#x0a;</xsl:text>
    <xsl:text>\usepackage{xunicode}&#x0a;</xsl:text>
    <xsl:text>\usepackage{pifont}&#x0a;</xsl:text>
    <!-- Computer Modern Unicode fonts are loaded, when available. If
    you wish to use specific system fonts, take a look at the "fontspec"
    package documentation -->
</xsl:template>

<xsl:template name="latex.preamble.misc">

    <xsl:text>\DeclareRobustCommand\em&#x0a;</xsl:text>
    <xsl:text>  {\@nomath\em&#x0a;</xsl:text>
    <xsl:text>   \edef\@tempa{\f@shape}%&#x0a;</xsl:text>
    <xsl:text>   \edef\@tempb{\itdefault}%&#x0a;</xsl:text>
    <xsl:text>   \ifx\@tempa\@tempb&#x0a;</xsl:text>
    <xsl:text>     \eminnershape&#x0a;</xsl:text>
    <xsl:text>   \else&#x0a;</xsl:text>
    <xsl:text>     \emshape&#x0a;</xsl:text>
    <xsl:text>   \fi}&#x0a;</xsl:text>
    <xsl:text>\DeclareTextFontCommand{\emph}{\em}&#x0a;</xsl:text>
    <xsl:text>\let\emshape\itshape&#x0a;</xsl:text>
    <xsl:text>\let\eminnershape\upshape&#x0a;&#x0a;</xsl:text>

    <xsl:text>&#x0a;</xsl:text>
    <xsl:text>\makeatletter&#x0a;</xsl:text>
    <xsl:text>\newlength\xxt@kern@Te&#x0a;</xsl:text>
    <xsl:text>\newlength\xxt@kern@eX&#x0a;</xsl:text>
    <xsl:text>\newlength\xxt@lower@e&#x0a;</xsl:text>
    <xsl:text>\newlength\xxt@kern@La&#x0a;</xsl:text>
    <xsl:text>\newlength\xxt@kern@aT&#x0a;</xsl:text>
    <xsl:text>\newlength\xxt@kern@eL&#x0a;</xsl:text>
    <xsl:text>\newcommand*\TeX@logo@spacing[6]{%&#x0a;</xsl:text>
    <xsl:text>  \setlength\xxt@kern@Te{#1}%&#x0a;</xsl:text>
    <xsl:text>  \setlength\xxt@kern@eX{#2}%&#x0a;</xsl:text>
    <xsl:text>  \setlength\xxt@lower@e{#3}%&#x0a;</xsl:text>
    <xsl:text>  \setlength\xxt@kern@La{#4}%&#x0a;</xsl:text>
    <xsl:text>  \setlength\xxt@kern@aT{#5}%&#x0a;</xsl:text>
    <xsl:text>  \setlength\xxt@kern@eL{#6}%&#x0a;</xsl:text>
    <xsl:text>}&#x0a;</xsl:text>
    <xsl:text>\DeclareRobustCommand\TeX{%&#x0a;</xsl:text>
    <xsl:text>  \leavevmode&#x0a;</xsl:text>
    <xsl:text>  \smash{%&#x0a;</xsl:text>
    <xsl:text>    T\kern\xxt@kern@Te&#x0a;</xsl:text>
    <xsl:text>    \lower\xxt@lower@e\hbox{E}\kern\xxt@kern@eX X}%&#x0a;</xsl:text>
    <xsl:text>  \spacefactor1000\relax}&#x0a;</xsl:text>
    <xsl:text>\DeclareRobustCommand{\LaTeX}{%&#x0a;</xsl:text>
    <xsl:text>  \leavevmode&#x0a;</xsl:text>
    <xsl:text>  \smash{%&#x0a;</xsl:text>
    <xsl:text>  L\kern\xxt@kern@La&#x0a;</xsl:text>
    <xsl:text>  {\sbox\z@ T%&#x0a;</xsl:text>
    <xsl:text>    \vbox to\ht\z@{\hbox{\check@mathfonts&#x0a;</xsl:text>
    <xsl:text>      \fontsize\sf@size\z@&#x0a;</xsl:text>
    <xsl:text>      \math@fontsfalse\selectfont&#x0a;</xsl:text>
    <xsl:text>      A}%&#x0a;</xsl:text>
    <xsl:text>    \vss}%&#x0a;</xsl:text>
    <xsl:text>  }%&#x0a;</xsl:text>
    <xsl:text>  \kern\xxt@kern@aT&#x0a;</xsl:text>
    <xsl:text>  \TeX}}&#x0a;</xsl:text>
    <xsl:text>\DeclareRobustCommand\XeTeX{%&#x0a;</xsl:text>
    <xsl:text>  \leavevmode&#x0a;</xsl:text>
    <xsl:text>  \smash{%&#x0a;</xsl:text>
    <xsl:text>   X\lower\xxt@lower@e&#x0a;</xsl:text>
    <xsl:text>   \hbox{\kern\xxt@kern@eX&#x0a;</xsl:text>
    <xsl:text>     \ifnum\XeTeXfonttype\font>0&#x0a;</xsl:text>
    <xsl:text>       \ifnum\XeTeXcharglyph"018E>0&#x0a;</xsl:text>
    <xsl:text>         \char"018E\relax&#x0a;</xsl:text>
    <xsl:text>       \else&#x0a;</xsl:text>
    <xsl:text>         \ifdim\fontdimen1\font=0pt&#x0a;</xsl:text>
    <xsl:text>           \reflectbox{E}%&#x0a;</xsl:text>
    <xsl:text>         \else&#x0a;</xsl:text>
    <xsl:text>           \XeTeXuseglyphmetrics=1%&#x0a;</xsl:text>
    <xsl:text>           \setbox0=\hbox{E}\dimen0=\ht0\advance\dimen0by\dp0%&#x0a;</xsl:text>
    <xsl:text>           \raise\dimen0\hbox{\rotatebox{180}{\box0}}%&#x0a;</xsl:text>
    <xsl:text>         \fi&#x0a;</xsl:text>
    <xsl:text>       \fi&#x0a;</xsl:text>
    <xsl:text>     \else&#x0a;</xsl:text>
    <xsl:text>       \setbox0=\hbox{E}\dimen0=\ht0\advance\dimen0by\dp0%&#x0a;</xsl:text>
    <xsl:text>       \raise\dimen0\hbox{\rotatebox{180}{\box0}}%&#x0a;</xsl:text>
    <xsl:text>     \fi&#x0a;</xsl:text>
    <xsl:text>   }\kern\xxt@kern@Te\TeX}}%&#x0a;</xsl:text>
    <xsl:text>\DeclareRobustCommand\XeLaTeX{%&#x0a;</xsl:text>
    <xsl:text>   \leavevmode&#x0a;</xsl:text>
    <xsl:text>   \smash{%&#x0a;</xsl:text>
    <xsl:text>    X\lower\xxt@lower@e&#x0a;</xsl:text>
    <xsl:text>    \hbox{\kern\xxt@kern@eX&#x0a;</xsl:text>
    <xsl:text>      \ifnum\XeTeXfonttype\font>0\relax&#x0a;</xsl:text>
    <xsl:text>        \ifnum\XeTeXcharglyph"018E>0\relax&#x0a;</xsl:text>
    <xsl:text>          \char"018E\relax&#x0a;</xsl:text>
    <xsl:text>        \else&#x0a;</xsl:text>
    <xsl:text>          \ifdim\fontdimen1\font=0pt\relax&#x0a;</xsl:text>
    <xsl:text>            \reflectbox{E}%&#x0a;</xsl:text>
    <xsl:text>          \else&#x0a;</xsl:text>
    <xsl:text>            \XeTeXuseglyphmetrics=1\relax&#x0a;</xsl:text>
    <xsl:text>            \setbox0=\hbox{E}\dimen0=\ht0\advance\dimen0by\dp0\relax&#x0a;</xsl:text>
    <xsl:text>            \raise\dimen0\hbox{\rotatebox{180}{\box0}}%&#x0a;</xsl:text>
    <xsl:text>          \fi&#x0a;</xsl:text>
    <xsl:text>        \fi&#x0a;</xsl:text>
    <xsl:text>      \else&#x0a;</xsl:text>
    <xsl:text>        \setbox0=\hbox{E}\dimen0=\ht0\advance\dimen0by\dp0\relax&#x0a;</xsl:text>
    <xsl:text>        \raise\dimen0\hbox{\rotatebox{180}{\box0}}%&#x0a;</xsl:text>
    <xsl:text>      \fi}\kern\xxt@kern@eL\LaTeX}}&#x0a;</xsl:text>
    <xsl:text>\TeX@logo@spacing{-0.15em}{-0.15em}{0.5ex}{-0.36em}{-0.15em}{-0.1em}&#x0a;</xsl:text>
    <xsl:text>\makeatother&#x0a;&#x0a;</xsl:text>
</xsl:template>

</xsl:stylesheet>
