<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
 - Indexing all labels will speed up index building
 - and cross-referencing significantly.
-->
<xsl:key name="id" match="//*[@id]" use="@id"/>

</xsl:stylesheet>
