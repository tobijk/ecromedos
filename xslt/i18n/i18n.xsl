<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  - Load translations and settings from external file
-->
<xsl:param name="global.i18n" select="document('i18n.xml')"/>


<!--
  - Save doc's language, so we don't have to look this up each time.
-->
<xsl:variable name="global.locale">
    <xsl:choose>
        <xsl:when test="/*[1]/@lang">
            <xsl:value-of select="translate(normalize-space(/*[1]/@lang), '-', '_')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>en_US</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>


<!--
  - Extract language id
-->
<xsl:variable name="global.lang.id">
    <xsl:value-of select="substring-before($global.locale, '_')"/>
</xsl:variable>


<!--
  - Extract territory code
-->
<xsl:variable name="global.lang.territory">
    <xsl:value-of select="substring-after($global.locale, '_')"/>
</xsl:variable>


<!--
  - Print an automatic caption in document's language.
-->
<xsl:template name="i18n.print">

    <xsl:param name="key"/>
    <xsl:param name="number" select="''"/>
    <xsl:param name="context" select="''"/>
    <xsl:param name="class" select="name(/*[1])"/>

    <!-- get template -->
    <xsl:variable name="translation">
        <xsl:choose>
            <xsl:when test="$context and $global.i18n/i18n/language[@id =
                    $global.lang.id]/dictionary/translation[@key = $key and @context = $context]">
                <!-- context supplied -->
                <xsl:value-of select="$global.i18n/i18n/language[@id =
                    $global.lang.id]/dictionary/translation[@key = $key and @context = $context]"/>
            </xsl:when>
            <xsl:when test="$global.i18n/i18n/language[@id =
                    $global.lang.id]/dictionary/translation[@key = $key and @class = $class]">
                <!-- context supplied -->
                <xsl:value-of select="$global.i18n/i18n/language[@id =
                    $global.lang.id]/dictionary/translation[@key = $key and @class = $class]"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- no context means simple translation -->
                <xsl:value-of select="$global.i18n/i18n/language[@id =
                    $global.lang.id]/dictionary/translation[@key = $key and not(@context)]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- insert counter -->
    <xsl:choose>
        <xsl:when test="contains($translation, '%n')">
            <xsl:value-of select="substring-before($translation, '%n')"/>
            <xsl:value-of select="$number"/>
            <xsl:value-of select="substring-after($translation, '%n')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$translation"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!--
  - Returns list of babel language packages to load.
-->
<xsl:template name="i18n.babel.lang">
    <xsl:choose>
        <xsl:when test="$global.i18n/i18n/language[@id = 
            $global.lang.id]/settings[contains(@format, 'latex')]/babel[@territory = $global.lang.territory]">
                <xsl:value-of select="$global.i18n/i18n/language[@id = 
                    $global.lang.id]/settings[contains(@format, 'latex')]/babel[@territory = $global.lang.territory]"/>
        </xsl:when>
        <xsl:otherwise><!-- default -->
            <xsl:value-of select="$global.i18n/i18n/language[@id = 
            $global.lang.id]/settings[contains(@format, 'latex')]/babel[1]"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  - Returns name of selected babel language package.
-->
<xsl:template name="i18n.babel.select">
    <xsl:choose>
        <xsl:when test="$global.i18n/i18n/language[@id = 
            $global.lang.id]/settings[contains(@format, 'latex')]/babel[@territory = $global.lang.territory]">
                <xsl:value-of select="$global.i18n/i18n/language[@id = 
                    $global.lang.id]/settings[contains(@format, 'latex')]/babel[
                    @territory = $global.lang.territory]/select"/>
        </xsl:when>
        <xsl:otherwise><!-- default -->
            <xsl:value-of select="$global.i18n/i18n/language[@id = 
            $global.lang.id]/settings[contains(@format, 'latex')]/babel[1]/select"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
