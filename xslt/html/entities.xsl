<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:e="http://www.tojoko.de/ecmds/xmlns/entities">

<xsl:param name="global.entities" select="document('entities.xml')"/>

<!--
  - Set an entity reference
-->
<xsl:template match="entity">
    <xsl:variable name="key" select="@name"/>
    <xsl:variable name="value" select="$global.entities/entities/value[@key=$key]"/>
    <xsl:choose>
        <xsl:when test="$value">
            <xsl:apply-templates select="$value" mode="copy"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:message>Warning: unknown entity '<xsl:value-of select="$key"/>'.</xsl:message>
            <xsl:value-of select="$key"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="value" mode="copy">
    <xsl:copy-of select="child::*|text()"/>
</xsl:template>

</xsl:stylesheet>
